function [vertices_matrix,faces_matrix] = arrowplot(a,b,c,d,N)

%% ���ɼ�ͷʵ������

% a = 0.1;  % ��βԲ���뾶
% b = 5;    % ��βԲ������
% c = 1;    % ��ͷԲ��뾶
% d = 2;    % ��ͷԲ����׶�����ĸ߶�

theta=linspace(0,2*pi,N);

%% �������ݵ�
x1 = a*cos(theta);
y1 = a*sin(theta);
z1 = ones(1,length(theta))*0;

x2 = a*cos(theta);
y2 = a*sin(theta);
z2 = ones(1,length(theta))*b;

% ��ͷ�˲�
x3 = c*cos(theta);
y3 = c*sin(theta);
z3 = ones(1,length(theta))*b;

% ��ͷ����
x4 = 0;
y4 = 0;
z4 = b+d;
%%

%% ���ɼ�ͷmesh����
vertices_matrix1 = [[x4,x3]',[y4,y3]',[z4,z3]'];
 faces_matrix1 = zeros(size(vertices_matrix1,1)-2,3);
for i=1:size(vertices_matrix1,1)-2
     faces_matrix1(i,:) = [1,i+1,i+2];
end

%% ���ɼ�βmesh����
vertices_matrix2 = [[x1,x2]',[y1,y2]',[z1,z2]'];
faces_matrix2_1 = zeros(size(vertices_matrix2,1)/2-1,3);
faces_matrix2_2 = zeros(size(vertices_matrix2,1)/2-1,3);
for i=1:(size(vertices_matrix2,1)-2)/2
    faces_matrix2_1(i,:) = [i,size(vertices_matrix2,1)/2+i,size(vertices_matrix2,1)/2+i+1];
    faces_matrix2_2(i,:) = [size(vertices_matrix2,1)/2+i+1,i,i+1];
end
faces_matrix2 = [faces_matrix2_1;faces_matrix2_2];

%% ��ͷ��βmesh���ݺϲ�
vertices_matrix = [vertices_matrix1;vertices_matrix2];
faces_matrix = [faces_matrix1;faces_matrix2+size(vertices_matrix1,1)];

% figure,patch('vertices', vertices_matrix,'faces',faces_matrix,'facecolor','g');
% axis equal

