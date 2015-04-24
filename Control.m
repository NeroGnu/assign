classdef Control
    properties
        index_attacker;
        index_object;
        efficiency_martrix;
        area;
        vision_angle;
        vision_disdance;
        patrol_interval;
        assign_result;
        sum_result;
        patrol_point;
        patrol_path;
        A_finish;
        O_finish;
    end
    methods
        function obj=Control(area, Attacker, Object, angle, disdance)
            switch nargin
                case 5
                    obj.area=area;
                    obj.vision_angle=angle;
                    obj.vision_disdance=disdance;
                case 4
                    obj.area=area;
                    obj.vision_angle=angle;
                    obj.vision_disdance=200;
                case 3
                    obj.area=area;
                    obj.vision_angle=60;
                    obj.vision_disdance=200;
                otherwise
                    disp('Parameter error!'); return;
            end
           obj.patrol_interval(1)=cosd(90-obj.vision_angle/2)*obj.vision_disdance;
           obj.patrol_interval(2)=obj.vision_disdance;
           obj.A_finish=zeros(1, length(Attacker));
           obj.O_finish=zeros(1, length(Object));
%            patrol_point(1)=[0 obj.area(3)+obj.vision_disdance];
%            patrol_point(2)=[0 obj.area(4)-obj.vision_disdance];
%            n=fix(obj.area(2)/obj.patrol_interval(1));
%            for i=1:n
%                if 1==mod(i, 2)
%                    patrol_point(2*i+1)=[i*obj.patrol_interval(1), obj.area(4)-obj.vision_disdance];
%                    patrol_point(2*i+2)=[i*obj.patrol_interval(1), obj.area(3)+obj.vision_disdance];
%                else
%                    patrol_point(2*i+1)=[i*obj.patrol_interval(1), obj.area(3)+obj.vision_disdance];
%                    patrol_point(2*i+2)=[i*obj.patrol_interval(1), obj.area(4)-obj.vision_disdance];
%                end
%            end
        end
        
        function obj=Scaning(obj, Attacker, Object)
            numAttacker=length(Attacker);
            numObject=length(Object);
            obj.index_attacker=[];
            obj.index_object=[];
            obj.efficiency_martrix=[];
            for i=1:numAttacker
                if 1~=Attacker(i).finish
                    obj.index_attacker=i;
                    for j=1:numObject
                        if 1~=obj. O_finish(j)
                            if 1==obj.See(Attacker(i), Object(j))
                                obj.index_object=j;
                                if sqrt((Object(j).centre(2)-Attacker(i).centre(2))^2 + (Object(j).centre(1)-Attacker(i).centre(1))^2)<Object(j).radius
                                   obj. A_finish(i)=1;
                                   obj. O_finish(j)=1;
                                end
                            end
                        end
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
            AO_vector(1)=Object.centre(1)-Attacker.centre(1);
            AO_vector(2)=Object.centre(2)-Attacker.centre(2);
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
            target_angle=My_atand((MyObject.centre(2)-Attacker.centre(2)), (MyObject.centre(1)-Attacker.centre(1)));
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
        
        function obj = BG_Assign(obj, Attacker, Object, time)
            if isempty(obj.efficiency_martrix)
                obj.assign_result=[];
                obj.sum_result=[];
                return;
            end
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
            
            %Threshold check.
            for i=1:length(obj.assign_result(1,:))
                Ut_index=find(obj.assign_result(:,i)==1);
                Ut=obj.efficiency_martrix(Ut_index, i);
                comparison=(max(Ut)-Ut)./Ut;
                for j=1:length(comparison)
                    if comparison(j)>MySigmoid(150, 16, time)
                        obj.assign_result(Ut_index(j))=0;
                    end
                end
            end
            
            for i=1:length(obj.index_attacker)
                if sum(obj.assign_result(i,:))>0
                    if 0==obj.See(Attacker(obj.index_attacker(i)), Object(obj.index_object(obj.assign_result(i,:)==1)))
                        if sqrt((Object(obj.index_object(obj.assign_result(i,:)==1)).centre(2)-Attacker(obj.index_attacker(i)).centre(2))^2 + (Object(obj.index_object(obj.assign_result(i,:)==1)).centre(1)-Attacker(obj.index_attacker(i)).centre(1))^2)>Attacker(obj.index_attacker(i)).speed*time
                            obj.assign_result(i,obj.assign_result(i,:)==1)=0;
                        end
                    end
                end
            end

            ematrix_b = obj.assign_result .* ematrix_b;
            obj.sum_result = sum(sum(ematrix_b));
        end
        
        function obj=Normal_Assign(obj)
            if isempty(obj.efficiency_martrix)
                obj.assign_result=[];
                obj.sum_result=[];
                return;
            end
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
        end
%         function threshold=MySigmoid(median, divider, x)
%             threshold=1/(exp((median-x)/divider) + 1);
%         end
        
%         function angle=Patrol(obj, Attacker)
%             temp=1;
%             for i=1:length(obj.patrol_point(:,1))
%                 if sqrt((patrol_point(i,2)-Attacker.centre(2))^2 + (patrol_point(i,1)-Attacker.centre(1))^2)>20
%                    
%                 end
%             end
%             n=fix(Attacker.centre(1)+1/obj.patrol_interval(1));
%             if Attacker.direction>0
%                 y=obj.area(4)-obj.patrol_interval(2);
%             else
%                 y=obj.area(3)+obj.patrol_interval(2);
%             end
%             if abs(Attacker.direction)<90
%                 x=(n+1)*obj.patrol_interval(1);
%             else
%                 x=n*obj.patrol_interval(1);
%             end
%             
%                 
%             angle=atand((y-Attacker.centre(2))/(x-Attacker.centre(1)));
%         end
    end
end