function A = Interpolation(A1,A2,e)
% �趨��ֵ��Χ
t=0:e:1;
% ��ֵ
for i=1:length(t)
    Ax(i) = A2(1)*t(i)+A1(1)*(1-t(i)); %��ֵ���ǰ���ֵ����ʽ������
    Ay(i) = A2(2)*t(i)+A1(2)*(1-t(i));
    Az(i) = A2(3)*t(i)+A1(3)*(1-t(i));
end

A = [Ax',Ay',Az'];

