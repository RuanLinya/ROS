function T = rpy2rotm(px,py,pz,rx,ry,rz)

RX = [1 0       0;
      0 cos(rx) -sin(rx);
      0 sin(rx) cos(rx)];
RY = [cos(ry) 0 sin(ry);
      0       1 0;
     -sin(ry) 0 cos(ry)];
RZ = [cos(rz) -sin(rz) 0;
      sin(rz)  cos(rz) 0;
      0        0       1];
  
RPY = RZ*RY*RX;

P = [px;py;pz];

T = [RPY,P;0 0 0 1];

end
