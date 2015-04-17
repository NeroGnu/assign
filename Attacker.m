classdef Attacker
    properties
        centre;%中心坐标
        speed;
        velocity;%矢量速度
        t_velocity;%目标矢量速度
        direction;%朝向
        t_direction;
        facility;%敏捷（每秒转向角度）
        color;%颜色
        shape_x;%形状X坐标
        shape_y;%形状Y坐标
        ghandle;%图形句柄
    end
    methods
        function obj=Attacker(centre, color, direction, speed, facility, shape_x, shape_y)
            switch nargin
                case 7
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.speed=speed;
                    obj.velocity(1)=cosd(direction)*speed;
                    obj.velocity(2)=sind(direction)*speed;
                    obj.facility=facility;
                    obj.shape_x=shape_x; 
                    obj.shape_y=shape_y;
                case 5
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.speed=speed;
                    obj.velocity(1)=cosd(direction)*speed;
                    obj.velocity(2)=sind(direction)*speed;
                    obj.facility=facility;
                    obj.shape_x=[-1.5 0 1.5 0]; 
                    obj.shape_y=[-1.0 3.0 -1.0 0];
                case 4
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.speed=speed;
                    obj.velocity(1)=cosd(direction)*speed;
                    obj.velocity(2)=sind(direction)*speed;
                    obj.facility=10;
                    obj.shape_x=[-1.5 0 1.5 0]; 
                    obj.shape_y=[-1.0 3.0 -1.0 0];
                case 3
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.speed=10;
                    obj.velocity(1)=cosd(direction)*obj.speed;
                    obj.velocity(2)=sind(direction)*obj.speed;
                    obj.facility=10;
                    obj.shape_x=[-1.5 0 1.5 0]; 
                    obj.shape_y=[-1.0 3.0 -1.0 0];
                case 2
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=90;
                    obj.speed=10;
                    obj.velocity(1)=cosd(obj.direction)*obj.speed;
                    obj.velocity(2)=sind(obj.direction)*obj.speed;
                    obj.facility=10;
                    obj.shape_x=[-1.5 0 1.5 0]; 
                    obj.shape_y=[-1.0 3.0 -1.0 0];
                case 1
                    obj.centre=centre; 
                    obj.color=rand(1,3); 
                    obj.direction=90;
                    obj.speed=10;
                    obj.velocity(1)=cosd(obj.direction)*obj.speed;
                    obj.velocity(2)=sind(obj.direction)*obj.speed;
                    obj.facility=10;
                    obj.shape_x=[-1.5 0 1.5 0]; 
                    obj.shape_y=[-1.0 3.0 -1.0 0];
                otherwise
                    disp('Parameter error!'); return;
            end
            obj.t_velocity=obj.velocity;
            obj.t_direction=obj.direction;
            obj.ghandle=patch(obj.centre(1)+obj.shape_x, obj.centre(2)+obj.shape_y, obj.color);
        end
        function obj=set.ghandle(obj, value)
            delete(obj.ghandle);
            obj.ghandle=value;
        end
        function obj=Run(obj, t)
            %转向
           if obj.t_direction-obj.direction>0
               if obj.t_direction-obj.direction>obj.facility*t
                   [obj.shape_x, obj.shape_y]=RotatePatch(obj.shape_x, obj.shape_y, obj.facility*t);
                   obj.direction=obj.direction+obj.facility*t;  
               else
                   [obj.shape_x, obj.shape_y]=RotatePatch(obj.shape_x, obj.shape_y, obj.t_direction-obj.direction);
                   obj.direction=obj.t_direction;
               end
           else
               if obj.direction-obj.t_direction>obj.facility*t
                   [obj.shape_x, obj.shape_y]=RotatePatch(obj.shape_x, obj.shape_y, 0-obj.facility*t);
                   obj.direction=obj.direction-obj.facility*t;
               else
                   [obj.shape_x, obj.shape_y]=RotatePatch(obj.shape_x, obj.shape_y, obj.direction-obj.t_direction);
                   obj.direction=obj.t_direction;
               end
           end
           %更新速度
           obj.velocity(1)=cosd(obj.direction)*obj.speed;
           obj.velocity(2)=sind(obj.direction)*obj.speed;
           %更新位置
           obj.centre(1)=obj.centre(1)+obj.velocity(1)*t;
           obj.centre(2)=obj.centre(2)+obj.velocity(2)*t;
           %绘图
           obj.ghandle=patch(obj.centre(1)+obj.shape_x, obj.centre(2)+obj.shape_y, obj.color);
        end
        function [rx, ry] = RotatePatch(x, y, angle)
            rx=x*cosd(angle)-y*sind(angle);
            ry=x*sind(angle)+y*cosd(angle);
        end
        function obj=set.t_direction(obj, value)
            while value>360
                value=value-360;
            end
            while value<0
                value=value+360;
            end
            if value>=-180 && value<=180
                obj.t_direction=value;
            elseif value<-180
                obj.t_direction=360-value;
            else
                obj.t_direction=value-360;
            end
        end
        function obj=set.direction(obj, value)
            while value>360
                value=value-360;
            end
            while value<0
                value=value+360;
            end
            if value>=-180 && value<=180
                obj.direction=value;
            elseif value<-180
                obj.direction=360-value;
            else
                obj.direction=value-360;
            end
        end
    end
end