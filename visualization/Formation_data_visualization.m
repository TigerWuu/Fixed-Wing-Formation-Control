% uav_visualization 
close all;
%% import data
t = out.tout;

T = transformation(eye(3), [0;0;0]);

attitude = get(out.logsout, 'attitude').Values.Data;
phi= attitude(:,1);
theta = attitude(:,2);
psi = attitude(:,3);
course = attitude(:,4);

% course_L = get(out.logsout, 'course_L').Values.Data;
% course_L= attitude(:,1);


position_enu = get(out.logsout, 'position_ENU').Values.Data;
x_enu = position_enu(:,1);
y_enu = position_enu(:,2);
z_enu = position_enu(:,3);

position = get(out.logsout, 'position').Values.Data;
x = position(:,1);
y = position(:,2);
z = position(:,3);

position_L = get(out.logsout, 'position_L').Values.Data;
x_L = position_L(:,1);
y_L = position_L(:,2);
z_L = position_L(:,3);

courseLFc = get(out.logsout, 'courseLF').Values.Data;
course_L = courseLFc(:,1);
course_Fc = courseLFc(:,2);

VFc = get(out.logsout, 'VFc').Values.Data;
V_Fc = VFc(:,1);

G_error = get(out.logsout, 'G_error').Values.Data;
lateral_err = squeeze(G_error(1,1,:));
forward_err = squeeze(G_error(2,1,:));
vertical_err = squeeze(G_error(3,1,:));


position_L_enu = position_L*T.R_NED_ENU;
x_L_enu = position_L_enu(:,1);
y_L_enu = position_L_enu(:,2);
z_L_enu = position_L_enu(:,3);

winds = get(out.logsout, 'wind').Values.Data;
winds_enu = winds*transpose(T.R_NED_ENU); % (R*P)^T = P^T*R^T
w_e = winds_enu(:,1);
w_n = winds_enu(:,2);
w_u = winds_enu(:,3);

Va = get(out.logsout, 'Va').Values.Data;
%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 14;
%% caculate distance IAE, RMSE. steady-state
% IAE, RMSE
IAE = 0;
RMSE = 0;
num = 0;
for i = 1:length(t)
    if t(i) > 20
        IAE = IAE+sqrt(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
        RMSE = RMSE+lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2;
        num = num +1;
    end
end
RMSE = sqrt(RMSE/num);
display(["IAE = ", num2str(IAE)]);
display(["RMSE = ", num2str(RMSE)]);



%%

figure();
plot(t, V_Fc,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('Airspeed command[$V_F^c$]','interpreter','latex','fontsize',titlefont);

legend("$V_F^c$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
phi_deg = phi*180/pi;
theta_deg = theta*180/pi;
psi_deg = psi*180/pi;
course_deg = course*180/pi;
plot(t, phi_deg, t, theta_deg, t, psi_deg,'-','linewidth',1.5); hold on;
plot(t, course_deg,'-.','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
title('Attitude[Body]', 'fontsize',titlefont);
legend("$\phi$","$\theta$","$\psi$","$\chi$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
course_L_deg = course_L*180/pi;
course_Fc_deg = course_Fc*180/pi;
plot(t, course_L_deg, t, course_Fc_deg, t, course_deg,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
title('Course comparison', 'fontsize',titlefont);
legend("$\chi_L$","$\chi_{Fc}$","$\chi_{F}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
plot(t, lateral_err, t, forward_err, '-','linewidth',1.5); hold on;
plot(t, vertical_err, '-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Distance[m]','interpreter','latex','fontsize',tickfont);
% title('Formation error', 'fontsize',titlefont);
legend("lateral error","forward error","vertical error",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
x8_vis = uav_visualization('X8');
x8_leader = uav_visualization('X8-leader');

uav_scale = 5;
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
    % x8_leader.draw(phi(i), theta(i), psi(i), x_L(i), y_L(i), z_L(i), uav_scale);
    plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',15,"color","g");
    x8_vis.draw(phi(i), theta(i), psi(i), x(i), y(i), z(i), uav_scale);
    
    q = quiver3(x_enu(i), y_enu(i), z_enu(i), w_e(i), w_n(i), w_u(i), 0,'b','linewidth',1);
    q.MaxHeadSize = 1;
    
    Vav = T.R_NED_ENU*T.rotation(phi(i), theta(i), psi(i))*[Va(i);0;0];
    qv = quiver3(x_enu(i), y_enu(i), z_enu(i), Vav(1), Vav(2), Vav(3),'r','linewidth',1);
    qv.MaxHeadSize = 1;
end
for i = UAV_locations_points
    plot3(x_enu(i), y_enu(i), z_enu(i),'.','MarkerSize',5,"color",colors(i,:));
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
% zlim([80, 110]);
% view([0,-1,0]);
% view(2);
grid on; grid minor;

