%% TASK 1.2
%% convert .data to .txt
clear all;
close all;
clc;
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
    new_joint_position_char= erase(new_joint_position_char,'['); 
    new_joint_position_char= erase(new_joint_position_char,']');
    new_joint_position_char=['{',new_joint_position_char];
    new_joint_position_char(find(isspace(new_joint_position_char))) = [];
    joints_pos_str(i,:)= convertCharsToStrings(new_joint_position_char);
    %% ouput date
    fid=fopen('joint_poses.txt','wt');
    fprintf(fid,'%s \n',joints_pos_str);
end
