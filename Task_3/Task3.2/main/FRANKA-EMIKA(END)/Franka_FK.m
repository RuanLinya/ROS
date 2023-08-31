function [PosAtt,T01,T02,T03,T04,T05,T06,T07] = Franka_FK(theta1,theta2,theta3,theta4,theta5,theta6,theta7,Ttool)

%% 正解，生成位姿向量和各轴齐次矩阵

% theta a d alpha
DH = [theta1,  0,         0.333,       0;
      theta2,  0,         0,         -(pi)/2;
      theta3,  0,         0.316,      (pi)/2;
      theta4,  0.0825,    0,          (pi)/2;
      theta5,  -0.0825,   0.384,     -(pi)/2;
      theta6,  0,         0,          (pi)/2;
      theta7,  0.088,     0,          (pi)/2];
        
T = diag([1,1,1,1]);
T01 = zeros(4,4);
T02 = zeros(4,4);
T03 = zeros(4,4);
T04 = zeros(4,4);
T05 = zeros(4,4);
T06 = zeros(4,4);
T07 = zeros(4,4);


for i=1:length(DH(:,1))
    
    Temp = [cos(DH(i,1))              -sin(DH(i,1))               0             DH(i,2);
            sin(DH(i,1))*cos(DH(i,4))  cos(DH(i,1))*cos(DH(i,4)) -sin(DH(i,4)) -DH(i,3)*sin(DH(i,4));
            sin(DH(i,1))*sin(DH(i,4))  cos(DH(i,1))*sin(DH(i,4))  cos(DH(i,4))  DH(i,3)*cos(DH(i,4));
            0                       0                        0            1];
    T = T*Temp;
    
    if (i==1)
        T01 = T;
    elseif (i==2)
        T02 = T;
    elseif (i==3)
        T03 = T;
    elseif (i==4)
        T04 = T;
    elseif (i==5)
        T05 = T;
    elseif (i==6)
        T06 = T;
    else
        T07 = T;
    end
end

T07_temp = T07*Ttool;
T07 = T07*rpy2rotm(0,0,0,0,0,pi/4);

px = T07_temp(1,4);
py = T07_temp(2,4);
pz = T07_temp(3,4);
rpy = rotm2rpy(T07_temp(1:3,1:3));
rx = rpy(1);
ry = rpy(2);
rz = rpy(3);

PosAtt = [px py pz rx ry rz];

end

