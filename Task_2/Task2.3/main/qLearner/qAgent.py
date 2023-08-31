# Util imports
import math
import numpy as np
from matplotlib import pyplot as plt

# Model imports
import torch
import torch.nn as nn
import torch.optim as optim
import torch.optim.lr_scheduler as schedules

# Local imports
from . import utils, networks, replayMemory


class QAgent(object):

    def __init__(self, action_size, layer_size, hparams, load_model, model_dir=''):

        # Set up variables
        self.action_size = action_size
        self.hparams = hparams
        self.state_cam = None
        self.state_kin = None
        self.action = None

        # Set up the device
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        print("You are using the: GPU" if torch.cuda.is_available() else "You are using the: CPU")

        # Set up policy network
        if load_model:
            self.policy = torch.load(model_dir).to(self.device)
        else:
            self.policy = networks.NAF(self.action_size, layer_size).to(self.device)
        self.policy.eval()

        # Set up RL
        self.optimizer = optim.RMSprop(self.policy.parameters(),lr=0.000001,alpha=0.99,eps=1e-8,weight_decay=0,momentum=0,centered=False)
        self.scheduler = None
        self.scheduler = schedules.MultiStepLR(self.optimizer, milestones=[10,30,80], gamma=0.1,last_epoch=-1)
        self.memory = replayMemory.ReplayMemory(10000)
        self.opt_counter = 0
        self.batch_counter = 0

        # Set up data plotting
        self.data = np.array([])

    def save_model(self, model_dir):
        torch.save(self.policy.cpu(), model_dir)

    def select_action(self):
        with torch.no_grad():
            _, action = self.policy(self.state_cam, self.state_kin)
            action = action.squeeze()

        self.action = action
        return action

    def act_first_frame(self):
        # Selection of action
        return self.select_action().cpu().numpy()

    def act(self, action, tip_pos, tip_quat, box_pos, corners):

        # Calculate motion relative to tip_pos
        tau = 10 * 3.6  # Make the step small for numerical stability in the IK algorithm
        arm_dir = action - tip_pos
        arm_temp = arm_dir / (np.linalg.norm(arm_dir) * tau) + tip_pos

        # Check that the motion is within the target boundary (Only relevant if using planning)
        min_range = np.concatenate((corners[0], corners[2], corners[4]), axis=None) * 0.99 + box_pos
        max_range = np.concatenate((corners[1], corners[3], corners[5]), axis=None) * 0.99 + box_pos
        arm_temp[arm_temp < min_range] = min_range[arm_temp < min_range]
        arm_temp[arm_temp > max_range] = max_range[arm_temp > max_range]

        # Formatting and result
        arm = arm_temp
        gripper = [1.0]  # Always open
        return np.concatenate([arm, tip_quat, gripper], axis=-1)
    #training loop
    def optimize(self):
        # Set up help variables
        BATCH_SIZE = self.hparams['BATCH_SIZE']
        if len(self.memory) < BATCH_SIZE or self.batch_counter < BATCH_SIZE:
            # if len(self.memory) < BATCH_SIZE:
            self.batch_counter += 1
            return
        else:
            self.opt_counter += 1
            print("Optimization", self.opt_counter)

        self.batch_counter = 0

        # Transpose the batch
        transitions = self.memory.sample(BATCH_SIZE)

        #To transition of batch arrays
        batch = replayMemory.Transition(*zip(*transitions))

        # Get the actual batches
        state_cam_batch = torch.cat(batch.state_cam)
        state_kin_batch = torch.cat(batch.state_kin)
        reward_batch = torch.cat(batch.reward)

        # Compute pi(s) for the state values
        self.policy.train()
        _, action_batch = self.policy(state_cam_batch, state_kin_batch)

        # Compute the loss
        criterion = nn.MSELoss()
        loss = criterion(action_batch, reward_batch)
        loss_val = loss.detach().cpu().numpy()
        self.data = np.append(self.data, loss_val)
        print('Loss: ', loss_val)

        # Optimize the model
        self.optimizer.zero_grad()
        loss.backward()
        self.optimizer.step()
        self.policy.eval()

    def pytorch_formatting(self, transition, terminate):
        [state_cam, state_kin, next_state_cam, next_state_kin, reward] = transition

        # Format state variables
        state_front, state_wrist, state_left, state_right = state_cam
        state_front = utils.to_tensor(state_front).to(self.device)
        state_wrist = utils.to_tensor(state_wrist).to(self.device)
        state_left = utils.to_tensor(state_left).to(self.device)
        state_right = utils.to_tensor(state_right).to(self.device)
        state_cam = torch.cat((state_front, state_wrist, state_left, state_right), 1)
        state_kin = torch.from_numpy(state_kin).to(self.device).unsqueeze(0).float()

        # Format action variable
        action = self.action.unsqueeze(0)

        # Format reward variable
        reward = torch.from_numpy(reward).to(self.device).unsqueeze(0).float()

        # Format next state variables
        if not terminate:
            next_state_front, next_state_wrist, next_state_left, next_state_right = next_state_cam
            next_state_front = utils.to_tensor(next_state_front).to(self.device)
            next_state_wrist = utils.to_tensor(next_state_wrist).to(self.device)
            next_state_left = utils.to_tensor(next_state_left).to(self.device)
            next_state_right = utils.to_tensor(next_state_right).to(self.device)
            next_state_cam = torch.cat((next_state_front, next_state_wrist, next_state_left, next_state_right), dim=1)
            next_state_kin = torch.from_numpy(next_state_kin).to(self.device).unsqueeze(0).float()

        return [state_cam, state_kin, action, next_state_cam, next_state_kin, reward]

    def learn(self, transition, terminate):

        # Format variables
        state_cam, state_kin, action, next_state_cam, next_state_kin, reward = self.pytorch_formatting(transition,
                                                                                                       terminate)
        # Store in memory
        self.memory.push(state_cam, state_kin, action, next_state_cam, next_state_kin, reward)

        # Move to the next state
        self.state_cam = next_state_cam
        self.state_kin = next_state_kin

        # Optimize the model
        self.optimize()

    def set_state(self, state_cam, state_kin, terminate):
        # Format state variables
        if not terminate:
            state_front, state_wrist, state_left, state_right = state_cam
            state_front = utils.to_tensor(state_front).to(self.device)
            state_wrist = utils.to_tensor(state_wrist).to(self.device)
            state_left = utils.to_tensor(state_left).to(self.device)
            state_right = utils.to_tensor(state_right).to(self.device)
            state_cam = torch.cat((state_front, state_wrist, state_left, state_right), 1)
            state_kin = torch.from_numpy(state_kin).to(self.device).unsqueeze(0).float()

        # Save set state_variables
        self.state_cam = state_cam
        self.state_kin = state_kin

    def plot(self, limit=False, y_range=1):
        plt.plot(self.data)
        if limit:
            plt.ylim([0, y_range])
        plt.title('MSE Loss of predicted vs. actual ball position')
        plt.xlabel('Optimization')
        plt.ylabel('Error (m)')
        plt.show()