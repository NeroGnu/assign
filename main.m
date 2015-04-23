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

interval=fix(area(2)/(numAttacker+1));
for i=1:numAttacker
    %depart from X axis
%     car(i)=Attacker([i*interval 0], Acolorlist(i, :), 90);
    %depart from origin
    car(i)=Attacker([0 0], Acolorlist(i, :), 5+10*(i-1));
%     car(i).t_direction=5+10*(i-1);
end
for i=1:numTarget
    target(i)=MyObject(round(Tcoordinatelist(i, :)*500), 10);
end
colorbar

C=Control(area, car, target);

for j=1:1200
    %扫描
    C=C.Scaning(car, target);
    parfor ii=1:length(car)
        car(ii).finish=C.A_finish(ii);
    end
    parfor ii=1:length(target)
        target(ii).finish=C.O_finish(ii);
    end
    %分配
    C=C.BG_Assign(car, target, j*0.1);
    %排除已完成小�?
    parfor i=1:numAttacker
        %排除已完成小�?
        if 1~=car(i).finish
            if ~isempty(C.assign_result)
                ia=find(C.assign_result(find(C.index_attacker==i),:)==1);
                ib=C.index_object(ia);
                if ~isempty(ib)
%                     if sqrt((target(ib).centre(2)-car(i).centre(2))^2 + (target(ib).centre(1)-car(i).centre(1))^2)<200
                       car(i).t_direction=My_atand((target(ib).centre(2)-car(i).centre(2)), (target(ib).centre(1)-car(i).centre(1)));
%                     end
                else
                    car(i).t_direction=car(i).direction;
                end 
            else
                car(i).t_direction=car(i).direction;
            end
            car(i)=car(i).Run(0.1);
        end
    end
    pause(0.01);
end

% end