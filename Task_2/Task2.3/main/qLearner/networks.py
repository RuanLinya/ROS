import torch
import torch.nn as nn
from torch.distributions import MultivariateNormal


class NAF(nn.Module):

    def conv_model(self):
        con_in = nn.Sequential(
            nn.Conv2d(3, 16, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(16),
            nn.LeakyReLU(),
            nn.MaxPool2d(kernel_size=5, stride=2),

            nn.Conv2d(16, 32, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(32),
            nn.LeakyReLU(),
            nn.MaxPool2d(kernel_size=5, stride=2),

            nn.Conv2d(32, 64, kernel_size=3, stride=1),
            nn.BatchNorm2d(64),
            nn.LeakyReLU(),
            nn.MaxPool2d(kernel_size=5, stride=2),

        )

        con_out = nn.Sequential(
            nn.Conv2d(64, 128, kernel_size=3, stride=2, padding=1),
            nn.BatchNorm2d(128),
            nn.LeakyReLU(),
            nn.MaxPool2d(kernel_size=5, stride=2),
        )

        return con_in, con_out

    def conv_hidden(self):
        return nn.Sequential(
            nn.Conv2d(64, 64, kernel_size=3, stride=1, padding=1),
            nn.BatchNorm2d(64),
            nn.LeakyReLU(),
        )

    def hidden(self, hidden_size):
        return nn.Sequential(
            nn.Linear(hidden_size, hidden_size),
            nn.BatchNorm1d(hidden_size),
            nn.LeakyReLU()
        )

    def __init__(self, action_size, layer_size):
        super(NAF, self).__init__()

        self.front_in, self.front_out = self.conv_model()
        self.front_hidden = self.conv_hidden()
        self.left_in, self.left_out = self.conv_model()
        self.left_hidden = self.conv_hidden()
        self.right_in, self.right_out = self.conv_model()
        self.right_hidden = self.conv_hidden()

        self.action_size = action_size
        conv_latent_size = 128 * 3 + 7 + 7
        self.hidden1 = self.hidden(conv_latent_size)
        self.hidden2 = self.hidden(conv_latent_size)
        self.hidden3 = self.hidden(conv_latent_size)
        self.hidden4 = self.hidden(conv_latent_size)
        self.clas = nn.Sequential(
            nn.Linear(conv_latent_size, action_size),
            nn.BatchNorm1d(action_size),
        )

    def forward(self, x_cam, x_kin):
        x_front, _, x_left, x_right = x_cam.chunk(4, dim=1)

        x_front = self.front_in(x_front)
        x_front_temp = self.front_hidden(x_front)
        x_front = self.front_out(x_front + x_front_temp).flatten(1)

        x_left = self.left_in(x_left)
        x_left_temp = self.left_hidden(x_left)
        x_left = self.left_out(x_left + x_left_temp).flatten(1)

        x_right = self.right_in(x_right)
        x_right_temp = self.right_hidden(x_right)
        x_right = self.right_out(x_right + x_right_temp).flatten(1)

        input_ = torch.cat((x_front, x_left, x_right, x_kin), dim=1)

        action_range = 1
        input_temp = self.hidden1(input_)
        input_ = self.hidden2(input_ + input_temp)
        input_temp = self.hidden3(input_ + input_temp)
        input_ = self.hidden3(input_ + input_temp)
        action = torch.mul(self.clas(input_ + input_temp), action_range)

        dist = MultivariateNormal(action.squeeze(-1), torch.eye(self.action_size).to(input_.device))
        action_noise = dist.sample()

        return action_noise, action