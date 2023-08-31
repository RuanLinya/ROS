ed = 0.1;
A12 = [0.4, 0.6, 0.8];
A2 = [0.4, 0, 0.8];
P2 = Interpolation(A12,A2,ed);
Pend = P2(end,:)
P3 = P2(end,:)+zeros(5,3)
P = [P2;P3],1
Pt1 = Interpolation([0,0,0],[0,-0.6,0],0.1)