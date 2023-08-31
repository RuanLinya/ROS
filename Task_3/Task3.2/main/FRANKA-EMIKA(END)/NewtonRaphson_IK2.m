function AngArray = NewtonRaphson_IK2(thetalist0,Tsd)

% »úÐµ±Û³ß´ç²ÎÊý
H1=0.333;H2=0.316;H3=0.384;H4=0.088;H5=0.207;H6 = 0.0825;
% Home Configuration of End-Effector 
M=[ 1  0  0 H4;
    0 -1  0 0;
    0  0 -1 H1+H2+H3-H5;
    0  0  0 1];  
%% Spatial Twist
Blist = [[0; 0; -1; 0; -H4; 0], ...
        [0; -1; 0; H2+H3-H5; 0; H4],...
        [0; 0; -1; 0; -H4; 0],...
        [0 ;1; 0; H5-H3; 0; H6-H4],...
        [0; 0; -1; 0; -H4;0],...
        [0; 1; 0; H5; 0; -H4],...
        [0; 0; 1; 0; 0; 0]];   %The joint screw axes in the end-effector frame

% w1 = Blist(1:3,1);v1 = Blist(4:6,1);
% w2 = Blist(1:3,2);v2 = Blist(4:6,2);
% w3 = Blist(1:3,3);v3 = Blist(4:6,3);
% w4 = Blist(1:3,4);v4 = Blist(4:6,4);
% w5 = Blist(1:3,5);v5 = Blist(4:6,5);
% w6 = Blist(1:3,6);v6 = Blist(4:6,6);
% w7 = Blist(1:3,7);v7 = Blist(4:6,7);
% 
% Tsd = M*EBT(pi/6,w1,v1)*EBT(pi/6,w2,v2)*EBT(pi/6,w3,v3)*EBT(pi/6,w4,v4)...
%       *EBT(pi/6,w5,v5)*EBT(pi/6,w6,v6)*EBT(pi/6,w7,v7);

% thetalist0 = [pi/6+0.1; pi/6+0.1; pi/6+0.1; pi/6+0.1; pi/6+0.1; pi/6+0.1; pi/6+0.1];


eomg = 0.0001;
ev = 0.00001;

[thetalist, success] = IKinBody(Blist, M, Tsd, thetalist0, eomg, ev);
AngArray = thetalist';

end


