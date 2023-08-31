%{
Function: rotm2rpy
Description: 旋转矩阵R转rpy， R= rotz(c) * roty(b) * rotx(a)
Input: 旋转矩阵R
Output: rpy角度(单位rad)
Author: Marc Pony(marc_pony@163.com)
%}
function rpy = rotm2rpy( R )

% if abs(R(3 ,1) - 1.0) < 1.0e-15   % singularity
%     a = 0.0;
%     b = -pi / 2.0;
%     c = atan2(-R(1, 2), -R(1, 3));
% elseif abs(R(3, 1) + 1.0) < 1.0e-15   % singularity
%     a = 0.0;
%     b = pi / 2.0;
%     c = -atan2(R(1, 2), R(1, 3));
% else
%     a = atan2(R(3, 2), R(3, 3));
%     c = atan2(R(2, 1), R(1, 1));
%     %     a = atan2(-R(3, 2), -R(3, 3));  %a另一个解
%     %     c = atan2(-R(2, 1), -R(1, 1));  %c另一个解
%     cosC = cos(c);
%     sinC = sin(c);
%     
%     if abs(cosC) > abs(sinC)
%         b = atan2(-R(3, 1), R(1, 1) / cosC);
%     else
%         b = atan2(-R(3, 1), R(2, 1) / sinC);
%     end
% end
% 
% rpy = [a, b, c];

rpy = zeros(1,3);
% old ZYX order (as per Paul book)
eps = 1.0e-15;%eps表示从 1.0 到下一个最大单精度数的距离
if abs(abs(R(3,1)) - 1) < eps  % when |R31| == 1
    % singularity

    rpy(1) = 0;     % roll is zero
    if R(3,1) < 0
        rpy(3) = -atan2(R(1,2), R(1,3));  % R-Y
    else
        rpy(3) = atan2(-R(1,2), -R(1,3));  % R+Y
    end
    rpy(2) = -asin(R(3,1));
else
    rpy(1) = atan2(R(3,2), R(3,3));  % R
    rpy(3) = atan2(R(2,1), R(1,1));  % Y

    [~,k] = max(abs( [R(1,1) R(2,1) R(3,2) R(3,3)] ));
    switch k
        case 1
            rpy(2) = -atan(R(3,1)*cos(rpy(3))/R(1,1));
        case 2
            rpy(2) = -atan(R(3,1)*sin(rpy(3))/R(2,1));
        case 3
            rpy(2) = -atan(R(3,1)*sin(rpy(1))/R(3,2));
        case 4
            rpy(2) = -atan(R(3,1)*cos(rpy(1))/R(3,3));
    end
end

end


