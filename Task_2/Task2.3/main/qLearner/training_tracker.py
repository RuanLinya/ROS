import numpy as np
from matplotlib import pyplot as plt


class Tracker(object):

    def __init__(self, num_episodes, episode_length=1, enable_eval=False, test_num=8, test_length=60,
                 test_intervals=32, test_only=False):
        # Set up training
        self.num_episodes = num_episodes + 1
        self.episode_length = episode_length
        self.evaluate_model = False

        # Set up testing
        self.enable_eval = enable_eval
        self.test_num = test_num
        self.test_length = test_length
        self.test_intervals = test_intervals
        self.test_only = test_only

        # Set up help variables
        self.last_episode = 0
        self.episode = 1
        self.ratio = 0

        # Setup data logging
        self.avg_return = np.array([])
        self.reward_cont = np.array([])
        self.reward_episode_cont = np.array([])
        self.test_reaching = 0

    def episode_loop(self):
        return self.episode < self.num_episodes

    def episode_range(self):
        return range(self.episode_length)

    def eval_model(self):
        return self.evaluate_model

    def track_reward_step(self, reward_data, terminate):
        self.reward_episode_cont = np.append(self.reward_episode_cont, reward_data)
        if terminate:
            self.ratio += 1

    def track_reward_episode(self):
        if self.evaluate_model:
            self.reward_cont = np.append(self.reward_cont, np.mean(self.reward_episode_cont))
        self.episode += 1

    def plot(self):
        plt.plot(self.avg_return)
        plt.title('Average distance between ball and robot tip per eval round')
        plt.xlabel('Evaluation round #')
        plt.ylabel('Avg. distance (cm)')
        plt.show()

    def trigger_eval(self, terminate):
        if not self.test_only:
            if self.episode % self.test_num == 0 and self.evaluate_model is True and self.enable_eval is True:
                self.evaluate_model = False
                self.episode = self.last_episode + 1
                print('RESULTS: Avg. distance to target: ', np.mean(self.reward_cont), 'cm')
                self.avg_return = np.append(self.avg_return, np.mean(self.reward_cont))
                self.reward_cont = np.array([])
                print('RESULTS: Success rate: ', self.ratio / self.test_num * 100, '%')
                self.ratio = 0
                self.episode_length = 1
                print('<<<<<<<<<<<<<< Resume training >>>>>>>>>>>>>>>>>>>')
            elif self.episode % self.test_intervals == 0 and self.evaluate_model is False and self.enable_eval is True:
                self.evaluate_model = True
                self.last_episode = self.episode
                self.episode = 1
                self.episode_length = self.test_length
                print('<<<<<<<<<<<<<< Testing for progress >>>>>>>>>>>>>>>>>>>')
        else:
            self.evaluate_model = True
            self.episode_length = self.test_length
            if self.episode is not 1:
                if terminate:
                    self.test_reaching += 1
                print('Success rate: ', self.test_reaching / (self.episode - 1) * 100, '%')

        # Tracking
        if self.evaluate_model is False:
            print('Episode number: ', self.episode)
        else:
            print('Test number: ', self.episode)

        self.reward_episode_cont = np.array([])
