function thetalist = iswithinrange(thetalist)

% �ؽڽ�1����
if thetalist(1) < -pi
    thetalist(1) = -pi;
elseif thetalist(1) > pi
    thetalist(1) = pi;
else
    thetalist(1) = thetalist(1);
end

% �ؽڽ�2����
if thetalist(2) < -pi
    thetalist(2) = -pi;
elseif thetalist(2) > pi
    thetalist(2) = pi;
else
    thetalist(2) = thetalist(2);
end

% �ؽڽ�3����
if thetalist(3) < -pi
    thetalist(3) = -pi;
elseif thetalist(3) > pi
    thetalist(3) = pi;
else
    thetalist(3) = thetalist(3);
end

% �ؽڽ�4����
if thetalist(4) < -pi
    thetalist(4) = -pi;
elseif thetalist(4) > pi
    thetalist(4) = pi;
else
    thetalist(4) = thetalist(4);
end

% �ؽڽ�5����
if thetalist(5) < -pi
    thetalist(5) = -pi;
elseif thetalist(5) > pi
    thetalist(5) = pi;
else
    thetalist(5) = thetalist(5);
end

% �ؽڽ�6����
if thetalist(6) < 0
    thetalist(6) = 0;
elseif thetalist(6) > 250*pi/180
    thetalist(6) = 250*pi/180;
else
    thetalist(6) = thetalist(6);
end

% �ؽڽ�7����
if thetalist(7) < -pi
    thetalist(7) = -pi;
elseif thetalist(7) > pi
    thetalist(7) = pi;
else
    thetalist(7) = thetalist(7);
end

end

