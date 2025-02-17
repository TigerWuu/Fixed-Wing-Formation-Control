% uav_visualization 
close all;
clear;
clc;

%% load data
path = "./data/formation/wind/";
wind_dir = ["135", "-135"];
wind_dir_n = ["135", "_135"];
wind_mag = ["2", "8"];
wind_prop = ["c" , "s"];
wind_com = ["yes","no"];

% for case name
wind_dir_case = ["D+135", "D-135"];
wind_mag_case = ["M2", "M8"];
wind_prop_case = ["Pc" , "Ps"];
wind_com_case = ["Cv","Cx"];

cases = cell(2,2,2,2);
for i = 1:length(wind_com)
    for j = 1:length(wind_prop)
        for k = 1:length(wind_mag)
            for l = 1:length(wind_dir)
                 eval(['wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'=load("', char(path),'line_45_wind_',char(wind_dir(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'_70s.mat")']);
                 eval(['cases{i,j,k,l} = ','wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i))]);
            end
        end
    end
end
%% save data setting
save_type = "epsc";
save_path = "./result/formation/straight/";
%% plot style
titlefont = 20;
tickfont = 16;
legendfont = 12;
line_s = ["-","-.",":"];
%% data allocation
t = wind_135_2_c_yes.out.tout;

performance_cases = [];
cases_title = cell(1,16);
cases_num = 0;



for l = 1:length(wind_dir)
    for j = 1:length(wind_prop)
        for k = 1:length(wind_mag)
            lateral_error = [];
            forward_error = [];
            vertical_error = [];
            for i = 1:length(wind_com)
                case_name = wind_dir_case(l)+wind_mag_case(k)+wind_prop_case(j)+wind_com_case(i);
                cases_num = cases_num + 1;

                G_error = eval(['get(wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'.out.logsout,"G_error").Values.Data']);
                va_vs = eval(['get(wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'.out.logsout,"va_vs").Values.Data']);
                psi_vs = eval(['get(wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'.out.logsout,"psi_vs").Values.Data']);
                theta_vs = eval(['get(wind_',char(wind_dir_n(l)),'_',char(wind_mag(k)),'_',char(wind_prop(j)),'_',char(wind_com(i)),'.out.logsout,"theta_vs").Values.Data']);
            
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
                for kk = 1:length(psi_e)
                    while psi_e(kk) < -pi
                        psi_e(kk) = psi_e(kk) + 2*pi;
                    end
                    while psi_e(kk) > pi
                        psi_e(kk) = psi_e(kk) - 2*pi;
                    end
                end 
            
                %% control inputs
                figure("Name",case_name);
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
                % saveas(gcf, save_path+"control_inputs_"+case_name, save_type)
            
                %% control inputs error
            
                figure("Name",case_name);
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
                % saveas(gcf, save_path+"control_inputs_error_"+case_name, save_type)
                %% caculate distance IAE, RMSE. steady-state
                % IAE, RMSE

                ts = 20;
                points = 0:1:t(end);
                index = 1;
                num = 0;

                RMSE = 0;
                RMSE_l = 0;
                RMSE_f = 0;
                RMSE_h = 0;
                
                IAE = 0;
                
                for m = 1:length(t)
                    if t(m) > ts
                        RMSE_l = RMSE_l + lateral_err(m)^2;
                        RMSE_f = RMSE_f + forward_err(m)^2;
                        RMSE_h = RMSE_h + vertical_err(m)^2;
                
                        RMSE = RMSE+(lateral_err(m)^2+forward_err(m)^2+vertical_err(m)^2);
                        num = num +1;
                    else
                        if t(m) >=points(index)
                            IAE = IAE+sqrt(lateral_err(m)^2+forward_err(m)^2+vertical_err(m)^2);
                            index = index + 1;
                        end
                    end
                end
                %%
                RMSE = sqrt(RMSE/num);
                RMSE_l = sqrt(RMSE_l/num);
                RMSE_f = sqrt(RMSE_f/num);
                RMSE_h = sqrt(RMSE_h/num);
                %%
                display([case_name]);

                display(["IAE = ", num2str(IAE)]);
                display(["RMSE = ", num2str(RMSE)]);
                display(["RMSE l = ", num2str(RMSE_l)]);
                display(["RMSE f = ", num2str(RMSE_f)]);
                display(["RMSE h = ", num2str(RMSE_h)]);
                
                performance_case = [IAE; RMSE; RMSE_l; RMSE_f; RMSE_h];
                performance_cases = cat(2,performance_cases, performance_case);
                cases_title{1,cases_num} = case_name;

                %% visualization
                Stoptime = t(end);
                % Load_trajectory_visualization(cases{i,j,k,l}, Stoptime);
                % eval(['Load_trajectory_visualization(wind_no_windcom_',char(wind_com(i))]);
            end
            %% plot wind com vs no wind com : formation error
            figure('Name','formation_error_'+wind_dir(l)+"_"+wind_mag(k)+"_"+wind_prop(j));
            tiledlayout(3,1)
            nexttile
            for m = 1:length(lateral_error(1,:))
                plot(t, lateral_error(:,m),line_s(m),'linewidth',1.5);hold on;
            end
            ylabel('$l_e$[m]','interpreter','latex','fontsize',tickfont);
            title('Formation error','interpreter','latex','fontsize',titlefont);
            grid on;
            
            nexttile
            for m = 1:length(forward_error(1,:))
                plot(t, forward_error(:,m),line_s(m),'linewidth',1.5);hold on;
            end
            ylabel('$f_e$[m]','interpreter','latex','fontsize',tickfont);
            grid on;
            
            nexttile
            for m = 1:length(vertical_error(1,:))
                plot(t, vertical_error(:,m),line_s(m),'linewidth',1.5);hold on;
            end
            ylabel('$h_e$[m]','interpreter','latex','fontsize',tickfont);
            xlabel('Times[s]','interpreter','latex','fontsize',tickfont);            
            legend("Wind com on","Wind com off",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
            grid on;
            % save figure
            % saveas(gcf, save_path+"formation_error_"+case_name, save_type)
        end
    end
end

%% visualization
% Stoptime = t(end);
% Load_trajectory_visualization(wind_no_windcom_no, Stoptime);
% Load_trajectory_visualization(wind_no_windcom_yes, Stoptime);

%% save data
performance_indices_name = {"Cases";"IAE";"RMSE";"RMSE_l";"RMSE_f";"RMSE_h"};
performance_indices = [cases_title; num2cell(performance_cases)];
performance_indices = [performance_indices_name performance_indices];
% save("./csv/straight_case_name.mat","cases_title")
writecell(performance_indices,'./csv/wind_straight_name_mod.xlsx');

