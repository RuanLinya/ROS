function R = RPY_Interp(R1,R2,e)
% �趨��ֵ��Χ
t=0:e:1;
N = length(t);
Rtmp = cell(1,N);
% ��ֵ
for i=1:length(t)
    Rtmp{i} = R2*t(i)+R1*(1-t(i)); %��ֵ���ǰ���ֵ����ʽ������
end

R = Rtmp;