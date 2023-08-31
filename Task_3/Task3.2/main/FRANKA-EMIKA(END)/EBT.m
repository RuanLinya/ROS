function T = EBT(theta,w,v)

% 生成位姿齐次矩阵

Rw = [0 -w(3) w(2);
      w(3) 0 -w(1);
      -w(2) w(1) 0];
I = [1 0 0;0 1 0;0 0 1];
R = I+sin(theta)*Rw+(1-cos(theta))*Rw*Rw;

p = (I*theta+(1-cos(theta))*Rw+(theta-sin(theta))*Rw*Rw)*v;

T = [R p;0 0 0 1];

end

