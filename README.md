## Software

+ CoppeliaSim 
+ Matlab 
+ Anaconda
+ Pycharm

## Task 1 - Self-Collision Avoidance

## Task 1.1 Check self-collision from specific joint configuration

+ open  [Task1.1 ttt](Task_1/Task1.1/Task1.1ttt)
+ open  [task 1_1.m](Task_1/Task1.1/task 1_1.m)

use Matlab Remote API
```
--  %% To use the remote API functionality in Matlab program
--  disp('Program started');
--  sim=remApi('remoteApi'); % call sim=remApi('remoteApi') to build the object and load the library.
--  sim.simxFinish(-1); % just in case, close all opened connections  
--  clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5); % matlab: clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5); 
 ```
+ The scene in CoppeliaSim starts autonomously and visualizes the task


## Task 1.2 Identify and avoid self-collision from given joint and Cartesian trajectories
### **1. Joint Pose**
+ load  [self_collision_specific_joint_poses.data](Task_1/Task1.2/self_collision_specific_joint_poses.data)
+ open  [Joint_poses.m](Task_1/Task1.2/Joint_poses.m)
```
joint_poses = importdata('self_collision_specific_joint_poses.data'); % Read seven joint informations
```
+ get  [joint_poses.txt](Task_1/Task1.2/joint_poses.txt)
+ open  [Take1.2_1.ttt](Task_1/Task1.2/Take1.2_1.ttt)
```
local fileName, err = io.open ("//Mac/Home/Desktop/Task1.2/date/joint_poses.txt","r")
```
+ The scene in CoppeliaSim starts autonomously and visualizes the task
### **2. Cartesian Pose**
+ load  [self_collision_target_cartesian_poses.data](Task_1/Task1.2/self_collision_target_cartesian_poses.data)
+ open  [Cartesian_poses.m](Task_1/Task1.2/JCartesian_poses.m)
```
target_cartesian_poses = importdata('self_collision_target_cartesian_poses.data')
```
+ get  [Cartesian_poses.txt](Task_1/Task1.2/Cartesian_poses.txt)
+ open  [Task1.2_2.ttt](Task_1/Task1.2/Task1.2_2.ttt)
```
local fileName, err = io.open ("//Mac/Home/Desktop/Task1.2/date/Cartesian_poses.txt","r")---can be changed
```
+ The scene in CoppeliaSim starts autonomously and visualizes the task

## Task 2 - Obstacle Avoidance

## Task 2.1  End-effector trajectory planning

+ open  [Task2.1.1.ttt](Task_2/Task2.1/Task2.1.1.ttt)
```
-- First control the robot end effector to move to the cylinder use IK(Inverse kinematics ) path.
-- Then grab the cylinder without colliding.
-- Grab the cylinder to rise to a certain height and finally return to the starting position use IK(Inverse kinematics ) path.
```
+ The scene in CoppeliaSim starts autonomously and visualizes the task
+ open [Task2.1.2.ttt](Task_2/Task2.1/Task2.1.2.ttt)
```
-- First control the robot end effector to move to the cylinder use OMPL path.
-- Then grab the cylinder without colliding.
-- Grab the cylinder to rise to a certain height use IK Path and finally return to the starting position use OMPL path.
```
+ The scene in CoppeliaSim starts autonomously and visualizes the task


## Task 2.2 Joint obstacle avoidance - exploiting null space

1. Train scenario : 2 obstacle balls with 3 cameras  

<img width="462" alt="image" src="https://github.com/RuanLinya/ROS/assets/133128176/fea3909d-d0dc-4ab4-b697-a0ef4f43dc66">

2. RLBench: Robot Learning Benchmark

<img width="612" alt="image" src="https://github.com/RuanLinya/ROS/assets/133128176/83f75709-cb92-4371-a305-2b66a3bcdda5">

![image](https://github.com/RuanLinya/ROS/assets/133128176/2f2eeb3e-9187-4eff-ab3f-55d7218150bc)


![image](https://github.com/RuanLinya/ROS/assets/133128176/24ba10b7-38e2-49a9-9856-37539298b4cf)

+ open [Task2.2.ttt](Task_2/Task2.2/Task2.2.ttt)
```
-- The end of the robotic arm grabs the cylinder and does not move. 
-- The ball randomly appears in the space.
-- Then all the joints of the robotic arm make plans in the 0 space to avoid obstacles.
```

## Task 2.3 Learning - vision-based obstacle avoidance (RLBench)
Configuration Environment
+ open [requirements.txt](Task_2/Task2.3/requirements.txt)
+ open [README.md](Task_2/Task2.3/README.md)
```
-- Configure the python environment according to README.md
```
+ open [robustness.py](Task_2/Task2.3/robustness.py)
```
-- Train model and test model environment
```
+ Best model [trained_model8.pt](Task_2/Task2.3/trained_model8.pt)
```
-- trained_model8 is the best model
```
## Task 3 - Bimanual Manipulation

## Task 3.1 End-effector trajectory planning
+ open [task3.1.ttt](Task_3/Task3.1/task3.1.ttt])
```
-- open scene file "task3.1", and click the "start" button.
-- In total there are two robotic arms that grasp the object using the end. The path planning is based on setting the start and end positions and using the coppeliasim's own physics engine to automatically select the best path.
However, as no knowledge of the code was gained regarding the detection of the grip time, only a fixed time was attempted to control the grip and release state.
```

## Task 3.2 Object manipulation
+ open  [FrankaGUI.m](Task_3/Task3.2/FRANKA-EMIKA(END)/FrankaGUI.m])
```
-- open "FRANKA-EMIKA(END)" Folder and find the matlab file " FrankaGUI.m".
-- Click on the green "run" button to bring up the GUI screen.
-- The initial position of the robot arm can be adjusted by sliding the slider on the right side of the GUI interface, the default position is the one given by the task.
-- As the model from coppeliasim was re-imported in Matlab, the axes have changed slightly.
-- The entire path planning is programmed to the end of the arm, so Matlab will automatically find the most suitable rotation angle for the arm joints to complete the set path.
```
## Presentation
Link to Google slides: [https://docs.google.com/presentation/d/1jSbcdMC1FOaKbArq3OT-ZhuipksUP3anw3qdW_-xemE/edit?usp=sharing](https://docs.google.com/presentation/d/1jSbcdMC1FOaKbArq3OT-ZhuipksUP3anw3qdW_-xemE/edit?usp=sharing)


## Video
Link to Google drive: [https://drive.google.com/drive/folders/1XcyYy84PQlKOu6cdwLAz8Z5vkIBBU3zU?usp=sharing](https://drive.google.com/drive/folders/1XcyYy84PQlKOu6cdwLAz8Z5vkIBBU3zU?usp=sharing)

## references
https://frankaemika.github.io/docs/libfranka.html  
https://www.coppeliarobotics.com/helpFiles/index.html
https://www.coppeliarobotics.com/helpFiles/en/inverseKinematicsTutorial.htm  
https://www.coppeliarobotics.com/helpFiles/en/simOMPL.htm  
https://github.com/stepjam/RLBench  
https://pytorch.org/tutorials/intermediate/reinforcement_q_learning.html

# Previous attempted versions
https://drive.google.com/drive/folders/1ijm35U29c2vp_wtkGqjkVRGNpTlzjtJp?usp=sharing
## Authors

- [@Linya Ruan] Matrikelnummer/Registrition number: 03728287
- [@Ziting Huang] Matrikelnummer/Registrition number: 03754936
- [@Qiliang Yu] Matrikelnummer/Registrition number: 03736675
