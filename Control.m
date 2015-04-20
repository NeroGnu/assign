classdef Control
    properties
        index_attacker;
        index_object;
        efficiency_martrix;
        area;
        vision_angle;
        vision_disdance;
        assign_result;
        sum_result;
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
        
        function obj=Scaning(obj, Attacker, Object)
            numAttacker=length(Attacker);
            numObject=length(Object);
            obj.index_attacker=[];
            obj.index_object=[];
            obj.efficiency_martrix=[];
            for i=1:numAttacker
                obj.index_attacker=i;
                for j=1:numObject
                    if 1==obj.See(Attacker(i), Object(j))
                        obj.index_object=j;
                    end
                end
            end
            obj.efficiency_martrix=zeros(length(obj.index_attacker), length(obj.index_object));
            for i=1:length(obj.index_attacker)
                for j=1:length(obj.index_object)
                    obj.efficiency_martrix(i, j)=obj.ComputeEfficiency(Attacker(obj.index_attacker(i)), Object(obj.index_object(j)));
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
        
        function efficiency=ComputeEfficiency(obj, Attacker, MyObject)
            w1=0.6;
            w2=0.4;
            max_beta1=sqrt((obj.area(2)-obj.area(1))^2 + (obj.area(4)-obj.area(3))^2);
            target_angle=atand((MyObject.centre(2)-Attacker.centre(2))/(MyObject.centre(1)-Attacker.centre(1)));
            target_velocity(1)=Attacker.speed*cosd(target_angle);
            target_velocity(2)=Attacker.speed*sind(target_angle);
            alpha1=(Attacker.velocity(1)*target_velocity(1)+Attacker.velocity(2)*target_velocity(2))/sqrt(target_velocity(1)^2 + target_velocity(2)^2);
            beta1=max_beta1-sqrt((MyObject.centre(1)-Attacker.centre(1))^2 + (MyObject.centre(2)-Attacker.centre(2))^2);
            alpha1=alpha1/Attacker.speed;
            beta1=beta1/max_beta1;
            efficiency=MyObject.significance*(w1*alpha1+w2*beta1);
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
        
        function obj = BG_Assign(obj)

            ematrix=obj.efficiency_martrix;
            ematrix_b = ematrix;
            [numRows, numCols] = size(ematrix);
            obj.assign_result = zeros(numRows, numCols);
            anti_assign_result = ones(numRows, numCols);
            round = fix(numRows/numCols);

            for j = 1:round
                for i = (j*numCols):((j + 1)*numCols)
                    if 0 ~= max(max(ematrix))
                        [index_i, index_j] = find(ematrix == max(max(ematrix)));
                        obj.assign_result(index_i, index_j) = 1;
                        anti_assign_result(index_i, :) = 0;
                        ematrix(index_i, :) = 0;
                        ematrix(:, index_j) = 0;
                    end
                end
                ematrix = ematrix_b;
                ematrix = anti_assign_result .* ematrix;
            end

            round = mod(numRows, numCols);

            for i = 1:round
                if 0 ~= max(max(ematrix))
                    [index_i, index_j] = find(ematrix == max(max(ematrix)));
                    obj.assign_result(index_i, index_j) = 1;
                    anti_assign_result(index_i, :) = 0;
                    ematrix(index_i, :) = 0;
                    ematrix(:, index_j) = 0;
                end
            end

            ematrix_b = obj.assign_result .* ematrix_b;
            obj.sum_result = sum(sum(ematrix_b));
        end
    end
end