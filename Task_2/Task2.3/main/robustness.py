# Standard imports
import numpy as np
import os

# Imports for the simulator
from rlbench.environment import Environment
from rlbench.action_modes.action_mode import MoveArmThenGripper
from rlbench.action_modes.arm_action_modes import EndEffectorPoseViaPlanning
from rlbench.action_modes.arm_action_modes import EndEffectorPoseViaIK
from rlbench.action_modes.gripper_action_modes import Discrete
from rlbench.observation_config import ObservationConfig
from rlbench.tasks import ReachTarget
from pyrep.objects.proximity_sensor import ProximitySensor
from pyrep.objects.shape import Shape

# Imports for the neural model
from qLearner import qAgent
from qLearner import training_tracker


def setup_env(headless=True, planning=True):
    # Set all unnecessary stuff to False to speed up simulation
    obs_config = ObservationConfig()
    obs_config.left_shoulder_camera.set_all(True)
    obs_config.right_shoulder_camera.set_all(True)
    obs_config.overhead_camera.set_all(False)
    obs_config.wrist_camera.set_all(True)
    obs_config.front_camera.set_all(True)
    obs_config.joint_velocities = True
    obs_config.joint_positions = True
    obs_config.joint_forces = True
    obs_config.gripper_open = True
    obs_config.gripper_pose = False
    obs_config.gripper_matrix = False
    obs_config.gripper_joint_positions = False
    obs_config.gripper_touch_forces = False
    obs_config.wrist_camera_matrix = False
    obs_config.task_low_dim_state = True

    if planning:
        arm_action_mode = EndEffectorPoseViaPlanning()
    else:
        arm_action_mode = EndEffectorPoseViaIK()
    action_mode = MoveArmThenGripper(
        arm_action_mode=arm_action_mode,
        gripper_action_mode=Discrete()
    )

    env = Environment(action_mode, obs_config=obs_config, headless=headless)
    env.launch()
    return env, env.get_task(ReachTarget)


def main():
    # ----------------------- SETUP SECTION ---------------------------------------

    # Setup up the simulator
    print('Starting simulation, do not touch the rabbit!')
    env, task = setup_env(headless=False, planning=True)  # Set headless=False to get an animation. (Slows down learning)

    # Setup of the agent
    print('Setting up the agent')
    save_model = False  # Do not set to true, model is trained already!
    model_dir = '/models/trained_model8.pt'
    load_model = True  # If not loaded it starts to train from scratch
    trained_model_dir ='/models/trained_model7.pt'   #can be changed
    predict_only_first = True  # If False, predicts the position in every step, gives worse results
    enable_demos = False  # If you want to See how a perfect motion would be
    demo_num = 2
    hparams = {
        "BATCH_SIZE": 32,
    }

    # Set up training
    tracker = training_tracker.Tracker(num_episodes=200,  # Either for training or for testing
                                       episode_length=1,  # Training length (1 for predict_only_first=True)
                                       enable_eval=False,  # Evaluation during training
                                       test_num=8,  # Amount of tests during eval cycles
                                       test_length=60,  # Size of the eval episodes
                                       test_intervals=32,  # Frequency of evaluation
                                       test_only=True  # False to learn, True to Demo only
                                       )

    # ----------------------- SETUP SECTION ---------------------------------------

    # Set up agent
    action_dim = 3
    layer_size = [150, 100, 50]  # If Change will have to retrain
    agent = qAgent.QAgent(action_dim, layer_size, hparams, load_model, model_dir=os.getcwd() + trained_model_dir)

    # Show some demos if enabled
    if enable_demos:
        print('----------- Showing task demos --------------')
        task.get_demos(demo_num, live_demos=enable_demos)

    print('----------- Main loop started --------------')
    try:
        terminate = False
        while tracker.episode_loop():
            # Check weather in eval or training mode
            tracker.trigger_eval(terminate)

            # Restarting the task
            _, obs = task.reset()
            terminate = False

            # Get the initial state
            state_kin = np.concatenate((obs.joint_positions, obs.joint_velocities), axis=None)
            state_cam = [obs.front_rgb, obs.front_rgb, obs.left_shoulder_rgb, obs.right_shoulder_rgb]
            agent.set_state(state_cam, state_kin, terminate)

            # Predict position of ball based only on the first image
            first_action = None
            if predict_only_first:
                first_action = agent.act_first_frame()

            # Loop over all the steps in an episode
            for step in tracker.episode_range():

                # Select action (The action is also stored inside agent)
                tip = task._robot.arm.get_tip()
                if not predict_only_first:
                    first_action = agent.act_first_frame()
                action = agent.act(first_action, tip.get_position(), tip.get_quaternion(),
                                   Shape('boundary').get_position(), Shape('boundary').get_bounding_box())

                # Simulate another step
                obs, _, terminate = task.step(action)

                # Calculate a label and track the distance to the ball
                tip_pos = tip.get_position()
                ball_pos = ProximitySensor('success').get_position()
                label = ball_pos
                reward_data = np.linalg.norm(tip_pos - ball_pos) * 100

                # Observe the environment, if terminal mark that there are no next states
                if not terminate:
                    next_state_cam = [obs.front_rgb, obs.front_rgb, obs.left_shoulder_rgb, obs.right_shoulder_rgb]
                    next_state_kin = np.concatenate((obs.joint_positions, obs.joint_velocities), axis=None)
                else:
                    next_state_cam = None
                    next_state_kin = None

                # Learn using the information gathered from the action
                if not tracker.evaluate_model:
                    agent.learn([state_cam, state_kin, next_state_cam, next_state_kin, label], terminate)
                else:
                    agent.set_state(next_state_cam, next_state_kin, terminate)
                    tracker.track_reward_step(reward_data, terminate)

                # Advance to the next state (Mirrors states in qAgent)
                state_cam = next_state_cam
                state_kin = next_state_kin

                # Terminate episode if reach the ball
                if terminate:
                    break

            # Track the distance to the ball in the evaluation steps and go to the next episode
            tracker.track_reward_episode()
            print('----------- Reset Episode --------------')

    finally:
        if save_model:
            agent.save_model(os.getcwd() + model_dir)
        agent.plot(limit=True, y_range=0.01)
        tracker.plot()

    # Close everything
    print('Simulation end')
    env.shutdown()


if __name__ == "__main__":
    main()
