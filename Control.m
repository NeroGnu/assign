classdef Control
    properties
        index_attacker;
        index_object;
        efficiency_martrix;
        area;
        vision_angle;
        vision_disdance;
    end
    methods
        function obj=Control(area, angle, disdance)
            switch nargin
                case 3
                    obj.area=area;
                    obj.vision_angle=angle;
                    obj.vision_disdance=disdance;
                case 2
                    obj.area=area;
                    obj.vision_angle=angle;
                    obj.vision_disdance=100;
                case 1
                    obj.area=area;
                    obj.vision_angle=30;
                    obj.vision_disdance=100;
                otherwise
                    disp('Parameter error!'); return;
            end
        end
        
        function obj=Scan(Attacker, Object)
            numAttacker=length(Attacker);
            numObject=length(Object);
            obj.index_attacker=[];
            obj.index_object=[];
            obj.efficiency_martrix=[];
            for i=1:numAttacker
                obj.index_attacker=i;
                for j=1:numObject
                    if 1==See(Attacker(i), Object(j))
                        obj.index_object=j;
                    end
                end
            end
            obj.efficiency_martrix=zeros(length(obj.index_attacker), length(obj.index_object));
            for i=1:length(obj.index_attacker)
                for j=1:length(obj.index_object)
                    obj.efficiency_martrix(i, j)=ComputeEfficiency(Attacker(obj.index_attacker(i)), Object(obj.index_object(j)));
                end
            end
        end
        
        function bool=See(obj, Attacker, Object)
            AO_vector=[Object.centre(1)-Attacker.centre(1), Object.centre(1)-Attacker.centre(1)];
            vector_angle=atand((Object.centre(2)-Attacker.centre(2))/(Object.centre(1)-Attacker.centre(1)));
            if abs(vector_angle-Attacker.direction)<=obj.vision_angle/2 && sqrt(AO_vector(1)^2 + AO_vector(2)^2)<=obj.vision_disdance
                bool=1;
            else
                bool=0;
            end
        end
        
        function efficiency=ComputeEfficiency(Attacker, Object)
            
        end
        
        function obj=set.index_attacker(obj, value)
            if isempty(value)
                obj.index_attacker=[];
                return;
            end
            n=length(obj.index_attacker);
            for i=1:n
                if obj.index_attacker(i)==value
                    return;
                end
            end
            obj.index_attacker=[obj.index_attacker, value];
        end
        
        function obj=set.index_object(obj, value)
            if isempty(value)
                obj.index_object=[];
                return;
            end
            n=length(obj.index_object);
            for i=1:n
                if obj.index_object(i)==value
                    return;
                end
            end
            obj.index_object=[obj.index_object, value];
        end
        
    end
end