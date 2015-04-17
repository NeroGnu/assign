classdef MyObject
    properties
        centre;
        radius;
        color;
        significance;
        ghandle;
    end
    methods
        function obj=MyObject(centre, radius, color, significance)
            switch nargin
                case 4
                    obj.centre=centre;
                    obj.radius=radius;
                    obj.color=color;
                    obj.significance=significance;
                case 3
                    obj.centre=centre;
                    obj.radius=radius;
                    obj.color=color;
                    obj.significance=rand(1);
                case 2
                    obj.centre=centre;
                    obj.radius=radius;
                    obj.color=rand(1,3);
                    obj.significance=rand(1);
                case 1
                    obj.centre=centre;
                    obj.radius=10;
                    obj.color=rand(1,3);
                    obj.significance=rand(1);
                otherwise
                    disp('Parameter error!'); return;
            end
            obj.ghandle=rectangle('Position',[obj.centre(1)-obj.radius, obj.centre(2)-obj.radius, obj.radius, obj.radius],'Curvature',[1,1],  'FaceColor',obj.color);
        end
        function obj=set.ghandle(obj, value)
            delete(obj.ghandle);
            obj.ghandle=value;
        end
    end   
end