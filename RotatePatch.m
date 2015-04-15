function [rx, ry] = RotatePatch(x, y, angle)
rx=x*cosd(angle)-y*sind(angle);
ry=x*sind(angle)+y*cosd(angle);