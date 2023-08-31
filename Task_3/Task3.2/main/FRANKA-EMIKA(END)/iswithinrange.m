function thetalist = iswithinrange(thetalist)

% 关节角1限制
if thetalist(1) < -pi
    thetalist(1) = -pi;
elseif thetalist(1) > pi
    thetalist(1) = pi;
else
    thetalist(1) = thetalist(1);
end

% 关节角2限制
if thetalist(2) < -pi
    thetalist(2) = -pi;
elseif thetalist(2) > pi
    thetalist(2) = pi;
else
    thetalist(2) = thetalist(2);
end

% 关节角3限制
if thetalist(3) < -pi
    thetalist(3) = -pi;
elseif thetalist(3) > pi
    thetalist(3) = pi;
else
    thetalist(3) = thetalist(3);
end

% 关节角4限制
if thetalist(4) < -pi
    thetalist(4) = -pi;
elseif thetalist(4) > pi
    thetalist(4) = pi;
else
    thetalist(4) = thetalist(4);
end

% 关节角5限制
if thetalist(5) < -pi
    thetalist(5) = -pi;
elseif thetalist(5) > pi
    thetalist(5) = pi;
else
    thetalist(5) = thetalist(5);
end

% 关节角6限制
if thetalist(6) < 0
    thetalist(6) = 0;
elseif thetalist(6) > 250*pi/180
    thetalist(6) = 250*pi/180;
else
    thetalist(6) = thetalist(6);
end

% 关节角7限制
if thetalist(7) < -pi
    thetalist(7) = -pi;
elseif thetalist(7) > pi
    thetalist(7) = pi;
else
    thetalist(7) = thetalist(7);
end

end

