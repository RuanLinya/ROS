function A = Interpolation(A1,A2,e)
% 设定插值范围
t=0:e:1;
% 插值
for i=1:length(t)
    Ax(i) = A2(1)*t(i)+A1(1)*(1-t(i)); %差值就是按比值的形式来计算
    Ay(i) = A2(2)*t(i)+A1(2)*(1-t(i));
    Az(i) = A2(3)*t(i)+A1(3)*(1-t(i));
end

A = [Ax',Ay',Az'];

