% uav_visualization 
close all;
%% import data
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
x_L = position_L(:,1);
y_L = position_L(:,2);
z_L = position_L(:,3);

courseLFc = get(out.logsout, 'courseLF').Values.Data;
course_L = courseLFc(:,1);
course_Fc = courseLFc(:,2);

VFc = get(out.logsout, 'VFc').Values.Data;
V_Fc = VFc(:,1);

G_error = get(out.logsout, 'G_error').Values.Data;
lateral_err = squeeze(G_error(1,1,:));
forward_err = squeeze(G_error(2,1,:));
vertical_err = squeeze(G_error(3,1,:));


position_L_enu = position_L*transpose(T.R_NED_ENU);
x_L_enu = position_L_enu(:,1);
y_L_enu = position_L_enu(:,2);
z_L_enu = position_L_enu(:,3);

winds = get(out.logsout, 'wind').Values.Data;
winds_enu = winds*transpose(T.R_NED_ENU); % (R*P)^T = P^T*R^T
w_e = winds_enu(:,1);
w_n = winds_enu(:,2);
w_u = winds_enu(:,3);

Va = get(out.logsout, 'Va').Values.Data;
%% plot style
titlefont = 20;
tickfont = 18;
legendfont = 14;
%% caculate distance IAE, RMSE. steady-state
% IAE, RMSE
IAE = 0;
RMSE = 0;
num = 0;
for i = 1:length(t)
    if t(i) > 20
        IAE = IAE+sqrt(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
        RMSE = RMSE+lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2;
        num = num +1;
    end
end
RMSE = sqrt(RMSE/num);
display(["IAE = ", num2str(IAE)]);
display(["RMSE = ", num2str(RMSE)]);

% lyapunov candidate
V = zeros(length(t),1);
de = zeros(length(t),1);
for i = 1:length(t)
    V(i) = 1/2*(lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2);
    de(i) = (lateral_err(i)^2+forward_err(i)^2+vertical_err(i)^2)^0.5;
end

% reaching time and V upper bounding
V0 = 1/2*(lateral_err(1)^2+forward_err(1)^2+vertical_err(1)^2);
alpha_r = 0.5;
c = min([c1,c2,c3]);
lambda = 2*c;
q = alpha_r^(alpha_r/(1-alpha_r))-alpha_r^(1/(1-alpha_r));
eta = 2*c*q;

e = 0:0.01:1;
V_r = zeros(length(e),1);
d_r = zeros(length(e),1);
t_r = zeros(length(e),1);
for i=1:length(e)
    V_r(i) = (eta/((1-e(i))*lambda))^(1/alpha_r); % cal upper bounding of V instead of V^alpha 
    d_r(i) = sqrt((eta/((1-e(i))*lambda))^(1/alpha_r)*2);
    t_r(i) = 1/(e(i)*lambda*(1-alpha_r))*(V0^(1-alpha_r)-((eta/((1-e(i))*lambda)))^((1-alpha_r)/alpha_r));
end

% plot
figure();
yyaxis left
plot(e,t_r,'-','linewidth',1.5);
ylabel('Reach time[s]','interpreter','latex','fontsize',tickfont);

yyaxis right
plot(e,V_r,'-','linewidth',1.5); hold on;
ylabel('Upper bounding of $V$','interpreter','latex','fontsize',tickfont);

xlabel('$\epsilon$','interpreter','latex','fontsize',tickfont);
title('$T_r$ vs. upper bounding of V','interpreter','latex','fontsize',titlefont);
legend("$T_r$","upper bounding of $V$",'interpreter','latex','fontsize',legendfont,'location','best')

figure();
plot(t_r,V_r,'-','linewidth',1.5);hold on;
plot(t, V,'-','linewidth',1.5);
xlabel('Time[s]','interpreter','latex','fontsize',tickfont);
ylabel('Lyapunov candidate $V$','interpreter','latex','fontsize',tickfont);
title('Lyapunov candidate bounding time','interpreter','latex','fontsize',titlefont);
legend("upper bounding of $V$","$V$",'interpreter','latex','fontsize',legendfont,'location','best')

figure();
plot(t_r, d_r,'-','linewidth',1.5);hold on;
plot(t, de,'-','linewidth',1.5);
xlabel('Time[s]','interpreter','latex','fontsize',tickfont);
ylabel('Distance error[m]','interpreter','latex','fontsize',tickfont);
title('Distance error bounding time','interpreter','latex','fontsize',titlefont);
legend("Upper bounding of $d_e$", "$d_e$",'interpreter','latex','fontsize',legendfont,'location','best')
%%

figure();
plot(t, V_Fc,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Velocity[m/s]','interpreter','latex','fontsize',tickfont);
title('Airspeed command[$V_F^c$]','interpreter','latex','fontsize',titlefont);

legend("$V_F^c$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

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
plot(t, course_L_deg, t, course_Fc_deg, t, course_deg,'-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Angle[deg]','interpreter','latex','fontsize',tickfont);
title('Course comparison', 'fontsize',titlefont);
legend("$\chi_L$","$\chi_{Fc}$","$\chi_{F}$",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

figure();
plot(t, lateral_err, t, forward_err, '-','linewidth',1.5); hold on;
plot(t, vertical_err, '-','linewidth',1.5); hold on;
xlabel('Times[s]','interpreter','latex','fontsize',tickfont);
ylabel('Distance[m]','interpreter','latex','fontsize',tickfont);
% title('Formation error', 'fontsize',titlefont);
legend("lateral error","forward error","vertical error",'interpreter','latex','fontsize',legendfont,'location','best')
grid on; grid minor;

