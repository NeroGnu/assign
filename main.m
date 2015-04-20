% function main(numAttacker, numTarget)
clear;
numAttacker=9;
numTarget=6;
area=[0 600 0 600];

Acolorlist=zeros(numAttacker, 3);
Acoordinatelist=zeros(numAttacker, 2);
Tcolorlist=zeros(numTarget, 3);
Tcoordinatelist=zeros(numTarget, 2);

axis(area);

Acolorlist(:,1)=randperm(numAttacker)/numAttacker;
Acolorlist(:,2)=randperm(numAttacker)/numAttacker;
Acolorlist(:,3)=randperm(numAttacker)/numAttacker;
Acoordinatelist(:, 1)=randperm(numAttacker)/numAttacker;
Acoordinatelist(:, 2)=randperm(numAttacker)/numAttacker;

Tcolorlist(:,1)=randperm(numTarget)/numTarget;
Tcolorlist(:,2)=randperm(numTarget)/numTarget;
Tcolorlist(:,3)=randperm(numTarget)/numTarget;
Tcoordinatelist(:, 1)=randperm(numTarget)/numTarget;
Tcoordinatelist(:, 2)=randperm(numTarget)/numTarget;

for i=1:numAttacker
    car(i)=Attacker(round(Acoordinatelist(i, :)*200), Acolorlist(i, :), 90, 10, 10, [-5 0 5 0], [-3.3 10 -3.3 0]);
%     car(i).t_direction=280;
end
for i=1:numTarget
    target(i)=MyObject(round(Tcoordinatelist(i, :)*500), 10, Tcolorlist(i, :));
end

C=Control(area);

for j=1:300
    for i=1:numAttacker
        C=C.Scaning(car, target);
        C=C.BG_Assign;
        ia=find(C.assign_result(C.index_attacker(i),:)==1);
        ib=C.index_object(ia);
        if ~isempty(ib)
            car(i).t_direction=atand((target(ib).centre(2)-car(i).centre(2))/(target(ib).centre(1)-car(i).centre(1)));
        end 
        car(i)=car(i).Run(0.1);
    end
    pause(0.1);
end

% end