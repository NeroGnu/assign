x = [-15 0 15 0];
y = [-10 30 -10 0];
V = [0 10];
centre = [0 0];
axis([-300 300 -300 300]);
h = patch(centre(1) + x, centre(2) + y, [1 0 0]);

for i = 1:300
    centre(1) = centre(1) + V(1)*0.1;
    centre(2) = centre(2) + V(2)*0.1;
    [x, y] = RotatePatch(x, y, 1);
    delete(h);
    h = patch(centre(1) + x, centre(2) + y, [1 0 0]);
    pause(0.1);
end


