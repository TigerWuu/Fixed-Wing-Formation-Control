% uav_visualization 
close all;

t = out.tout;

attitude = get(out.logsout, 'attitude').Values.Data;
phi= attitude(:,1);
theta = attitude(:,2);
psi = attitude(:,3);
course = attitude(:,4);

position = get(out.logsout, 'position').Values.Data;
x = position(:,1);
y = position(:,2);
z = position(:,3);

x8_vis = uav_visualization('X8');

% x8_vis.update(phi(1), theta(1), psi(1), x(1), y(1), z(1), t(1));
% pause;
% x8_vis.update(phi(end), theta(end), psi(end), x(end), y(end), z(end), t(end));
% pause;
% x8_avi = VideoWriter('X8.avi');
% open(x8_avi);

for i = 1:10:length(t)
    x8_vis.update(phi(i), theta(i), psi(i), x(i), y(i), z(i), t(i));
    % x8_avi = x8_vis.record(x8_avi);
end

% close(x8_avi);