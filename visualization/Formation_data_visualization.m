% uav_visualization 
close all;
t = out.tout;

T = transformation(eye(3), [0;0;0]);

attitude = get(out.logsout, 'attitude').Values.Data;
phi= attitude(:,1);
theta = attitude(:,2);
psi = attitude(:,3);
course = attitude(:,4);

position_enu = get(out.logsout, 'position_ENU').Values.Data;
x_enu = position_enu(:,1);
y_enu = position_enu(:,2);
z_enu = position_enu(:,3);

position = get(out.logsout, 'position').Values.Data;
x = position(:,1);
y = position(:,2);
z = position(:,3);

position_L = get(out.logsout, 'position_L').Values.Data;
x_L = position(:,1);
y_L = position(:,2);
z_L = position(:,3);

courseLFc = get(out.logsout, 'courseLF').Values.Data;
course_L = courseLFc(:,1);
course_Fc = courseLFc(:,2);

G_error = get(out.logsout, 'G_error').Values.Data;
lateral_err = squeeze(G_error(1,1,:));
forward_err = squeeze(G_error(2,1,:));


position_L_enu = position_L*transpose(T.R_NED_ENU);
x_L_enu = position_L_enu(:,1);
y_L_enu = position_L_enu(:,2);
z_L_enu = position_L_enu(:,3);

winds = get(out.logsout, 'ws').Values.Data;
ws_n = winds(:,1);
ws_e = winds(:,2);
ws_d = winds(:,3);

Va = get(out.logsout, 'Va').Values.Data;
%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 16;


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
plot(t, course_L_deg, t, course_Fc_deg,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
title('Course comparison', 'fontsize',titlefont);
legend("$\chi_L$","$\chi_{Fc}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
plot(t, lateral_err, t, forward_err,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Distance[m]','interpreter','latex','fontsize',tickfont);
title('Geometry error', 'fontsize',titlefont);
legend("lateral error","forward error",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
x8_vis = uav_visualization('X8');
uav_scale = 5;

colors = colormap(jet(length(t))); 

for i = 1:100:length(t)
  plot3(x_enu(i), y_enu(i), z_enu(i),'.','MarkerSize',5,"color",colors(i,:)); hold on;
  if mod((i-1),1000) == 0
    x8_vis.draw(phi(i), theta(i), psi(i), x(i), y(i), z(i), uav_scale);
    q = quiver3(x_enu(i), y_enu(i), z_enu(i), ws_n(i), ws_e(i), ws_d(i), 0,'b','linewidth',1);
    q.MaxHeadSize = 1;
    
    Vav = T.R_NED_ENU*T.rotation(phi(i), theta(i), psi(i))*[Va(i);0;0];
    qv = quiver3(x_enu(i), y_enu(i), z_enu(i), Vav(1), Vav(2), Vav(3),'r','linewidth',1);
    qv.MaxHeadSize = 1;
  end
end
c=colorbar('FontSize',tickfont,'Ticks',linspace(0,1,11),'TickLabels',linspace(0,t(end),11));
c.Label.String = 'Time[s]';
c.Label.FontSize = titlefont;

% plot3(x, y, z,'-','linewidth',1.5);
xlabel('x[m]','interpreter','latex','fontsize',tickfont);
ylabel('y[m]','interpreter','latex','fontsize',tickfont);
zlabel('z[m]','interpreter','latex','fontsize',tickfont);
title('3D Trajectory (wind)','fontsize',titlefont);
legend("Trajectory","","","$V_w$","$V_a$",'interpreter','latex','fontsize',legendfont,'location','best')
axis equal;
zlim([80, 110]);
% view([0,-1,0]);
grid on; grid minor;

% figure();
colors = colormap(jet(length(t))); 
for i = 1:100:length(t)
  plot3(x_L_enu(i), y_L_enu(i), z_L_enu(i), '.','MarkerSize',5,"color",colors(i,:)); hold on;
end
c=colorbar('Ticks',linspace(0,1,11),'TickLabels',linspace(0,t(end),11));
c.Label.String = 'Time[s]';

% plot(x, y,'-','linewidth',1.5);
xlabel('x[m]','interpreter','latex','fontsize',12);
ylabel('y[m]','interpreter','latex','fontsize',12);
zlabel('z[m]','interpreter','latex','fontsize',12);
title('Position[ENU]');
legend("3D position(XYZ)",'interpreter','latex','fontsize',12,'location','best')
grid on; grid minor;
