% uav_visualization 
close all;
clear;
clc;

%% load data
err = ["-10","0","10"];
err_name = ["_10","0","10"];
for i = 1:length(err)
    eval(['init_',char(err_name(i)),'=load("./data/observer/init_error_',char(err(i)), '/L1_1_L2_01_line_wind_sine_30s.mat")']);
end


%  
% T = transformation(eye(3), [0;0;0]);
% 
% wind velocity ground truth
%% data allocation
t = init_0.out.tout;

wind_g = get(init_0.out.logsout, 'wind_g').Values.Data;
wind_g = transpose(squeeze(wind_g));
w_l = wind_g(:,1);
w_f = wind_g(:,2);
w_h = wind_g(:,3);

% wind acceleration ground truth
wind_ga = get(init_0.out.logsout, 'wind_ga').Values.Data;
wind_ga = transpose(squeeze(wind_ga));
wa_l = wind_ga(:,1);
wa_f = wind_ga(:,2);
wa_h = wind_ga(:,3);

w_l2 = w_l;
w_f2 = w_f;
w_h2 = w_h;
for i = 1:length(err_name)
    wg_hat = eval(['get(init_',char(err_name(i)),'.out.logsout,"w_g_hat").Values.Data']);
    wg2_hat = eval(['get(init_',char(err_name(i)),'.out.logsout,"w_g2_hat").Values.Data']);
    wga_hat = eval(['get(init_',char(err_name(i)),'.out.logsout,"w_ga_hat").Values.Data']);
    wg_hat = transpose(squeeze(wg_hat));
    wg2_hat = transpose(squeeze(wg2_hat));
    wga_hat = transpose(squeeze(wga_hat));

    w_l_hat = wg_hat(:,1);
    w_f_hat = wg_hat(:,2);
    w_h_hat = wg_hat(:,3);
    w_l2_hat = wg2_hat(:,1);
    w_f2_hat = wg2_hat(:,2);
    w_h2_hat = wg2_hat(:,3);
    wa_l_hat = wga_hat(:,1);
    wa_f_hat = wga_hat(:,2);
    wa_h_hat = wga_hat(:,3);    
    % wl
    w_l = cat(2,w_l,w_l_hat);
    w_l2 = cat(2,w_l2,w_l2_hat);
    wa_l = cat(2,wa_l,wa_l_hat);
    % wf
    w_f = cat(2,w_f,w_f_hat);
    w_f2 = cat(2,w_f2,w_f2_hat);
    wa_f = cat(2,wa_f,wa_f_hat);
    % wh
    w_h = cat(2,w_h,w_h_hat);
    w_h2 = cat(2,w_h2,w_h2_hat);
    wa_h = cat(2,wa_h,wa_h_hat);
end


%% plot style
titlefont = 20;
tickfont = 14;
legendfont = 12;

%% plot
% L1 = 1, L2 = 0.1
init_err = 2:4;
line_s = ["--","-.",":"];
%% plot wl, wf, wh
figure('Name','wl wf wh');
% wl
tiledlayout(3,1)
nexttile
% subplot(3,1,1)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_l(:,i),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$\hat{w_l}$','interpreter','latex','fontsize',titlefont);

% legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% wf
nexttile
% subplot(3,1,2)
plot(t, w_f(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_f(:,i),line_s(i-1),'linewidth',1.5); hold on;
end
title('$\hat{w_f}$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% wh
nexttile
% subplot(3,1,3)
plot(t, w_h(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_h(:,i),line_s(i-1),'linewidth',1.5); hold on;
end

ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$\hat{w_h}$','interpreter','latex','fontsize',titlefont);
legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%% plot wl2, wf2, wh2
figure('Name','wl wf wh');
% wl
tiledlayout(3,1)
nexttile
% subplot(3,1,1)
plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_l2(:,i),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$\hat{w_{l_2}}$','interpreter','latex','fontsize',titlefont);

% legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

% wf
nexttile
% subplot(3,1,2)
plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_f2(:,i),line_s(i-1),'linewidth',1.5); hold on;
end
title('$\hat{w_{f_2}}$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','southoutside')
grid on;

% wh
nexttile
% subplot(3,1,3)
plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = init_err
    plot(t, w_h2(:,i),line_s(i-1),'linewidth',1.5); hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$\hat{w_{h_2}}$','interpreter','latex','fontsize',titlefont);
legend("GT","err=-10","err=0","err=10",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;
%% plot error = -10, 0, 10
