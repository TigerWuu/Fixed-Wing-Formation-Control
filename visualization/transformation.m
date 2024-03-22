classdef transformation < handle
    properties
        R
        P
        R_NED_ENU
    end
    methods
        function self = transformation(R, P)
            self.R = R;
            self.P = P;
            self.R_NED_ENU = [0,1,0;
                              1,0,0;
                              0,0,-1];

        end
        
        function R = rotation(self, r,p,y)
            R_r = [1, 0     , 0     ;   
                   0, cos(r), -sin(r);
                   0, sin(r),  cos(r)];
            R_p = [cos(p), 0, sin(p);
                     0     , 1, 0     ;
                    -sin(p), 0, cos(p)];
            R_y = [cos(y), -sin(y), 0;
                   sin(y),  cos(y), 0;
                   0     ,  0     , 1];
            % body to inertial
            R = R_y*R_p*R_r;
            self.R = R;
        end

        function P = position(self, x,y,z)
            P = [x;y;z];
            self.P = P;
        end
        
        function self = update(self, R, P)
            self.R = R;
            self.P = P;
        end

    end
end