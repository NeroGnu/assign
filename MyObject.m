classdef MyObject
    properties
        centre;
        radius;
        color;
        significance;
        finish;
        ghandle;
    end
    methods
        function obj=MyObject(centre, radius, significance)
            C=jet(128);
            switch nargin
                case 3
                    obj.centre=centre;
                    obj.radius=radius;
                    obj.significance=significance;
                    obj.color=C(ceil(obj.significance*128),:);
                case 2
                    obj.centre=centre;
                    obj.radius=radius;
                    obj.significance=rand(1);
                    obj.color=C(ceil(obj.significance*128),:);
                case 1
                    obj.centre=centre;
                    obj.radius=10;
                    obj.significance=rand(1);
                    obj.color=C(ceil(obj.significance*128),:);
                otherwise
                    disp('Parameter error!'); return;
            end
            obj.finish=0;
            obj.ghandle=rectangle('Position',[obj.centre(1)-obj.radius, obj.centre(2)-obj.radius, obj.radius, obj.radius],'Curvature',[1,1],  'FaceColor',obj.color);
        end
        function obj=set.ghandle(obj, value)
            delete(obj.ghandle);
            obj.ghandle=value;
        end
    end   
end