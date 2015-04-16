% function main(numAttacker, numTarget)
clear;
numAttacker=9;
numTarget=6;
colorlist=zeros(numAttacker, 3);
coordinatelist=zeros(numAttacker, 2);
axis([0 600 0 600]);
colorlist(:,1)=randperm(numAttacker)/numAttacker;
colorlist(:,2)=randperm(numAttacker)/numAttacker;
colorlist(:,3)=randperm(numAttacker)/numAttacker;
coordinatelist(:, 1)=randperm(numAttacker)/numAttacker;
coordinatelist(:, 2)=randperm(numAttacker)/numAttacker;
for i=1:1:numAttacker
    car(i)=Attacker(round(coordinatelist(i, :)*200), colorlist(i, :));
    car(i).t_direction=30*i;
end

for j=1:300
    for i=1:1:numAttacker
        car(i)=car(i).Run(1);
    end
    pause(1);
end
% end