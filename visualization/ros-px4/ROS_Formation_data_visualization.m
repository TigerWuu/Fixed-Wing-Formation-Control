% uav_visualization 
clc;
clear;
close all;
%% generate customized message
% folderPath = fullfile(pwd,"ros");
% ros2genmsg(folderPath);
%% import data
% Define the bag file path and topic name
% bagPath = './ros/rosbag/0909_a1_windned5d90_pathL_com_on';
% bagPath = './ros/rosbag/0930_Va10_windned050-5gust1p20d90_f0_pathLdir0_L1_com_off';
% bagPath = './ros/rosbag/0930_Va10_windned050-5gust0p0d90_f0_pathLdir0_L1_com_on_true';
bagPath = './ros/rosbag/1001_Vahz10_windned-200gust0p0d90_f0_pathLdir0_L1_com_on_true';
% bagPath = './ros/rosbag/0910_ICRA/0910_a2_windned500-5gust1p20d90_pathLdir0_L1_com_on';

windtopic = '/wind_estimation_information';
windtruetopic = '/fmu/out/wind';
leadertopic = '/virtual_leader_information';
vehicletopic = '/fmu/out/vehicle_local_position';
vehicleattitudetopic = '/fmu/out/vehicle_attitude';
cmdtopic = '/data/control_inputs';
errortopic = '/data/formation_error';

% Create a rosbag reader object
reader = ros2bagreader(bagPath);

% Read messages from the specified topic
windbagSel = select(reader,"Topic",windtopic);
windtruebagSel = select(reader,"Topic",windtruetopic);
leaderbagSel = select(reader,"Topic",leadertopic);
vehiclebagSel = select(reader,"Topic",vehicletopic);
vehicleattbagSel = select(reader,"Topic",vehicleattitudetopic);
cmdbagSel = select(reader,"Topic",cmdtopic);
errorbagSel = select(reader,"Topic",errortopic);

windmsgs = readMessages(windbagSel);
windtruemsgs = readMessages(windtruebagSel);
leadermsgs = readMessages(leaderbagSel);
vehiclemsgs = readMessages(vehiclebagSel);
vehicleattmsgs = readMessages(vehicleattbagSel);
cmdmsgs = readMessages(cmdbagSel);
errormsgs = readMessages(errorbagSel);

%% 
% Extract timestamps and data
t_wind = cellfun(@(m) double(m.timestamp), windmsgs);
w_l_hat = cellfun(@(m) m.array.data(1), windmsgs); % Adjust this line based on your message structure
w_f_hat = cellfun(@(m) m.array.data(2), windmsgs);
w_h_hat = cellfun(@(m) m.array.data(3), windmsgs);
w_n_hat = cellfun(@(m) m.array.data(4), windmsgs); % Adjust this line based on your message structure
w_e_hat = cellfun(@(m) m.array.data(5), windmsgs);
w_d_hat = cellfun(@(m) m.array.data(6), windmsgs);
w_l = cellfun(@(m) m.array.data(7), windmsgs); % Adjust this line based on your message structure
w_f = cellfun(@(m) m.array.data(8), windmsgs);
w_h = cellfun(@(m) m.array.data(9), windmsgs);
w_n = cellfun(@(m) m.array.data(10), windmsgs); % Adjust this line based on your message structure
w_e = cellfun(@(m) m.array.data(11), windmsgs);
w_d = cellfun(@(m) m.array.data(12), windmsgs);

t_wind_true = cellfun(@(m) double(m.timestamp), windtruemsgs);
w_n_ekf = cellfun(@(m) m.windspeed_north, windtruemsgs); % Adjust this line based on your message structure
w_e_ekf = cellfun(@(m) m.windspeed_east, windtruemsgs);

t_leader = cellfun(@(m) double(m.timestamp), leadermsgs);
x_L = cellfun(@(m) m.array.data(1), leadermsgs); % Adjust this line based on your message structure
y_L = cellfun(@(m) m.array.data(2), leadermsgs);
z_L = cellfun(@(m) m.array.data(3), leadermsgs);

t_vehicle = cellfun(@(m) double(m.timestamp), vehiclemsgs);
x = cellfun(@(m) m.x, vehiclemsgs); % Adjust this line based on your message structure
y = cellfun(@(m) m.y, vehiclemsgs);
z = cellfun(@(m) m.z, vehiclemsgs);

t_vehicle_att = cellfun(@(m) double(m.timestamp), vehicleattmsgs);
q_w = cellfun(@(m) m.q(1), vehicleattmsgs); % Adjust this line based on your message structure
q_x = cellfun(@(m) m.q(2), vehicleattmsgs);
q_y = cellfun(@(m) m.q(3), vehicleattmsgs);
q_z = cellfun(@(m) m.q(4), vehicleattmsgs);

attitude = quat2eul([q_w, q_x, q_y, q_z]); % ZYX: yaw, pich,roll
psi= attitude(:,1);
theta = attitude(:,2);
phi = attitude(:,3);


t_cmd = cellfun(@(m) double(m.timestamp), cmdmsgs); % Va, psi, theta % cmd, true, err
Vaf_c = cellfun(@(m) m.array.data(1), cmdmsgs); 
Vaf = cellfun(@(m) m.array.data(2), cmdmsgs);
Vaf_err = cellfun(@(m) m.array.data(3), cmdmsgs);

psif_c = cellfun(@(m) m.array.data(4), cmdmsgs); 
psif = cellfun(@(m) m.array.data(5), cmdmsgs);
psif_err = cellfun(@(m) m.array.data(6), cmdmsgs);

thetaf_c = cellfun(@(m) m.array.data(7), cmdmsgs); 
thetaf = cellfun(@(m) m.array.data(8), cmdmsgs);
thetaf_err = cellfun(@(m) m.array.data(9), cmdmsgs);

t_error = cellfun(@(m) double(m.timestamp), errormsgs);
lateral_err = cellfun(@(m) m.array.data(1), errormsgs); 
forward_err = cellfun(@(m) m.array.data(2), errormsgs);
vertical_err = cellfun(@(m) m.array.data(3), errormsgs);

%%
% time rescale, micro sec to sec
t = (t_vehicle - t_vehicle(1))/1000000;
t_vehicle_att = (t_vehicle_att - t_vehicle_att(1))/1000000;
t_wind = (t_wind - t_wind(1))/1000000;
t_wind_true = (t_wind_true - t_wind_true(1))/1000000;
t_leader = (t_leader - t_leader(1))/1000000;
t_cmd = (t_cmd - t_cmd(1))/1000000;
t_error = (t_error - t_error(1))/1000000;

% NED to ENU to plot
T = transformation(eye(3), [0;0;0]);
position_L_enu = [x_L, y_L, z_L]*transpose(T.R_NED_ENU);
x_L_enu = position_L_enu(:,1);
y_L_enu = position_L_enu(:,2);
z_L_enu = position_L_enu(:,3);

position_enu = [x, y, z]*transpose(T.R_NED_ENU);
x_enu = position_enu(:,1);
y_enu = position_enu(:,2);
z_enu = position_enu(:,3);

%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 14;

tickfontbar = 14;
titlefontbar = 16;
legendfontbar = 18;

%% caculate distance IAE, RMSE. steady-state
% IAE, RMSE
% IAE = 0;
RMSE = 0;
RMSE_l = 0;
RMSE_f = 0;
RMSE_h = 0;

num = 0;
for i = 1:length(t_error)
    if t_error(i) > 40
        % IAE = IAE+sqrt(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
        RMSE_l = RMSE_l + abs(lateral_err(i));
        RMSE_f = RMSE_f + abs(forward_err(i));
        RMSE_h = RMSE_h + abs(vertical_err(i));

        RMSE = RMSE+sqrt(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
        num = num +1;
    end
end
%%
RMSE = sqrt(RMSE/num);
RMSE_l = sqrt(RMSE_l/num);
RMSE_f = sqrt(RMSE_f/num);
RMSE_h = sqrt(RMSE_h/num);
%%
% display(["IAE = ", num2str(IAE)]);
display(["RMSE = ", num2str(RMSE)]);
display(["RMSE l = ", num2str(RMSE_l)]);
display(["RMSE f = ", num2str(RMSE_f)]);
display(["RMSE h = ", num2str(RMSE_h)]);


%%
figure('Name','Control inputs');

subplot(3,1,1);
plot(t_cmd, Vaf_c,t_cmd, Vaf,t_cmd, Vaf_err,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
% title('Control inputs','interpreter','latex','fontsize',titlefont);
legend("$V_{aF}^c$","$V_{aF}$","$V_{aF_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;

subplot(3,1,2);
% figure('Name','Control inputs psi');
plot(t_cmd, psif_c,t_cmd, psif,t_cmd, psif_err,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\psi_F^c$","$\psi_F$","$\psi_{F_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;

subplot(3,1,3);
% figure('Name','Control inputs theta');
plot(t_cmd, thetaf_c,t_cmd, thetaf,t_cmd, thetaf_err,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\theta_F^c$","$\theta_F$","$\theta_{F_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;

% figure();
% plot(t, V_Fc,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
% title('Airspeed command[$V_F^c$]','interpreter','latex','fontsize',titlefont);
% 
% legend("$V_F^c$",'interpreter','latex','fontsize',legendfont,'location','best')
% grid on; grid minor;

% figure();
% phi_deg = phi*180/pi;
% theta_deg = theta*180/pi;
% psi_deg = psi*180/pi;
% course_deg = course*180/pi;
% plot(t, phi_deg, t, theta_deg, t, psi_deg,'-','linewidth',1.5); hold on;
% plot(t, course_deg,'-.','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
% title('Attitude[Body]', 'fontsize',titlefont);
% legend("$\phi$","$\theta$","$\psi$","$\chi$",'interpreter','latex','fontsize',legendfont,'location','best')
% grid on; grid minor;

% figure();
% course_L_deg = course_L*180/pi;
% course_Fc_deg = course_Fc*180/pi;
% plot(t, course_L_deg, t, course_Fc_deg, t, course_deg,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
% title('Course comparison', 'fontsize',titlefont);
% legend("$\chi_L$","$\chi_{Fc}$","$\chi_{F}$",'interpreter','latex','fontsize',legendfont,'location','best')
% grid on; grid minor;
figure('Name','Wind');

% subplot(2,1,1);
% % plot(t_wind, w_n, t_wind, w_e, t_wind, -w_u,'-','linewidth',1.5); hold on;
% plot(t_wind, w_l,'-', t_wind, w_f,'-', t_wind, w_h,'-','linewidth',1.5); hold on;
% plot(t_wind, w_l_hat,'-.', t_wind, w_f_hat,'-.', t_wind, w_h_hat,'-.','linewidth',1.5);
% % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
% % title('$\{G\}$','interpreter','latex','fontsize',titlefont);
% 
% legend("$w_l$","$w_f$","$w_h$","$\hat{w_l}$","$\hat{w_f}$","$\hat{w_h}$",'interpreter','latex','fontsize',legendfont,'location','best')
% grid on; grid minor;

% subplot(2,1,2);
for i=1:length(t_wind_true)
    if t_wind_true(i) < 0
        t_wind_true(i) = t_wind_true(i+1);
        w_n_ekf(i) = w_n_ekf(i+1);
        w_e_ekf(i) = w_e_ekf(i+1);
    end
end

plot(t_wind, w_n,'-', t_wind, w_e,'-', t_wind, w_d,'-','linewidth',1.5);hold on;
plot(t_wind, w_n_hat,'-.', t_wind, w_e_hat,'-.', t_wind, w_d_hat,'-.','linewidth',1.5);hold on;
plot(t_wind_true, w_n_ekf,'.', t_wind_true, w_e_ekf,'.','linewidth',1.5);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
title('$\{I\}$','interpreter','latex','fontsize',titlefont);

legend("$w_x$","$w_y$","$w_z$","$\hat{w_x}$","$\hat{w_y}$","$\hat{w_z}$","$\hat{w_x}_{ekf}$","$\hat{w_y}_{ekf}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
plot(t_error, lateral_err, t_error, forward_err, '-','linewidth',1.5); hold on;
plot(t_error, vertical_err, '-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[m]','interpreter','latex','fontsize',tickfont);
% title('Formation error', 'fontsize',titlefont);
legend("$l_e$","$f_e$","$h_e$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
x8_vis = uav_visualization('X8');
x8_leader = uav_visualization('X8-leader');

uav_scale = 10;
colors = colormap(jet(length(t))); 

% UAV location setup 
time_interval = 0.1; % 0.5s
Stoptime = t(end); % simulation stoptime
target_time_points = 1:time_interval:Stoptime+1;
UAV_locations_points = [1];
UAV_locations = [1];
target_index = 1;
ratio = 20; % 10s

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
    % plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i),'.','MarkerSize',15,"color","g");
    x8_vis.draw(phi(i), theta(i), psi(i), x(i), y(i), z(i), uav_scale);

    % wind vector
    % q = quiver3(x_enu(i), y_enu(i), z_enu(i), w_e(i), w_n(i), w_u(i), 0,'b','linewidth',1);
    % q.MaxHeadSize = 1;
    % airspeed vector
    % Vav = T.R_NED_ENU*T.rotation(phi(i), theta(i), psi(i))*[Va(i);0;0];
    % qv = quiver3(x_enu(i), y_enu(i), z_enu(i), Vav(1), Vav(2), Vav(3),'r','linewidth',1);
    % qv.MaxHeadSize = 1;
end
for i = UAV_locations_points
    plot3(x_enu(i), y_enu(i), z_enu(i),'.','MarkerSize',5,"color",colors(i,:));
end
c=colorbar('FontSize',tickfontbar,'Ticks',linspace(0,1,11),'TickLabels',linspace(0,ceil(t(end))+1,11),'Location','south');
c.Label.String = 'Time[s]';
c.Label.FontSize = titlefontbar;

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
legend("Leader trajectory",'interpreter','latex','fontsize',legendfontbar,'location','best')
axis equal;

xlim([-100, 100]);
% view([0,-1,0]);
view(90,90);
% view(2);
grid on; 
% grid minor;

