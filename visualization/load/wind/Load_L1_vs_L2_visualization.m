% uav_visualization 
close all;
clear;
clc;

%% load data
% L1_01_L2_01 = load("./data/L1_01_L2_01_line_wind_sine.mat");
L1 = ["01","1","10"];
L2 = ["01","1","10"];
for i = 1:length(L1)
    for j = 1:length(L2)
        eval(['L1_',char(L1(i)),'_L2_',char(L2(j)),'=load("./data/observer/init_error_-10/L1_',char(L1(i)),'_L2_',char(L2(j)), '_line_wind_sine_30s.mat")']);
    end
end

%  
% T = transformation(eye(3), [0;0;0]);
% 
% wind velocity ground truth
%% data allocation
t = L1_01_L2_01.out.tout;

wind_g = get(L1_01_L2_01.out.logsout, 'wind_g').Values.Data;
wind_g = transpose(squeeze(wind_g));
w_l = wind_g(:,1);
w_f = wind_g(:,2);
w_h = wind_g(:,3);

% wind acceleration ground truth
wind_ga = get(L1_01_L2_01.out.logsout, 'wind_ga').Values.Data;
wind_ga = transpose(squeeze(wind_ga));
wa_l = wind_ga(:,1);
wa_f = wind_ga(:,2);
wa_h = wind_ga(:,3);

w_l2 = w_l;
w_f2 = w_f;
w_h2 = w_h;
for i = 1:length(L1)
    for j = 1:length(L2)
        wg_hat = eval(['get(L1_',char(L1(i)),'_L2_',char(L2(j)),'.out.logsout,"w_g_hat").Values.Data']);
        wg2_hat = eval(['get(L1_',char(L1(i)),'_L2_',char(L2(j)),'.out.logsout,"w_g2_hat").Values.Data']);
        wga_hat = eval(['get(L1_',char(L1(i)),'_L2_',char(L2(j)),'.out.logsout,"w_ga_hat").Values.Data']);
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
end


%% plot style
titlefont = 16;
tickfont = 14;
legendfont = 14;
L = 1:10;
line_s = ["--","-.",":"];
%% plot
%% plot L1 : wl2
% L1 = 0.1
figure('Name','L1: wl2');
tiledlayout(3,1)
nexttile
plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_l2(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_l2(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_l2(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%% wf2 %%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','L1: wf2');
tiledlayout(3,1)
nexttile
plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_f2(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_f2(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_f2(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;


%%%%%%%%%%%%%%%%%%%%%% wh2 %%%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','L1: wh2');
tiledlayout(3,1)
nexttile
plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_h2(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_h2(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_h2(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;
%% plot error : wl2
% L1 = 0.1
figure('Name','error: wl2');
tiledlayout(3,1)
nexttile
% plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_l2(:,i)-w_l2(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_l2(:,i)-w_l2(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_l2(:,i)-w_l2(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%% wf2 %%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','error : wf2');
tiledlayout(3,1)
nexttile
% plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_f2(:,i)-w_f2(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_f2(:,i)-w_f2(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, w_f2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_f2(:,i)-w_f2(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;


%%%%%%%%%%%%%%%%%%%%%% wh2 %%%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','L1: wh2');
tiledlayout(3,1)
nexttile
% plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_h2(:,i)-w_h2(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1=0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_h2(:,i)-w_h2(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1=1$','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, w_h2(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_h2(:,i)-w_h2(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1=10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;


% %% plot L2 : wl2
% % L2 = 0.1
% figure('Name','L2');
% subplot(3,1,1)
% plot(t, w_l2(:,1),'-','linewidth',1.5);  hold on;
% for i = [2,5,8]
%     plot(t, w_l2(:,i),'-.','linewidth',1.5);
% end
% ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
% title('L2 = 0.1','interpreter','latex','fontsize',titlefont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on;
% 
% % L2 = 1
% subplot(3,1,2)
% plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
% for i = [3,6,9]
%     plot(t, w_l2(:,i),'-.','linewidth',1.5);
% end
% ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
% title('L2 = 1','interpreter','latex','fontsize',titlefont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on; 
% 
% % L2 = 10
% subplot(3,1,3)
% plot(t, w_l2(:,1),'-','linewidth',1.5); hold on;
% for i = [4,7,10]
%     plot(t, w_l2(:,i),'-.','linewidth',1.5);
% end
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
% title('L2 = 10','interpreter','latex','fontsize',titlefont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on; 
%% plot L1 : wl
% L1 = 0.1
figure('Name','L1');
subplot(3,1,1)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, w_l(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('L1=0.1','interpreter','latex','fontsize',titlefont);

legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
subplot(3,1,2)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, w_l(:,i),'-.','linewidth',1.5);
end
title('L1=1','interpreter','latex','fontsize',titlefont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);

legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
subplot(3,1,3)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, w_l(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('L1=10','interpreter','latex','fontsize',titlefont);
legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;


%% plot L2 : wl , L2 doesn't affect the result of L1
% figure('Name','wl');
% plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
% for i = [4,7,10]
%     plot(t, w_l(:,i),'-.','linewidth',1.5);
% end
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
% title('$\hat{w_l}$','interpreter','latex','fontsize',titlefont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on; 

%% plot w vs w2: L1 = 1, L2 = 0.1, 1, 10
%%%%%%%%%%%%%%%%%%%%%%%%% wl %%%%%%%%%%%%%%%%%%%%%
% L2 = 0.1
figure('Name','wl vs wl2');
subplot(3,1,1)
plot(t, w_l(:,1),'-','linewidth',1.5);  hold on;
for i = [5]
    plot(t, w_l(:,i),'-.','linewidth',1.5);
    plot(t, w_l2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 0.1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{l}}$","$\hat{w_{l_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L2 = 1
subplot(3,1,2)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = [6]
    plot(t, w_l(:,i),'-.','linewidth',1.5);
    plot(t, w_l2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{l}}$","$\hat{w_{l_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 

% L2 = 10
subplot(3,1,3)
plot(t, w_l(:,1),'-','linewidth',1.5); hold on;
for i = [7]
    plot(t, w_l(:,i),'-.','linewidth',1.5);
    plot(t, w_l2(:,i),'-.','linewidth',1.5);
end
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 10$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{l}}$","$\hat{w_{l_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 

%%%%%%%%%%%%%%%%%%%%%% wf %%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','wf vs wf2');
subplot(3,1,1)
plot(t, w_f(:,1),'-','linewidth',1.5);  hold on;
for i = [5]
    plot(t, w_f(:,i),'-.','linewidth',1.5);
    plot(t, w_f2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 0.1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{f}}$","$\hat{w_{f_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L2 = 1
subplot(3,1,2)
plot(t, w_f(:,1),'-','linewidth',1.5); hold on;
for i = [6]
    plot(t, w_f(:,i),'-.','linewidth',1.5);
    plot(t, w_f2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{f}}$","$\hat{w_{f_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 

% L2 = 10
subplot(3,1,3)
plot(t, w_f(:,1),'-','linewidth',1.5); hold on;
for i = [7]
    plot(t, w_f(:,i),'-.','linewidth',1.5);
    plot(t, w_f2(:,i),'-.','linewidth',1.5);
end
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 10$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{f}}$","$\hat{w_{f_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 

%%%%%%%%%%%%%%%%%%%%%% wh %%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name','wh vs wh2');
subplot(3,1,1)
plot(t, w_h(:,1),'-','linewidth',1.5);  hold on;
for i = [5]
    plot(t, w_h(:,i),'-.','linewidth',1.5);
    plot(t, w_h2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 0.1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{h}}$","$\hat{w_{h_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L2 = 1
subplot(3,1,2)
plot(t, w_h(:,1),'-','linewidth',1.5); hold on;
for i = [6]
    plot(t, w_h(:,i),'-.','linewidth',1.5);
    plot(t, w_h2(:,i),'-.','linewidth',1.5);
end
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 1$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{h}}$","$\hat{w_{h_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 

% L2 = 10
subplot(3,1,3)
plot(t, w_h(:,1),'-','linewidth',1.5); hold on;
for i = [7]
    plot(t, w_h(:,i),'-.','linewidth',1.5);
    plot(t, w_h2(:,i),'-.','linewidth',1.5);
end
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 1, L_2 = 10$','interpreter','latex','fontsize',titlefont);

legend("GT","$\hat{w_{h}}$","$\hat{w_{h_2}}$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on; 
%% plot wa_l
% L1 = 0.1
figure('Name','L1:wal');
tiledlayout(3,1)
nexttile
plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_l(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_l(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_l(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%%%%% waf %%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 = 0.1
figure('Name','L1:waf');
tiledlayout(3,1)
nexttile
plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_f(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_f(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_f(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%%%%%% wah %%%%%%%%%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','L1:wah');
tiledlayout(3,1)
nexttile
plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_h(:,i),line_s(i-1),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_h(:,i),line_s(i-4),'linewidth',1.5);
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_h(:,i),line_s(i-7),'linewidth',1.5);
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("GT","$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;


%% error : wa
figure('Name','error : wal');
tiledlayout(3,1)
nexttile
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_l(:,i)-wa_l(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_l(:,i)-wa_l(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_l(:,i)-wa_l(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%%%%% waf %%%%%%%%%%%%%%%%%%%%%%%%%%%

% L1 = 0.1
figure('Name','error:waf');
tiledlayout(3,1)
nexttile
% plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_f(:,i)-wa_f(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_f(:,i)-wa_f(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, wa_f(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_f(:,i)-wa_f(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;

%%%%%%%%%%%%%%%%%%%%% wah %%%%%%%%%%%%%%%%%%%%%%%%%%
% L1 = 0.1
figure('Name','error:wah');
tiledlayout(3,1)
nexttile
% plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(2:4)
    plot(t, wa_h(:,i)-wa_h(:,1),line_s(i-1),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
title('$L_1 = 0.1$','interpreter','latex','fontsize',titlefont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 1
nexttile
% plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(5:7)
    plot(t, wa_h(:,i)-wa_h(:,1),line_s(i-4),'linewidth',1.5);hold on;
end
title('$L_1 = 1$','interpreter','latex','fontsize',titlefont);
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);

% legend("GT","$L2 = 0.1$","$L2 = 1$","$L2 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
grid on;

% L1 = 10
nexttile
% plot(t, wa_h(:,1),'-','linewidth',1.5); hold on;
for i = L(8:10)
    plot(t, wa_h(:,i)-wa_h(:,1),line_s(i-7),'linewidth',1.5);hold on;
end
ylabel('Accel$[m/s^2]$','interpreter','latex','fontsize',tickfont);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
title('$L_1 = 10$','interpreter','latex','fontsize',titlefont);
legend("$L_2 = 0.1$","$L_2 = 1$","$L_2 = 10$",'interpreter','latex','fontsize',legendfont,'location','southoutside', 'orientation', 'horizontal')
grid on;
%% plot wa_l
% % L2 = 0.1
% figure('Name','L1');
% subplot(3,1,1)
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
% for i = [2,5,8]
%     plot(t, wa_l(:,i),'-.','linewidth',1.5);
% end
% ylabel('$Accel[m/s^2]$','interpreter','latex','fontsize',tickfont);
% title('L2=0.1','interpreter','latex','fontsize',titlefont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on;
% 
% % L2 = 1
% subplot(3,1,2)
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
% for i = [3,6,9]
%     plot(t, wa_l(:,i),'-.','linewidth',1.5);
% end
% title('L2=1','interpreter','latex','fontsize',titlefont);
% ylabel('$Accel[m/s^2]$','interpreter','latex','fontsize',tickfont);
% 
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on;
% 
% % L2 = 10
% subplot(3,1,3)
% plot(t, wa_l(:,1),'-','linewidth',1.5); hold on;
% for i = [4,7,10]
%     plot(t, wa_l(:,i),'-.','linewidth',1.5);
% end
% ylabel('$Accel[m/s^2]$','interpreter','latex','fontsize',tickfont);
% xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
% title('L2=10','interpreter','latex','fontsize',titlefont);
% legend("GT","$L1 = 0.1$","$L1 = 1$","$L1 = 10$",'interpreter','latex','fontsize',legendfont,'location','bestoutside')
% grid on;
%% 

