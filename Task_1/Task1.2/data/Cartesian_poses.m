%% TASK 1.2
%% convert .data to .txt
clear all;
close all;
clc;


%% Each movement of the robotic arm requires seven joint information
target_cartesian_poses = importdata('self_collision_target_cartesian_poses.data');  % Read seven joint informations

%% Input all joint poses
n = length(target_cartesian_poses);
joint_position = zeros(n,16);
for i = 1 : n
    target_cartesian_poses_char = convertCharsToStrings(target_cartesian_poses(i));
%% remove redundant symbols
    new_target_cartesian_poses_char = strsplit(target_cartesian_poses_char,':');
    new_target_cartesian_poses_char = new_target_cartesian_poses_char{1,2};
    new_target_cartesian_poses_char= erase(new_target_cartesian_poses_char,'['); 
    new_target_cartesian_poses_char= erase(new_target_cartesian_poses_char,']');
    new_target_cartesian_poses_char=['{',new_target_cartesian_poses_char];
    new_target_cartesian_poses_char(find(isspace(new_target_cartesian_poses_char))) = [] ;
    target_cartesian_poses_str(i,:)= convertCharsToStrings(new_target_cartesian_poses_char);
    %% ouput date
    fid=fopen('Cartesian_poses.txt','wt');
    fprintf(fid,'%s \n',target_cartesian_poses_str);
end
