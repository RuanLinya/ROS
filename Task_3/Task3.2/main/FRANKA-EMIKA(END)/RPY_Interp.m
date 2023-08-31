function R = RPY_Interp(R1,R2,e)
% 设定插值范围
t=0:e:1;
N = length(t);
Rtmp = cell(1,N);
% 插值
for i=1:length(t)
    Rtmp{i} = R2*t(i)+R1*(1-t(i)); %差值就是按比值的形式来计算
end

R = Rtmp;