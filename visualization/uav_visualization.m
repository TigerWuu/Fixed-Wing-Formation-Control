classdef uav_visualization < handle

    properties
        airframe
        vertices
        faces
        colors
        
        states 
        body
        R_NED_ENU
    end

    methods
        % Constructor
        function self = uav_visualization(type)
            self.airframe = type;
            self.body.s3 = [];
            self.body.s4 = [];
            [self.vertices, self.faces, self.colors] = self.create_airframe();     
            self.states = transformation(eye(3), [0;0;0]);
            self.R_NED_ENU = [0,1,0;
                              1,0,0;
                              0,0,-1];
        end
        
        function self = update(self, phi, theta, psi, x, y, z, t)
            figure(1);
            clf;
            title(self.airframe, "Time : "+ t)
            xlabel('East')
            ylabel('North')
            zlabel('-Down')
            view(45,45);
            grid on;

            self.draw(phi, theta, psi, x, y, z);
            p = self.R_NED_ENU*[x;y;z]; 
            axis([-3+p(1),3+p(1),-3+p(2),3+p(2),-3+p(3),3+p(3)]);
            drawnow;
            % figure(2)
            % clf;
            % xlabel('East')
            % ylabel('North')
            % zlabel('-Down')
            % view(45,45);
            % grid on;
           
            % self.draw(transpose(Vertices));
            % axis([0,400, 0,400, 90, 120]);
            % drawnow;
        end
        
        function self = draw(self, phi, theta, psi, x, y, z, scale)
            % NED
            self.states.rotation(phi, theta, psi);
            self.states.position(x, y, z);
            Vertices = self.states.R * transpose(self.vertices*scale) + self.states.P;
            % NED -> ENU
            Vertices = self.R_NED_ENU*Vertices;
            % draw airframe
            self.body.s3 = patch('Vertices', transpose(Vertices), 'Faces', self.faces.s3, 'FaceVertexCData', self.colors.s3, 'FaceColor', 'flat');
            self.body.s4 = patch('Vertices', transpose(Vertices), 'Faces', self.faces.s4, 'FaceVertexCData', self.colors.s4, 'FaceColor', 'flat');
        end

        function film = record(self, film)
            frame = getframe(gcf);
            writeVideo(film, frame);
        end

        function [V, F, C] = create_airframe(self)
            red = [1,0,0];
            green = [0,1,0];
            blue = [0,0,1];
            black = [0,0,0];
            switch self.airframe
                case 'X8'
                    V = [0    ,0   ,0;
                         -0.5 ,1   ,0;
                         -0.7 ,1   ,0;
                         -0.6 ,0.2 ,0;
                         -0.65,0.1 ,0;
                         -0.65,-0.1,0;
                         -0.6 ,-0.2,0;
                         -0.7 ,-1  ,0;
                         -0.5 ,-1  ,0;
                         -0.5 ,0   ,-0.15;
                         -0.55,1   ,-0.1;
                         -0.7 ,1   ,-0.1;
                         -0.55,-1  ,-0.1;
                         -0.7 ,-1  ,-0.1;];
                    F.s3 = [1,4,10;
                            1,7,10;
                            4,5,10;
                            5,6,10;
                            6,7,10;];
                    F.s4 = [1,2,3,4;
                            1,7,8,9;
                            2,3,12,11;
                            8,9,13,14;
                            ];
                    C.s3 = [blue;
                            blue;
                            black;
                            black;
                            black];
                    C.s4 = [red;
                            red;
                            blue;
                            blue];
                otherwise
                    warning('Undefined airframe. No airframe created.')
            end
        end
    end
end



