% function main(numAttacker, numTarget)
clear;
%Set parameter
numAttacker=9;
numTarget=6;
area=[0 600 0 600];

Acolorlist=zeros(numAttacker, 3);
Acoordinatelist=zeros(numAttacker, 2);
Tcolorlist=zeros(numTarget, 3);
Tcoordinatelist=zeros(numTarget, 2);

figure;
set (gcf,'Position',[0,0,800,600], 'color','w');
axis(area);
colorbar

%Random initialization
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

%Initialize object
for i=1:numAttacker
    %depart from X axis
%     car(i)=Attacker([i*interval 0], Acolorlist(i, :), 90);
    %depart from origin
    car(i)=Attacker([0 0], Acolorlist(i, :), 5+10*(i-1));
end
for i=1:numTarget
    target(i)=MyObject(round(Tcoordinatelist(i, :)*500), 10);
end
C=Control(area, car, target, 120);

j=1;
while ~isover(C, car, target)
    %Scan
    C=C.Scaning(car, target);
    for ii=1:length(car)
        car(ii).finish=C.A_finish(ii);
    end
    for ii=1:length(target)
        target(ii).finish=C.O_finish(ii);
    end
    %Assign
    C=C.BG_Assign(car, target, j*0.1);
    
    for i=1:numAttacker
        %Exclude the finished car
        if 1~=car(i).finish
            if ~isempty(C.assign_result)
                itemp=C.index_object(C.assign_result(C.index_attacker==i,:)==1);
                if ~isempty(itemp)
                    car(i).t_direction=My_atand((target(itemp).centre(2)-car(i).centre(2)), (target(itemp).centre(1)-car(i).centre(1)));
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
    j=j+1;
end

%%%%%%%%%%%%%%%%%%%%%%%
%contrast
%%%%%%%%%%%%%%%%%%%%%%%

figure;
set (gcf,'Position',[0,0,800,600], 'color','w');
axis(area);
colorbar

%Initialize object
for i=1:numAttacker
    %depart from X axis
%     car(i)=Attacker([i*interval 0], Acolorlist(i, :), 90);
    %depart from origin
    car(i)=Attacker([0 0], Acolorlist(i, :), 5+10*(i-1));
end
for i=1:numTarget
    target(i)=MyObject(round(Tcoordinatelist(i, :)*500), 10);
end
C=Control(area, car, target, 120);

j=1;
while ~isover(C, car, target)
    %Scan
    C=C.Scaning(car, target);
    for ii=1:length(car)
        car(ii).finish=C.A_finish(ii);
    end
    for ii=1:length(target)
        target(ii).finish=C.O_finish(ii);
    end
    %Assign
    C=C.Normal_Assign;
    
    for i=1:numAttacker
        %Exclude the finished car
        if 1~=car(i).finish
            if ~isempty(C.assign_result)
                itemp=C.index_object(C.assign_result(C.index_attacker==i,:)==1);
                if ~isempty(itemp)
                    car(i).t_direction=My_atand((target(itemp).centre(2)-car(i).centre(2)), (target(itemp).centre(1)-car(i).centre(1)));
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
    j=j+1;
end
% end