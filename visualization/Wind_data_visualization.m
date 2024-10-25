% uav_visualization 
close all;
%% get data
t = out.tout;

T = transformation(eye(3), [0;0;0]);

% wind velocity ground truth
wind_g = get(out.logsout, 'wind_g').Values.Data;
wind_g = transpose(squeeze(wind_g));
w_l = wind_g(:,1);
w_f = wind_g(:,2);
w_h = wind_g(:,3);

% wind acceleration ground truth
wind_ga = get(out.logsout, 'wind_ga').Values.Data;
wind_ga = transpose(squeeze(wind_ga));
wa_l = wind_ga(:,1);
wa_f = wind_ga(:,2);
wa_h = wind_ga(:,3);

% wind velocity estimation {G}
wg_hat = get(out.logsout, 'w_g_hat').Values.Data;
wg_hat = transpose(squeeze(wg_hat));
w_l_hat = wg_hat(:,1);
w_f_hat = wg_hat(:,2);
w_h_hat = wg_hat(:,3);

% wind velocity estimation 2 {G}
wg2_hat = get(out.logsout, 'w_g2_hat').Values.Data;
wg2_hat = transpose(squeeze(wg2_hat));
w_l2_hat = wg2_hat(:,1);
w_f2_hat = wg2_hat(:,2);
w_h2_hat = wg2_hat(:,3);

% wind acceleration estimation {G}
wga_hat = get(out.logsout, 'w_ga_hat').Values.Data;
wga_hat = transpose(squeeze(wga_hat));
wa_l_hat = wga_hat(:,1);
wa_f_hat = wga_hat(:,2);
wa_h_hat = wga_hat(:,3);

%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 16;
%% wind velocity
figure('Name','Wind velocity');
plot(t, w_l, t, w_f, t, w_h,'-','linewidth',1.5); hold on;
plot(t, w_l_hat,'-.', t, w_f_hat,'-.', t, w_h_hat,'-.','linewidth',1.5);
plot(t, w_l2_hat,'-.', t, w_f2_hat,'-.', t, w_h2_hat,'-.','linewidth',1.5);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('Wind','interpreter','latex','fontsize',titlefont);

legend("$w_n$","$w_e$","$w_d$","$\hat{w_n}$","$\hat{w_e}$","$\hat{w_d}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

%% wind acceleration
figure('Name','Wind acceleration');
plot(t, wa_l, t, wa_f, t, wa_h,'-','linewidth',1.5); hold on;
plot(t, wa_l_hat,'-.', t, wa_f_hat,'-.', t, wa_h_hat,'-.','linewidth',1.5);
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('Wind','interpreter','latex','fontsize',titlefont);

legend("$w_n$","$w_e$","$w_d$","$\hat{w_n}$","$\hat{w_e}$","$\hat{w_d}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;
%%
% xlim([10, 70]);
% ylim([8, 12]);
% hold off;

% figure();
% wind_avi = VideoWriter('wind.avi');
% open(wind_avi);
% for i = 1:1000:length(t)
%     q = quiver3(0, 0, 0, w_e(i), w_n(i), w_u(i), 0,'b','linewidth',1);
%     q.MaxHeadSize = 1;
%     xlabel('e','interpreter','latex','fontsize',tickfont);
%     ylabel('n','interpreter','latex','fontsize',tickfont);
%     view(2);
%     xlim([-6, 0]);
%     ylim([-6, 0]);
%     pause(0.001);
%     frame = getframe(gcf);
%     writeVideo(wind_avi, frame);
% end
% close(wind_avi);



