function [t] = Load_multi_trajectory_visualization(time, t_leader, positions, attitudes, position_L, uav_num, Stoptime)
    %% plot style
    titlefont = 16;
    tickfont = 14;
    legendfont = 14;

    figure();
    x8_vis = uav_visualization('X8');
    % x8_leader = uav_visualization('X8-leader');
    
    uav_scale = 5;
    colors = colormap(jet(length(t_leader))); 
    
    % UAV location setup 
    time_interval = 0.1; % 0.1s
    % Stoptime = t(end); % simulation stoptime
    target_time_points = 0:time_interval:Stoptime;

    UAV_locations_points_l = [1];
    UAV_locations_l = [1];
    ratio = 50; % 5s plot out UAV every 5 sec
    %% 

    % UAV_locations_points = [UAV_locations_points length(t)]; % add last time point
    % UAV_locations = [UAV_locations length(t)]
    target_index = 1;
    for i = 1:length(t_leader)
        if t_leader(i) > target_time_points(target_index)
            UAV_locations_points_l = [UAV_locations_points_l i];
            if mod(target_index,ratio) ==0 
                UAV_locations_l = [UAV_locations_l i]; %% time_interval * ratio
            end
            target_index = target_index+1;
        end
    end
    x_L = position_L(:,1);
    y_L = position_L(:,2);
    z_L = position_L(:,3);

    % NED to ENU to plot
    T = transformation(eye(3), [0;0;0]);
    position_L_enu = [x_L, y_L, z_L]*transpose(T.R_NED_ENU);
    x_L_enu = position_L_enu(:,1);
    y_L_enu = position_L_enu(:,2);
    z_L_enu = position_L_enu(:,3);
    %% plot leader
    hold on;
    for i = UAV_locations_l
        plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',15,"color","g");
    end
    for i = UAV_locations_points_l
        plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',5,"color",colors(i,:));
    end
    %% plot followers
    for k = 1:uav_num
        t = time{1,k};
        UAV_locations_points = [1];
        UAV_locations = [1];
        target_index = 1;
        for i = 1:length(t)
            if t(i) > target_time_points(target_index)
                UAV_locations_points = [UAV_locations_points i];
                if mod(target_index,ratio) ==0 
                    UAV_locations = [UAV_locations i]; %% time_interval * ratio
                end
                target_index = target_index+1;
            end
        end
        
        
        
        attitude = attitudes{1,k};
        psi= attitude(:,1);
        theta = attitude(:,2);
        phi = attitude(:,3); 

        position = positions{1,k};
        x = position(:,1);
        y = position(:,2);
        z = position(:,3);
        
        position_enu = [x, y, z]*transpose(T.R_NED_ENU);
        x_enu = position_enu(:,1);
        y_enu = position_enu(:,2);
        z_enu = position_enu(:,3);  

        %%
        for i = UAV_locations
            % x8_leader.draw(phi(i), theta(i), course_L(i), x_L(i), y_L(i), z_L(i), uav_scale);
            % plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',15,"color","g");
            x8_vis.draw(phi(i), theta(i), psi(i), x(i), y(i), z(i), uav_scale);
            
            % q = quiver3(x_enu(i), y_enu(i), z_enu(i), w_e(i), w_n(i), w_u(i), 0,'b','linewidth',1);
            % q.MaxHeadSize = 1;
            % 
            % Vav = T.R_NED_ENU*T.rotation(phi(i), theta(i), psi(i))*[Va(i);0;0];
            % qv = quiver3(x_enu(i), y_enu(i), z_enu(i), Vav(1), Vav(2), Vav(3),'r','linewidth',1);
            % qv.MaxHeadSize = 1;
        end
        plot3(x_enu, y_enu, z_enu,'-.','Linewidth',1,"color",'b');

        % for i = UAV_locations_points
        %     plot3(x_enu(i), y_enu(i), z_enu(i),'.','MarkerSize',5,"color",colors(i,:));
        % end
        c=colorbar('FontSize',tickfont,'Ticks',linspace(0,1,11),'TickLabels',linspace(0,floor(t(end)),11), 'Location', 'southoutside');
        c.Label.String = 'Time[s]';
        c.Label.FontSize = titlefont;
    
        xlabel('x[m]','interpreter','latex','fontsize',tickfont);
        ylabel('y[m]','interpreter','latex','fontsize',tickfont);
        zlabel('z[m]','interpreter','latex','fontsize',tickfont);
        % title('Trajectory','fontsize',titlefont);
        % legend("Trajectory","","","$V_w$","$V_a$","reference",'interpreter','latex','fontsize',legendfont,'location','best')
        % legend("Virtual leader path","Virtual leader","","","Wind speed","Airspeed",'interpreter','latex','fontsize',legendfont,'location','best')
        axis equal;
        % zlim([80, 110]);
        % view([0,-1,0]);
        % view(2);
        grid on; 
    end
end

