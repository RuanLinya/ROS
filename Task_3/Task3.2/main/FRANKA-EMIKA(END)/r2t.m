%R2T Convert rotation matrix to a homogeneous transform 将旋转矩阵转换为同质变换
%
% T = R2T(R) is an SE(2) or SE(3) homogeneous transform equivalent to an
% SO(2) or SO(3) orthonormal rotation matrix R with a zero translational
% component. Works for T in either SE(2) or SE(3):
% SE(3) 是旋转加上位移
% T = R2T(R) 是一个SE(2)或SE(3)同质变换，相当于一个SO(2)或SO(3)正交旋转矩阵R，其平移性为零。 
%  - if R is 2x2 then T is 3x3, or
%  - if R is 3x3 then T is 4x4.
%
% Notes::
% - Translational component is zero.
% - For a rotation matrix sequence (KxKxN) returns a homogeneous transform
%   sequence (K+1xK+1xN).
%
% See also T2R.

% Copyright (C) 1993-2019 Peter I. Corke
%
% This file is part of The Spatial Math Toolbox for MATLAB (SMTB).
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
% of the Software, and to permit persons to whom the Software is furnished to do
% so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
% FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%
% https://github.com/petercorke/spatial-math

function T = r2t(R)
    
    % check dimensions: R is SO(2) or SO(3)
    d = size(R); % size：获取数组的行数和列数
    assert(d(1) == d(2), 'SMTB:r2t:badarg', 'matrix must be square');
    % 在matlab中assert函数用来判断一个expression是否成立，如不成立则报错
    assert(any(d(1) == [2 3]), 'SMTB:r2t:badarg', 'argument is not a 2x2 or 3x3 rotation matrix (sequence)');
        
    n = size(R,2);% size(A,2) 该语句返回的是矩阵A的列数。
    Z = zeros(n,1);% B=zeros(m,n)：生成m×n全零阵。
    B = [zeros(1,n) 1]; % 在一行零矩阵后跟个1
    
    if numel(d) == 2 % 返回数组中元素个数。若是一幅图像，则numel(d)将给出它的像素数。
        % single matrix case
        T = [R Z; B];
    else
        %  matrix sequence case 矩阵序列案例
        T = zeros(n+1,n+1,d(3));
        for i=1:d(3)
            T(:,:,i) = [R(:,:,i) Z; B];
        end
    end
end
