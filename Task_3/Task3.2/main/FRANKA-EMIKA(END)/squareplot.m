function [vertices_matrix,faces_matrix] = squareplot(a,b,c)

%% 生成方形实体数据

% a = 1;    % 方形的长（默认x方向）
% b = 1;    % 方形的宽（默认y方向）
% c = 1;    % 方形的高（默认z方向）

% a = 1;b = 1;c = 1;
x = [0 a a 0 0 a a 0];
y = [0 0 b b 0 0 b b];
z = [0 0 0 0 c c c c];

vertices_matrix = [x',y',z'];

faces_matrix_1 = zeros(6,3);
faces_matrix_2 = zeros(6,3);

for i=1:(size(vertices_matrix,1)-2)/2
    faces_matrix_1(i,:) = [i,4+i,4+i+1];
    faces_matrix_2(i,:) = [4+i+1,i,i+1];
end
faces_matrix_1(4,:) = [4,5,1];
faces_matrix_2(4,:) = [4,5,8];
faces_matrix_1(5,:) = [1,2,3];
faces_matrix_2(5,:) = [1,3,4];
faces_matrix_1(6,:) = [5,6,7];
faces_matrix_2(6,:) = [5,7,8];
faces_matrix = [faces_matrix_1;faces_matrix_2];

% figure,patch('vertices', vertices_matrix,'faces',faces_matrix,'facecolor','g');
% axis equal