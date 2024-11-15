% uav_visualization 
close all;
clear;
clc;

%% load data
path = ["line","circle"];
dc = ["d","c"];
for i = 1:length(path)
    for j = 1:length(dc)
        eval([char(path(i)),'_',char(dc(j)),'=load("./data/formation/',char(path(i)),'_',char(dc(j)), '_no_wind_70s.mat")']);
    end
end


%% plot style
titlefont = 20;
tickfont = 16;
legendfont = 12;
%% data allocation
t = line_d.out.tout;

for i = 1:length(path)
    for j = 1:length(dc) 
        G_error = eval(['get(',char(path(i)),'_',char(dc(j)),'.out.logsout,"G_error").Values.Data']);
        va_vs = eval(['get(',char(path(i)),'_',char(dc(j)),'.out.logsout,"va_vs").Values.Data']);
        psi_vs = eval(['get(',char(path(i)),'_',char(dc(j)),'.out.logsout,"psi_vs").Values.Data']);
        theta_vs = eval(['get(',char(path(i)),'_',char(dc(j)),'.out.logsout,"theta_vs").Values.Data']);

        lateral_err = squeeze(G_error(1,1,:));
        forward_err = squeeze(G_error(2,1,:));
        vertical_err = squeeze(G_error(3,1,:));

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
            while psi_e(i) > pi
                psi_e(k) = psi_e(k) - 2*pi;
            end
        end 
        %% formation error
        figure("Name",path(i)+"_"+dc(j));
        subplot(3,1,1);
        plot(t, lateral_err, '-','linewidth',1.5);
        ylabel('$l_e$[m]','interpreter','latex','fontsize',tickfont);
        title('Formation error','interpreter','latex','fontsize',titlefont);
        grid on;
        subplot(3,1,2);
        plot(t, forward_err, '-','linewidth',1.5);
        ylabel('$f_e$[m]','interpreter','latex','fontsize',tickfont);
        grid on;
        subplot(3,1,3);
        plot(t, vertical_err, '-','linewidth',1.5);
        ylabel('$h_e$[m]','interpreter','latex','fontsize',tickfont);

        xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
        % title('Formation error', 'fontsize',titlefont);
        % legend("lateral error","forward error","vertical error",'interpreter','latex','fontsize',legendfont,'location','best')
        grid on;

        %% control inputs
        figure("Name",path(i)+"_"+dc(j));
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

        %% control inputs error

        figure("Name",path(i)+"_"+dc(j));
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
        display([path(i)+"_"+dc(j)]);
        display(["RMSE = ", num2str(RMSE)]);
        display(["RMSE l = ", num2str(RMSE_l)]);
        display(["RMSE f = ", num2str(RMSE_f)]);
        display(["RMSE h = ", num2str(RMSE_h)]);
    end
end