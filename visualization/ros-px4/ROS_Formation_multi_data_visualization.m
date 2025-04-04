% uav_visualization 
clc;
clear;
close all;
%% generate customized message
% folderPath = fullfile(pwd,"ros");
% ros2genmsg(folderPath);
%% import data
% Define the path
% Circle
% bagPath = './ros/rosbag/1216_nowind_path-C_r-400_com-off'; % nowind_nocom
% bagPath = './ros/rosbag/1216_wind_path-C_r-400_com-off'; % nowind_nocom
% bagPath = './ros/rosbag/1216_wind_path-C_r-400_com-on'; % nowind_nocom
bagPath = './ros/rosbag/250223_wind_path-C_r-400_com-off'; % IROS
% bagPath = './ros/rosbag/250223_wind_path-C_r-400_com-on'; % IROS

% straight
% bagPath = './ros/rosbag/1216_nowind_path-L_dir-45_com-off'; % nowind_nocom
% bagPath = './ros/rosbag/1216_wind_path-L_dir-45_com-off'; % nowind_nocom
% bagPath = './ros/rosbag/1216_wind_path-L_dir-45_com-on'; % nowind_nocom
% bagPath = './ros/rosbag/250223_wind_path-L_dir-45_com-off'; % IROS
% bagPath = './ros/rosbag/250223_wind_path-L_dir-45_com-on'; % IROS

% bagPath = './ros/rosbag/0910_ICRA/0910_a2_windned500-5gust1p20d90_pathLdir0_L1_com_on';

% Create a rosbag reader object
reader = ros2bagreader(bagPath);


%% save data setting
tra = "circular";
com = "off";
save_type = "epsc";
save_path = "./result/px4/iros/"+tra+"/wind_com-"+com+"/";
save = false;
ton = false;

%% plot style
titlefont = 18;
tickfont = 16;
legendfont = 12;

%%
UAV = ["/px4_1", "/px4_2", "/px4_3"];
uav_num = length(UAV);
cases = "wind_com-"+com+"_tra-"+tra+"_uav-";
UAV_attitude = cell(1,uav_num);
UAV_position = cell(1,uav_num);
UAV_time = cell(1,uav_num);

UAV_offset = [[0,0,0];[-3,-3,0];[-3,3,0]];

for uav = 1:length(UAV)
    case_name = cases+num2str(uav);

    leadertopic = '/virtual_leader_information';
    
    windtopic = UAV(uav)+'/wind_estimation_information';
    vehicletopic = UAV(uav)+'/fmu/out/vehicle_local_position';
    vehicleattitudetopic = UAV(uav)+'/fmu/out/vehicle_attitude';
    vehiclestatustopic = UAV(uav)+'/fmu/out/vehicle_status';

    cmdtopic = UAV(uav)+'/data/control_inputs';
    errortopic = UAV(uav)+'/data/formation_error';
    
    
    % Read messages from the specified topic
    windbagSel = select(reader,"Topic",windtopic);
    leaderbagSel = select(reader,"Topic",leadertopic);
    vehiclebagSel = select(reader,"Topic",vehicletopic);
    vehicleattbagSel = select(reader,"Topic",vehicleattitudetopic);
    vehiclestabagSel = select(reader,"Topic",vehiclestatustopic);

    cmdbagSel = select(reader,"Topic",cmdtopic);
    errorbagSel = select(reader,"Topic",errortopic);
    
    windmsgs = readMessages(windbagSel);
    leadermsgs = readMessages(leaderbagSel);
    vehiclemsgs = readMessages(vehiclebagSel);
    vehicleattmsgs = readMessages(vehicleattbagSel);
    vehiclestamsgs = readMessages(vehiclestabagSel);

    cmdmsgs = readMessages(cmdbagSel);
    errormsgs = readMessages(errorbagSel);
    
    %% 
    % Extract timestamps and data
    t_wind = cellfun(@(m) double(m.timestamp), windmsgs);
    w_l2_hat = cellfun(@(m) m.array.data(1), windmsgs); % Adjust this line based on your message structure
    w_f2_hat = cellfun(@(m) m.array.data(2), windmsgs);
    w_h2_hat = cellfun(@(m) m.array.data(3), windmsgs);
    w_al_hat = cellfun(@(m) m.array.data(4), windmsgs); % Adjust this line based on your message structure
    w_af_hat = cellfun(@(m) m.array.data(5), windmsgs);
    w_ah_hat = cellfun(@(m) m.array.data(6), windmsgs);
    w_l_hat = cellfun(@(m) m.array.data(7), windmsgs); % Adjust this line based on your message structure
    w_f_hat = cellfun(@(m) m.array.data(8), windmsgs);
    w_h_hat = cellfun(@(m) m.array.data(9), windmsgs);
    w_l = cellfun(@(m) m.array.data(13), windmsgs); % Adjust this line based on your message structure
    w_f = cellfun(@(m) m.array.data(14), windmsgs);
    w_h = cellfun(@(m) m.array.data(15), windmsgs);
    w_al = diff(w_l)/0.02; % ts = 0.02
    w_af = diff(w_f)/0.02;
    w_ah = diff(w_h)/0.02;
    w_al = [0; w_al];
    w_af = [0; w_af];
    w_ah = [0; w_ah];

    
    t_leader = cellfun(@(m) double(m.timestamp), leadermsgs);
    x_L = cellfun(@(m) m.array.data(1), leadermsgs); % Adjust this line based on your message structure
    y_L = cellfun(@(m) m.array.data(2), leadermsgs);
    z_L = cellfun(@(m) m.array.data(3), leadermsgs);
    UAV_leader_position = [x_L, y_L, z_L];
    
    t_vehicle = cellfun(@(m) double(m.timestamp), vehiclemsgs);
    x = cellfun(@(m) m.x, vehiclemsgs)+UAV_offset(uav,1); % Adjust this line based on your message structure
    y = cellfun(@(m) m.y, vehiclemsgs)+UAV_offset(uav,2);
    z = cellfun(@(m) m.z, vehiclemsgs)+UAV_offset(uav,3);
    
    
    t_vehicle_att = cellfun(@(m) double(m.timestamp), vehicleattmsgs);
    q_w = cellfun(@(m) m.q(1), vehicleattmsgs); % Adjust this line based on your message structure
    q_x = cellfun(@(m) m.q(2), vehicleattmsgs);
    q_y = cellfun(@(m) m.q(3), vehicleattmsgs);
    q_z = cellfun(@(m) m.q(4), vehicleattmsgs);
    
    attitude = quat2eul([q_w, q_x, q_y, q_z]); % ZYX: yaw, pich,roll
    psi= attitude(:,1);
    theta = attitude(:,2);
    phi = attitude(:,3);

    t_vehicle_sta = cellfun(@(m) double(m.timestamp), vehiclestamsgs);
    status = cellfun(@(m) m.nav_state, vehiclestamsgs); % Adjust this line based on your message structure


    t_cmd = cellfun(@(m) double(m.timestamp), cmdmsgs); % Va, psi, theta % cmd, true, err
    Vaf_c = cellfun(@(m) m.array.data(1), cmdmsgs); 
    Vaf_d = cellfun(@(m) m.array.data(2), cmdmsgs); 
    Vaf = cellfun(@(m) m.array.data(3), cmdmsgs);
    Vaf_err = cellfun(@(m) m.array.data(4), cmdmsgs);
    
    psif_c = cellfun(@(m) m.array.data(5), cmdmsgs); 
    psif_d = cellfun(@(m) m.array.data(6), cmdmsgs); 
    psif = cellfun(@(m) m.array.data(7), cmdmsgs);
    psif_err = cellfun(@(m) m.array.data(8), cmdmsgs);
    
    thetaf_c = cellfun(@(m) m.array.data(9), cmdmsgs); 
    thetaf_d = cellfun(@(m) m.array.data(10), cmdmsgs); 
    thetaf = cellfun(@(m) m.array.data(11), cmdmsgs);
    thetaf_err = cellfun(@(m) m.array.data(12), cmdmsgs);
    
    t_error = cellfun(@(m) double(m.timestamp), errormsgs);
    lateral_err = cellfun(@(m) m.array.data(1), errormsgs); 
    forward_err = cellfun(@(m) m.array.data(2), errormsgs);
    vertical_err = cellfun(@(m) m.array.data(3), errormsgs);
    
    %%
    % time rescale, micro sec to sec
    t = (t_vehicle - t_vehicle(1))/1000000;
    t_vehicle_att = (t_vehicle_att - t_vehicle_att(1))/1000000;
    t_vehicle_sta = (t_vehicle_sta - t_vehicle_sta(1))/1000000;

    t_leader = (t_leader - t_leader(1))/1000000;

    t_wind = (t_wind - t_wind(1))/1000000;
    t_cmd = (t_cmd - t_cmd(1))/1000000;
    t_error = (t_error - t_error(1))/1000000;
    
    
    %%  reallocate time : takeoff, transition, formation time
    tt = [];
    status_change = diff(double(status));
    for i =1:length(status_change)
        if status_change(i) ~= 0
            tt(end+1) = t_vehicle_sta(i);
        end 
    end
    t_takeoff = 0;
    t_transition = tt(2)-tt(1);
    t_formation = tt(3)-tt(1);
    t_compensation = 50;

    t_wind = t_wind + t_formation;
    t_cmd = t_cmd + t_formation;
    t_error = t_error + t_formation;
    
    for i = 1:length(t)
        if t(i)> tt(1)
            t = t(i:end)-tt(1);
            t_vehicle_att = t_vehicle_att(i:end)-tt(1);
            x = x(i:end);
            y = y(i:end);
            z = z(i:end);
            UAV_position{1,uav} = [x, y, z];
            attitude = attitude(i:end,:);
            UAV_attitude{1,uav} = attitude;
            UAV_time{1,uav} = t;
            break
        end
    end 



    %%
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
    label = {'t_1','t_i'};
    timestamps = [t_transition t_formation];
    %%
    figure('Name','Control inputs');
    
    subplot(3,1,1);
    xline(timestamps, '-.', label, 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r','t_{on}','LabelHorizontalAlignment','center','LabelOrientation','horizontal' ,'HandleVisibility','off');
    end

    plot(t_cmd, Vaf_c,t_cmd, Vaf_d,t_cmd, Vaf,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
    % title('Control inputs','interpreter','latex','fontsize',titlefont);
    legend("$V_{a_F}^c$","$V_{a_F}^d$","$V_{a_F}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')

    % grid on; 
    % grid minor;
    
    subplot(3,1,2);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    % figure('Name','Control inputs psi');
    plot(t_cmd, psif_c,t_cmd, psif_d,t_cmd, psif,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[rad]','interpreter','latex','fontsize',tickfont);
    % title('$psi_F^c$','interpreter','latex','fontsize',titlefont);
    legend("$\psi_F^c$","$\psi_F^d$","$\psi_{F}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on; 
    % grid minor;
    
    subplot(3,1,3);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end

    % figure('Name','Control inputs theta');
    plot(t_cmd, thetaf_c,t_cmd, thetaf_d,t_cmd, thetaf,'-','linewidth',1.5); hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[rad]','interpreter','latex','fontsize',tickfont);
    % title('$\theta_F^c$','interpreter','latex','fontsize',titlefont);
    legend("$\theta_F^c$","$\theta_F^d$","$\theta_{F}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on; 
    % grid minor;

    % save figure
    if save
        saveas(gcf, save_path+"control_inputs_"+case_name, save_type)
    end
    %% control inputs error
    figure('Name','Control inputs error');
    subplot(3,1,1);
    xline(timestamps, '-.', label, 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r','t_{on}','LabelHorizontalAlignment','center','LabelOrientation','horizontal' ,'HandleVisibility','off');
    end
    plot(t_cmd, Vaf_err,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
    title('${V_a}_e^d$','interpreter','latex','fontsize',titlefont);
    % legend("${V_a}_e^d$",'interpreter','latex','fontsize',legendfont,'location','southeast')
    grid on; 
    % grid minor;
    
    subplot(3,1,2);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    % figure('Name','Control inputs psi');
    plot(t_cmd, psif_err,'-','linewidth',1.5); hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[rad]','interpreter','latex','fontsize',tickfont);
    title('$\psi_e^d$','interpreter','latex','fontsize',titlefont);
    % legend("$\psi_{F_e}^d$",'interpreter','latex','fontsize',legendfont,'location','southeast')
    grid on; 
    % grid minor;
    
    subplot(3,1,3);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    % figure('Name','Control inputs theta');
    plot(t_cmd, thetaf_err,'-','linewidth',1.5); hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[rad]','interpreter','latex','fontsize',tickfont);
    title('$\theta_e^d$','interpreter','latex','fontsize',titlefont);
    % legend("$\theta_{F_e}^d$",'interpreter','latex','fontsize',legendfont,'location','southeast')
    grid on; 
    % grid minor;

    % save figure
    if save
        saveas(gcf, save_path+"control_inputs_error_"+case_name, save_type)
    end
    %% Wind velocity
    figure('Name','Wind velocity');

    subplot(3,1,1);
    xline(timestamps, '-.', label, 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r','t_{on}','LabelHorizontalAlignment','center','LabelOrientation','horizontal' ,'HandleVisibility','off');
    end
    plot(t_wind, w_l,'-', t_wind, w_l2_hat,'-.','linewidth',1.5);hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
    % title('$\{I\}$','interpreter','latex','fontsize',titlefont);
    legend("$w_l$","$\hat{w_l}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;

    subplot(3,1,2);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    plot(t_wind, w_f,'-', t_wind, w_f2_hat,'-.','linewidth',1.5);hold on;

    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
    legend("$w_f$","$\hat{w_f}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;

    subplot(3,1,3);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    plot(t_wind, w_h,'-', t_wind, w_h2_hat,'-.','linewidth',1.5);hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m/s]','interpreter','latex','fontsize',tickfont);
    legend("$w_h$","$\hat{w_h}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;
    % save figure
    if save
        saveas(gcf, save_path+"wind_"+case_name, save_type)
    end
    %% Wind acceleration
    figure('Name','Wind acceleration');
    subplot(3,1,1);
    xline(timestamps, '-.', label, 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r','t_{on}','LabelHorizontalAlignment','center','LabelOrientation','horizontal' ,'HandleVisibility','off');
    end
    plot(t_wind, w_al,'-', t_wind, w_al_hat,'-.','linewidth',1.5);hold on;
    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('$[m/s^2]$','interpreter','latex','fontsize',tickfont);
    % title('$\{I\}$','interpreter','latex','fontsize',titlefont);
    legend("$a_l$","$\hat{a_l}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;

    subplot(3,1,2);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    plot(t_wind, w_af,'-', t_wind, w_af_hat,'-.','linewidth',1.5);hold on;

    % xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('$[m/s^2]$','interpreter','latex','fontsize',tickfont);
    % title('$\{I\}$','interpreter','latex','fontsize',titlefont);
    legend("$a_f$","$\hat{a_f}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;

    subplot(3,1,3);
    xline(timestamps, '-.', 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r', 'HandleVisibility','off');
    end
    plot(t_wind, w_ah,'-', t_wind, w_ah_hat,'-.','linewidth',1.5);hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('$[m/s^2]$','interpreter','latex','fontsize',tickfont);
    % title('$\{I\}$','interpreter','latex','fontsize',titlefont);
    legend("$a_h$","$\hat{a_h}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
    % grid on;
    % save figure
    if save
        saveas(gcf, save_path+"wind_accel_"+case_name, save_type)
    end
    %% formation error
    figure('Name','formation error');
    xline(timestamps, '-.', label, 'LabelHorizontalAlignment', 'center', 'LabelOrientation', 'horizontal' ,'HandleVisibility', 'off'); hold on;
    if ton == true
        xline(t_compensation,'-.r','t_{on}','LabelHorizontalAlignment','center','LabelOrientation','horizontal' ,'HandleVisibility','off');
    end
    plot(t_error, lateral_err, t_error, forward_err, '-','linewidth',1.5); hold on;
    plot(t_error, vertical_err, '-','linewidth',1.5); hold on;
    xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
    ylabel('[m]','interpreter','latex','fontsize',tickfont);
    % title('Formation error', 'fontsize',titlefont);
    legend("$l_e$","$f_e$","$h_e$",'interpreter','latex','fontsize',legendfont,'location','best')
    grid on; 
    % save figure
    if save
        saveas(gcf, save_path+"formation_error_"+case_name, save_type)
    end
end
%% trajecotry
Load_multi_trajectory_visualization(UAV_time, t_leader, UAV_position, UAV_attitude, UAV_leader_position, uav_num, ceil(t(end)));
