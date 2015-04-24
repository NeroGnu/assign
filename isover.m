function bool=isover(Control, Attacker, MyObject)
    SUM=0;
    for i=1:length(MyObject)
        SUM=SUM+MyObject(i).finish;
    end
    if SUM==length(MyObject)
        bool=1;
        return;
    end
    SUM=0;
    if isempty(Control.efficiency_martrix) && ~isempty(Control.index_attacker)
        for i=1:length(Control.index_attacker)
            SUM=SUM+isOutofArea(Control.area, Attacker(Control.index_attacker(i)));
        end
        if SUM==length(Control.index_attacker)
            bool=1;
            return;
        end
    end
    bool=0;
end


function bool=isOutofArea(area, Attacker)
    if Attacker.centre(1)<area(1) || Attacker.centre(1)>area(2) || Attacker.centre(2)<area(3) || Attacker.centre(2)>area(4)
        bool=1;
    else
        bool=0;
    end
end