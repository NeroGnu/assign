% function main(numAttacker, numTarget)
clear;
numAttacker=9;
numTarget=6;
colorlist=zeros(numAttacker, 3);
coordinatelist=zeros(numAttacker, 2);
axis([-300 300 -300 300]);
colorlist(:,1)=randperm(numAttacker)/numAttacker;
colorlist(:,2)=randperm(numAttacker)/numAttacker;
colorlist(:,3)=randperm(numAttacker)/numAttacker;
coordinatelist(:, 1)=randperm(numAttacker)/numAttacker;
coordinatelist(:, 2)=randperm(numAttacker)/numAttacker;
for i=1:1:numAttacker
    car(i)=Attacker(round(coordinatelist(i, :)*200), colorlist(i, :));
end

% end