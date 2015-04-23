function angle=My_atand(y, x)
angle=atand(y/x);

if angle>0 && y<0 && x<0
    angle=angle-180;
    return;
end

if angle<0 && y>0 && x<0
    angle=angle+180;
    return;
end
    