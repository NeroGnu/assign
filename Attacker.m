classdef Attacker
    properties
        centre;%中心坐标
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
                    obj.velocity(1)=cos(direction)*speed;
                    obj.velocity(2)=sin(direction)*speed;
                    obj.facility=facility;
                    obj.shape_x=shape_x; 
                    obj.shape_y=shape_y;
                case 5
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.velocity(1)=cos(direction)*speed;
                    obj.velocity(2)=sin(direction)*speed;
                    obj.facility=facility;
                    obj.shape_x=[-15 0 15 0]; 
                    obj.shape_y=[-10 30 -10 0];
                case 4
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.velocity(1)=cos(direction)*speed;
                    obj.velocity(2)=sin(direction)*speed;
                    obj.facility=pi*(10/180);
                    obj.shape_x=[-15 0 15 0]; 
                    obj.shape_y=[-10 30 -10 0];
                case 3
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=direction;
                    obj.velocity(1)=cos(direction)*10;
                    obj.velocity(2)=sin(direction)*10;
                    obj.facility=pi*(10/180);
                    obj.shape_x=[-15 0 15 0]; 
                    obj.shape_y=[-10 30 -10 0];
                case 2
                    obj.centre=centre; 
                    obj.color=color; 
                    obj.direction=pi/2;
                    obj.velocity(1)=cos(obj.direction)*10;
                    obj.velocity(2)=sin(obj.direction)*10;
                    obj.facility=pi*(10/180);
                    obj.shape_x=[-15 0 15 0]; 
                    obj.shape_y=[-10 30 -10 0];
                case 1
                    obj.centre=centre; 
                    obj.color=rand(1,3); 
                    obj.direction=pi/2;
                    obj.velocity(1)=cos(obj.direction)*10;
                    obj.velocity(2)=sin(obj.direction)*10;
                    obj.facility=pi*(10/180);
                    obj.shape_x=[-15 0 15 0]; 
                    obj.shape_y=[-10 30 -10 0];
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
           obj.centre(1)=obj.centre(1)+obj.velocity(1)*t;
           obj.centre(2)=obj.centre(2)+obj.velocity(2)*t;
           obj.ghandle=patch(obj.centre(1)+obj.shape_x, obj.centre(2)+obj.shape_y, obj.color);
        end
    end
end