% uav_visualization 
clc;
clear;
close all;
%% generate customized message
% folderPath = fullfile(pwd,"ros");
% ros2genmsg(folderPath);
%% import data
% Define the bag file path and topic name
bagPath = './ros/rosbag/1026_02_25-45-5_fixed_wing_id';
% bagPath = './ros/rosbag/1026_025_fixed_wing_id';

% bagPath = './ros/rosbag/0930_Va10_windned050-5gust1p20d90_f0_pathLdir0_L1_com_off';

cmdtopic = '/command_information';

% Create a rosbag reader object
reader = ros2bagreader(bagPath);

% Read messages from the specified topic
cmdbagSel = select(reader,"Topic",cmdtopic);

cmdmsgs = readMessages(cmdbagSel);

%% 
% Extract timestamps and data
t_cmd = cellfun(@(m) double(m.timestamp), cmdmsgs); % Va, psi, theta % cmd, true, err
Vaf_c = cellfun(@(m) m.array.data(1), cmdmsgs); 
% Vaf_d = cellfun(@(m) m.array.data(2), cmdmsgs); 
Vaf = cellfun(@(m) m.array.data(2), cmdmsgs);
Vaf_err = cellfun(@(m) m.array.data(3), cmdmsgs);

psif_c = cellfun(@(m) m.array.data(4), cmdmsgs); 
% psif_d = cellfun(@(m) m.array.data(6), cmdmsgs); 
psif = cellfun(@(m) m.array.data(5), cmdmsgs);
psif_err = cellfun(@(m) m.array.data(6), cmdmsgs);

thetaf_c = cellfun(@(m) m.array.data(7), cmdmsgs); 
% thetaf_d = cellfun(@(m) m.array.data(10), cmdmsgs); 
thetaf = cellfun(@(m) m.array.data(8), cmdmsgs);
thetaf_err = cellfun(@(m) m.array.data(9), cmdmsgs);

%%
% time rescale, micro sec to sec
t_cmd = (t_cmd - t_cmd(1))/1000000;

%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 14;

tickfontbar = 14;
titlefontbar = 16;
legendfontbar = 18;

%% ID to first order system by tfest
np = 1;
ts = 0.02;
data_va = iddata(double(Vaf), double(Vaf_c), ts);
data_psi = iddata(double(psif), double(psif_c), ts);
data_theta = iddata(double(thetaf), double(thetaf_c), ts);

% sys_Va = tfest(double(Vaf_c), double(Vaf), np, 'Ts', ts);
% sys_psi = tfest(double(psif_c), double(psif), np, 'Ts', ts);
% sys_theta = tfest(double(thetaf_c), double(thetaf), np, 'Ts', ts);

sys_Va = tfest(data_va, np);
sys_psi = tfest(data_psi, np);
sys_theta = tfest(data_theta, np);

% sys_Va_c = d2c(sys_Va);
% sys_psi_c = d2c(sys_psi);
% sys_theta_c = d2c(sys_theta);

%% plot 
figure('Name','Control inputs');

subplot(3,1,1);
plot(t_cmd, Vaf_c,t_cmd, Vaf,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
% title('Control inputs','interpreter','latex','fontsize',titlefont);
legend("$V_{aF}^c$","$V_{aF}$",'interpreter','latex','fontsize',legendfont,'location','southeast')
grid on; 
% grid minor;

subplot(3,1,2);
% figure('Name','Control inputs psi');
plot(t_cmd, psif_c,t_cmd, psif,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\psi_F^c$","$\psi_F$",'interpreter','latex','fontsize',legendfont,'location','southeast')
grid on; 
% grid minor;

subplot(3,1,3);
% figure('Name','Control inputs theta');
plot(t_cmd, thetaf_c,t_cmd, thetaf,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\theta_{F}^c$","$\theta_{F}$",'interpreter','latex','fontsize',legendfont,'location','southeast')
grid on; 
% grid minor;

%% plot 
figure('Name','Control inputs error');

subplot(3,1,1);
plot(t_cmd, Vaf_err,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
% title('Control inputs','interpreter','latex','fontsize',titlefont);
legend("$V_{aF_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;

subplot(3,1,2);
% figure('Name','Control inputs psi');
plot(t_cmd, psif_err,'-','linewidth',1.5); hold on;
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\psi_{F_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;

subplot(3,1,3);
% figure('Name','Control inputs theta');
plot(t_cmd, thetaf_err,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('[rad]','interpreter','latex','fontsize',tickfont);
% title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
legend("$\theta_{F_{e}}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; 
% grid minor;
