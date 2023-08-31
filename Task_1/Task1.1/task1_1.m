%% TASK 1.1
%% Check self-collision from specific joint configuration
clear all;
close all;
clc;

%% To use the remote API functionality in Matlab program
disp('Program started');
sim=remApi('remoteApi'); %  call sim=remApi('remoteApi') to build the object and load the library.
sim.simxFinish(-1); % just in case, close all opened connections
clientID=sim.simxStart('127.0.0.1',19999,true,true,5000,5); % matlab: clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5); 

%% Each movement of the robotic arm requires seven joint information
joint_poses = importdata('self_collision_specific_joint_poses.data');  % Read seven joint informations

%% Input all joint poses
n = length(joint_poses);
joint_position = zeros(n,7);
for i = 1 : n
    joint_position_char = convertCharsToStrings(joint_poses(i));
%% remove redundant symbols
    new_joint_position_char = strsplit(joint_position_char,':');
    new_joint_position_char = new_joint_position_char{1,2};
    new_joint_position_char = erase(new_joint_position_char,'['); 
    new_joint_position_char = erase(new_joint_position_char,']');
    new_joint_position_char = erase(new_joint_position_char,'}');  
%%  Extract joint positions
    joints_pos_str= convertCharsToStrings(new_joint_position_char );
    joints_pos_str= str2num(joints_pos_str);
    joint_position(i,:)= joints_pos_str ;
end
%%
if (clientID>-1)
    disp('Connected to remote API server');
%% Retrieve some handles
    h = [0, 0, 0, 0, 0, 0];
 %% ret, targetObj = sim.simxGetObjectHandle(clientID, 'Quadricopter_target', sim.simx_opmode_blocking)
        [r, h(1)] = sim.simxGetObjectHandle(clientID,'Franka_joint1',sim.simx_opmode_blocking); % Get the target point handle
        [r, h(2)] = sim.simxGetObjectHandle(clientID,'Franka_joint2',sim.simx_opmode_blocking);
        [r, h(3)] = sim.simxGetObjectHandle(clientID,'Franka_joint3',sim.simx_opmode_blocking);
        [r, h(4)] = sim.simxGetObjectHandle(clientID,'Franka_joint4',sim.simx_opmode_blocking);
        [r, h(5)] = sim.simxGetObjectHandle(clientID,'Franka_joint5',sim.simx_opmode_blocking);
        [r, h(6)] = sim.simxGetObjectHandle(clientID,'Franka_joint6',sim.simx_opmode_blocking);
        [r, h(7)] = sim.simxGetObjectHandle(clientID,'Franka_joint7',sim.simx_opmode_blocking);
%%  check for 170 joint postions,ob is there a self collision
        results = strings(n,1);
        for i = 1 : n
            this_pos = joint_position(i,:); % get position
            for j = 1 : 7
                sim.simxSetJointPosition(clientID,h(j),this_pos(j),sim.simx_opmode_oneshot);% change pose
            end
            r =sim.simxSynchronous(clientID,sim.simx_opmode_blocking); % start the simulation:
            %% Save Result
            [r, state_self] = sim.simxGetIntegerSignal(clientID,'co_self',sim.simx_opmode_blocking);
            if state_self
                [r, collisionP1] = sim.simxGetStringSignal(clientID,'collection1',sim.simx_opmode_blocking);
                [r, collisionP2] = sim.simxGetStringSignal(clientID,'collection2',sim.simx_opmode_blocking);
                X1 = "collision: True";
                a = string(collisionP1);
                b = string(collisionP2);
                X2 = "collision Group:" + string(i) +' '+ a +' '+ b;
                results(i) = X2;
    else
        results(i) = "collision: False"; 
    end
            
        end
        writematrix(results,'results_self_collision.csv'); % output results of self collision
        sim.simxStopSimulation(clientID,sim.simx_opmode_blocking);% stop the simulation:     
        sim.simxFinish(clientID); % Now close the connection to CoppeliaSim:    
else
        disp('Failed connecting to remote API server');
end
sim.delete(); % call the destructor!

disp('Program ended');