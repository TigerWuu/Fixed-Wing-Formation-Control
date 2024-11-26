% uav_visualization 
close all;
clear;
clc;

%% load data
path = "./data/formation/wind_no/";
wind_com = ["yes","no"];
  
for i = 1:length(wind_com)
    eval(['wind_no_windcom_',char(wind_com(i)),'=load("', char(path),'line_45_wind_no_com_',char(wind_com(i)),'_70s.mat")']);
end
%% save data setting
save_type = "eps";
save_path = "./result/formation/straight/";

%% plot style
titlefont = 20;
tickfont = 16;
legendfont = 12;
line_s = ["-","-.",":"];
%% data allocation
t = wind_no_windcom_no.out.tout;
lateral_error = zeros(length(t),1);
forward_error = zeros(length(t),1);
vertical_error = zeros(length(t),1);

wind_g = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"wind_g").Values.Data']);
wind_ga = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"wind_ga").Values.Data']);
wind_g = transpose(squeeze(wind_g));
wind_ga = transpose(squeeze(wind_ga));

w_l = wind_g(:,1);
w_f = wind_g(:,2);
w_h = wind_g(:,3);

wa_l = wind_ga(:,1);
wa_f = wind_ga(:,2);
wa_h = wind_ga(:,3);
for i = 1:length(wind_com)
    case_name = wind_com(i);
    G_error = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"G_error").Values.Data']);
    va_vs = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"va_vs").Values.Data']);
    psi_vs = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"psi_vs").Values.Data']);
    theta_vs = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"theta_vs").Values.Data']);
    % observer result
    wg2_hat = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"w_g2_hat").Values.Data']);
    wga_hat = eval(['get(wind_no_windcom_',char(wind_com(i)),'.out.logsout,"w_ga_hat").Values.Data']);
    wg2_hat = transpose(squeeze(wg2_hat));
    wga_hat = transpose(squeeze(wga_hat));

    lateral_err = squeeze(G_error(1,1,:));
    forward_err = squeeze(G_error(2,1,:));
    vertical_err = squeeze(G_error(3,1,:));

    lateral_error = cat(2,lateral_error, lateral_err);
    forward_error = cat(2,forward_error, forward_err);
    vertical_error = cat(2,vertical_error, vertical_err);

    va = va_vs(:,1);
    va_c = va_vs(:,2);
    va_d = va_vs(:,3);

    psi = psi_vs(:,1);
    psi_c = psi_vs(:,2);
    psi_d = psi_vs(:,3);

    theta = theta_vs(:,1);
    theta_c = theta_vs(:,2);
    theta_d = theta_vs(:,3);

    va_e = va-va_d;
    psi_e = psi-psi_d;
    theta_e = theta-theta_d;
    for k = 1:length(psi_e)
        while psi_e(k) < -pi
            psi_e(k) = psi_e(k) + 2*pi;
        end
        while psi_e(k) > pi
            psi_e(k) = psi_e(k) - 2*pi;
        end
    end 

    w_l2_hat = wg2_hat(:,1);
    w_f2_hat = wg2_hat(:,2);
    w_h2_hat = wg2_hat(:,3);
    wa_l_hat = wga_hat(:,1);
    wa_f_hat = wga_hat(:,2);
    wa_h_hat = wga_hat(:,3);    
    %% wind observer
    % velocity
    stopt = 30;
    figure('Name','wind velocity');
    tiledlayout(3,1)
    nexttile
    plot(t, w_l,'-','linewidth',1.5); hold on;
    plot(t, w_l2_hat,'-.','linewidth',1.5); hold on;
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    title('$\hat{w_{l_2}}$','interpreter','latex','fontsize',titlefont);
    xlim([0,stopt])
    % legend("GT","$\hat{w_{l_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on;
    
    nexttile
    plot(t, w_f,'-','linewidth',1.5); hold on;
    plot(t, w_f2_hat,'-.','linewidth',1.5); hold on;
    title('$\hat{w_{f_2}}$','interpreter','latex','fontsize',titlefont);
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    xlim([0,stopt])
    % legend("GT","$\hat{w_{f_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on;

    nexttile
    plot(t, w_h,'-','linewidth',1.5); hold on;
    plot(t, w_h2_hat,'-.','linewidth',1.5); hold on;
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    title('$\hat{w_{h_2}}$','interpreter','latex','fontsize',titlefont);
    legend("GT","Estimation",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
    xlim([0,stopt])
    grid on;
    % save figure
    saveas(gcf, save_path+"nowind_vel_"+case_name, save_type)

    % acceleration
    figure('Name','wind acceleration');
    tiledlayout(3,1)
    nexttile
    plot(t, wa_l,'-','linewidth',1.5); hold on;
    plot(t, wa_l_hat,'-.','linewidth',1.5); hold on;
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    title('$\hat{a_l}$','interpreter','latex','fontsize',titlefont);
    xlim([0,stopt])
    % legend("GT","$\hat{w_{l_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on;
    
    nexttile
    plot(t, wa_f,'-','linewidth',1.5); hold on;
    plot(t, wa_f_hat,'-.','linewidth',1.5); hold on;
    title('$\hat{a_f}$','interpreter','latex','fontsize',titlefont);
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    xlim([0,stopt])
    % legend("GT","$\hat{w_{f_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on;

    nexttile
    plot(t, wa_h,'-','linewidth',1.5); hold on;
    plot(t, wa_h_hat,'-.','linewidth',1.5); hold on;
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    title('$\hat{a_h}$','interpreter','latex','fontsize',titlefont);
    legend("GT","Estimation",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
    xlim([0,stopt])
    grid on;
    % save figure
    saveas(gcf, save_path+"nowind_accel_"+case_name, save_type)

    %% control inputs
    figure("Name",wind_com(i));
    subplot(3,1,1);
    plot(t, va,t, va_c, t, va_d,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
    title('States','interpreter','latex','fontsize',titlefont);
    legend("${V_a}_F$","${V_a}_F^c$","${V_a}_F^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % grid minor;
    
    subplot(3,1,2);
    % figure('Name','Control inputs psi');
    plot(t, psi,t, psi_c, t, psi_d,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('Angles[rad]','interpreter','latex','fontsize',tickfont);
    % title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
    legend("$\psi_F$","$\psi_F^c$","$\psi_F^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % grid minor;
    
    subplot(3,1,3);
    % figure('Name','Control inputs theta');
    plot(t, theta,t, theta_c, t, theta_d,'-','linewidth',1.5); hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('Angles[rad]','interpreter','latex','fontsize',tickfont);
    % title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
    legend("$\theta_F$","$\theta_F^c$","$\theta_F^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % save figure
    saveas(gcf, save_path+"nowind_control_inputs_"+case_name, save_type)

    %% control inputs error
    figure("Name",wind_com(i));
    subplot(3,1,1);
    
    plot(t, va_e,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('${V_a}_e^d$[m/s]','interpreter','latex','fontsize',tickfont);
    title('States error','interpreter','latex','fontsize',titlefont);
    % legend("${V_a}_e^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % grid minor;
    
    subplot(3,1,2);
    % figure('Name','Control inputs psi');
    plot(t, psi_e,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('$\psi_e^d$[rad]','interpreter','latex','fontsize',tickfont);
    % title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
    % legend("$\psi_e^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % grid minor;
    
    subplot(3,1,3);
    % figure('Name','Control inputs theta');
    plot(t, theta_e,'-','linewidth',1.5); hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('$\theta_e^d$[rad]','interpreter','latex','fontsize',tickfont);
    % title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
    % legend("$\theta_e^d$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    grid on; 
    % save figure
    saveas(gcf, save_path+"nowind_control_inputs_error"+case_name, save_type)

    %% caculate distance IAE, RMSE. steady-state
    % IAE, RMSE
    % IAE = 0;
    RMSE = 0;
    RMSE_l = 0;
    RMSE_f = 0;
    RMSE_h = 0;
    
    num = 0;
    for m = 1:length(t)
        if t(m) > 40
            % IAE = IAE+sqrt(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
            RMSE_l = RMSE_l + abs(lateral_err(m));
            RMSE_f = RMSE_f + abs(forward_err(m));
            RMSE_h = RMSE_h + abs(vertical_err(m));
    
            RMSE = RMSE+sqrt(lateral_err(m)^2+forward_err(m)^2+vertical_err(m)^2);
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
    display([wind_com(i)]);
    display(["RMSE = ", num2str(RMSE)]);
    display(["RMSE l = ", num2str(RMSE_l)]);
    display(["RMSE f = ", num2str(RMSE_f)]);
    display(["RMSE h = ", num2str(RMSE_h)]);

    %% visualization
    % eval(['Load_trajectory_visualization(wind_no_windcom_',char(wind_com(i))]);
end
%% visualization
Stoptime = t(end);
Load_trajectory_visualization(wind_no_windcom_no, Stoptime);
Load_trajectory_visualization(wind_no_windcom_yes, Stoptime);

%% plot wind com vs no wind com : formation error
figure('Name','formation_error_vs');
tiledlayout(3,1)
nexttile
for i = 2:length(lateral_error(1,:))
    plot(t, lateral_error(:,i),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('$l_e$[m]','interpreter','latex','fontsize',tickfont);
title('Formation error','interpreter','latex','fontsize',titlefont);

% legend("Com: yes","Com: no",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
for i = 2:length(forward_error(1,:))
    plot(t, forward_error(:,i),line_s(i-1),'linewidth',1.5);hold on;
end
% title('$f_e$','interpreter','latex','fontsize',titlefont);
ylabel('$f_e$[m]','interpreter','latex','fontsize',tickfont);

% legend("Com: yes","Com: no",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
for i = 2:length(vertical_error(1,:))
    plot(t, vertical_error(:,i),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('$h_e$[m]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% title('$h_e$','interpreter','latex','fontsize',titlefont);
% legend("Com: yes","Com: no",'interpreter','latex','fontsize',legendfont,'location','bestoutside')

legend("Compensation: v","Compensation: x",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;
% save figure
saveas(gcf, save_path+"nowind_formation_error", save_type)


