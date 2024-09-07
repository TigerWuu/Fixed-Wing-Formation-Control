% uav_visualization 
close all;
%% get data
t = out.tout;

T = transformation(eye(3), [0;0;0]);

position = get(out.logsout, 'position').Values.Data;
position_enu = get(out.logsout, 'position_ENU').Values.Data;
attitude = get(out.logsout, 'attitude').Values.Data;
G_error = get(out.logsout, 'G_error').Values.Data;
uav_num = length(position(1,:))/3; % number of UAV followers


% x_enu = {};
% y_enu = {};
% z_enu = {};
% x = {};
% y = {};
% z = {};
% 
% lateral_err = {};
% forward_err = {};
% vertical_err = {};
% 
% phi = {};
% theta = {};
% psi = {};
% course = {};
for j = 1:uav_num
    x_enu(j) = {position_enu(:,1+3*(j-1))'};
    y_enu(j) = {position_enu(:,2+3*(j-1))'};
    z_enu(j) = {position_enu(:,3+3*(j-1))'};
    
    x(j) = {position(:,1+3*(j-1))'};
    y(j) = {position(:,2+3*(j-1))'};
    z(j) = {position(:,3+3*(j-1))'};

    phi(j) = {attitude(:,1+5*(j-1))'};
    theta(j) = {attitude(:,2+5*(j-1))'};
    psi(j) = {attitude(:,3+5*(j-1))'};
    course(j) = {attitude(:,4+5*(j-1))'};
    gamma(j) = {attitude(:,5+5*(j-1))'};

    lateral_err(j) = {squeeze(G_error(1+3*(j-1),1,:))'};
    forward_err(j) = {squeeze(G_error(2+3*(j-1),1,:))'};
    vertical_err(j) = {squeeze(G_error(3+3*(j-1),1,:))'};

end
    
position_L = get(out.logsout, 'position_L').Values.Data;
x_L = position_L(:,1);
y_L = position_L(:,2);
z_L = position_L(:,3);

position_L_enu = position_L*T.R_NED_ENU;
x_L_enu = position_L_enu(:,1);
y_L_enu = position_L_enu(:,2);
z_L_enu = position_L_enu(:,3);


% Va = get(out.logsout, 'Va').Values.Data;
%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 16;
%%
% 
% figure();
% plot(t, lateral_err, t, forward_err, '-','linewidth',1.5); hold on;
% plot(t, vertical_err, '-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Distance[m]','interpreter','latex','fontsize',tickfont);
% % title('Formation error', 'fontsize',titlefont);
% legend("lateral error","forward error","vertical error",'interpreter','latex','fontsize',legendfont,'location','best')
% grid on; grid minor;

figure();

x8_1 = uav_visualization('X8-leader');
x8_2 = uav_visualization('X8');
x8_3 = uav_visualization('X8');

uav_scale = 1;
colors = colormap(jet(length(t))); 

% UAV location setup 
time_interval = 0.5; % 0.5s
Stoptime = t(end); % simulation stoptime
target_time_points = 1:time_interval:Stoptime;
UAV_locations_points = [1];
UAV_locations = [1];
target_index = 1;
ratio = 10; % 5s

for i = 1:length(t)
    if t(i) > target_time_points(target_index)
        UAV_locations_points = [UAV_locations_points i];
        if mod(target_index,ratio) ==0 
            UAV_locations = [UAV_locations i]; %% time_interval * ratio
        end
        target_index = target_index+1;
    end
end
UAV_locations_points = [UAV_locations_points length(t)]; % add last time point
UAV_locations = [UAV_locations length(t)];
%%
plot3(x_L_enu, y_L_enu, z_L_enu,'-.','linewidth',1, 'color', 'b'); hold on;
for i = UAV_locations
    % plot follower uavs
    x8_1.draw(phi{1}(i), theta{1}(i), psi{1}(i), x{1}(i), y{1}(i), z{1}(i), uav_scale);
    x8_2.draw(phi{2}(i), theta{2}(i), psi{2}(i), x{2}(i), y{2}(i), z{2}(i), uav_scale);
    x8_3.draw(phi{3}(i), theta{3}(i), psi{3}(i), x{3}(i), y{3}(i), z{3}(i), uav_scale);
    % plot virtual leader
    plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',15,"color","g");
    % plot wind
    % q = quiver3(x_enu(i), y_enu(i), z_enu(i), w_e(i), w_n(i), w_u(i), 0,'b','linewidth',1);
    % q.MaxHeadSize = 1;

    % plot airspeed
    % Vav = T.R_NED_ENU*T.rotation(phi(i), theta(i), psi(i))*[Va(i);0;0];
    % qv = quiver3(x_enu(i), y_enu(i), z_enu(i), Vav(1), Vav(2), Vav(3),'r','linewidth',1);
    % qv.MaxHeadSize = 1;
end
for i = UAV_locations_points
    plot3(x_enu{1}(i), y_enu{1}(i), z_enu{1}(i),'.','MarkerSize',5,"color",colors(i,:));
    plot3(x_enu{2}(i), y_enu{2}(i), z_enu{2}(i),'.','MarkerSize',5,"color",colors(i,:));
    plot3(x_enu{3}(i), y_enu{3}(i), z_enu{3}(i),'.','MarkerSize',5,"color",colors(i,:));

end
c=colorbar('FontSize',tickfont,'Ticks',linspace(0,1,11),'TickLabels',linspace(0,t(end),11));
c.Label.String = 'Time[s]';
c.Label.FontSize = titlefont;

% for i = 1:100:length(t)
%   plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i), '.','MarkerSize',5,"color",colors(i,:)); hold on;
% end
% c=colorbar('Ticks',linspace(0,1,11),'TickLabels',linspace(0,t(end),11));
% c.Label.String = 'Time[s]';

xlabel('x[m]','interpreter','latex','fontsize',tickfont);
ylabel('y[m]','interpreter','latex','fontsize',tickfont);
zlabel('z[m]','interpreter','latex','fontsize',tickfont);
% title('Trajectory','fontsize',titlefont);
% legend("Trajectory","","","$V_w$","$V_a$","reference",'interpreter','latex','fontsize',legendfont,'location','best')
legend("Virtual leader path","Virtual leader","","","Wind speed","Airspeed",'interpreter','latex','fontsize',legendfont,'location','best')
axis equal;
set(gca, 'Clipping', 'off');
% camproj('perspective');
% zlim([80, 110]);
% view([0,-1,0]);
% view(2);
grid on; grid minor;
