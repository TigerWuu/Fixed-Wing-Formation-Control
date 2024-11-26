% read csv
close all;
clear;
clc;


%% load data
data = readmatrix("./csv/wind_straight_name_mod.xlsx");
case_title = load("./csv/straight_case_name.mat");
data = data(:,2:17);
RMSE = data(2,:);
IAE = data(1,:);

%% save data setting
save_type = "eps";
save_path = "./result/formation/straight/analysis/";

%% plot style
titlefont = 20;
tickfont = 16;
legendfont = 12;
%% com vs no com
case_name = "com_com";
% RMSE
figure('Name',case_name);
RMSE_com = [];
RMSE_nocom = [];
for i = 1:length(RMSE)
    if mod(i,2)==0
        RMSE_nocom = cat(2,RMSE_nocom,RMSE(i)); 
    else
        RMSE_com = cat(2,RMSE_com, RMSE(i));
    end
end
RMSE_com_com = reshape(cat(2,RMSE_com,RMSE_nocom),[8,2]);
com_title = {'D+135M2Pc','D+135M8Pc','D+135M2Ps','D+135M8Ps','D-135M2Pc','D-135M8Pc','D-135M2Ps','D-135M8Ps'};
X = categorical(com_title);
X = reordercats(X,com_title);

bar(X,RMSE_com_com);
ylabel('RMSE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Compensation: v","Compensation: x",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"RMSE_"+case_name, save_type)

% IAE
figure('Name',case_name);
IAE_com = [];
IAE_nocom = [];
for i = 1:length(RMSE)
    if mod(i,2)==0
        IAE_nocom = cat(2,IAE_nocom,IAE(i)); 
    else
        IAE_com = cat(2,IAE_com, IAE(i));
    end
end
IAE_com_com = reshape(cat(2,IAE_com,IAE_nocom),[8,2]);
bar(X,IAE_com_com);

ylabel('IAE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Compensation: v","Compensation: x",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"IAE_"+case_name, save_type)

%% property: c vs s
case_name = "property_com";
% RMSE
figure('Name',case_name);
RMSE_c = cat(2, RMSE(1:4),RMSE(9:12));
RMSE_s= cat(2, RMSE(5:8),RMSE(13:16));
RMSE_prop_com = cat(2,RMSE_c, RMSE_s);

RMSE_prop_com = reshape(RMSE_prop_com,[8,2]);
prop_title = {'D+135M2Cv','D+135M2Cx','D+135M8Cv','D+135M8Cx','D-135M2Cv','D-135M2Cx','D-135M8Cv','D-135M8Cx'};
X = categorical(prop_title);
X = reordercats(X,prop_title);

bar(X,RMSE_prop_com);
ylabel('RMSE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Property: c","Property: s",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"RMSE_"+case_name, save_type)

% IAE
figure('Name',case_name);
IAE_c = cat(2, IAE(1:4),IAE(9:12));
IAE_s= cat(2, IAE(5:8),IAE(13:16));
IAE_prop_com = cat(2,IAE_c, IAE_s);

IAE_prop_com = reshape(IAE_prop_com,[8,2]);
bar(X,IAE_prop_com);

ylabel('IAE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Property: c","Property: s",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"IAE_"+case_name, save_type)
%% magnitude: 2 vs 8
% RMSE
case_name = "magnitude_com";
figure('Name',case_name);
RMSE_2 = cat(2, RMSE(1:2),RMSE(5:6), RMSE(9:10),RMSE(13:14));
RMSE_8= cat(2, RMSE(3:4),RMSE(7:8), RMSE(11:12),RMSE(15:16));
RMSE_mag_com = cat(2,RMSE_2, RMSE_8);

RMSE_mag_com = reshape(RMSE_mag_com,[8,2]);
mag_title = {'D+135PcCv','D+135PcCx','D+135PsCv','D+135PsCx','D-135PcCv','D-135PcCx','D-135PsCv','D-135PsCx'};
X = categorical(mag_title);
X = reordercats(X,mag_title);

bar(X,RMSE_mag_com);
ylabel('RMSE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Magnitude: 2","Magnitude: 8",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"RMSE_"+case_name, save_type)

% IAE
figure('Name',case_name);
IAE_2 = cat(2, IAE(1:2),IAE(5:6), IAE(9:10),IAE(13:14));
IAE_8= cat(2, IAE(3:4),IAE(7:8), IAE(11:12),IAE(15:16));
IAE_mag_com = cat(2,IAE_2, IAE_8);

IAE_mag_com = reshape(IAE_mag_com,[8,2]);
bar(X,IAE_mag_com);

ylabel('IAE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Magnitude: 2","Magnitude: 8",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"IAE_"+case_name, save_type)
%% direction: 135 vs -135 
% RMSE
case_name = "direction_com";
figure('Name',case_name);

RMSE_dir_com = reshape(RMSE,[8,2]);
dir_title = {'M2PcCv','M2PcCx','M8PcCv','M8PcCx','M2PsCv','M2PsCx','M8PsCv','M8PsCx'};
X = categorical(dir_title);
X = reordercats(X,dir_title);

bar(X,RMSE_dir_com);
ylabel('RMSE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Direction: +135","Direction: -135",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"RMSE_"+case_name, save_type)
% IAE
figure('Name',case_name);

IAE_dir_com = reshape(IAE,[8,2]);
bar(X,IAE_dir_com);

ylabel('IAE[m]','interpreter','latex','fontsize',tickfont);
xlabel('Cases','interpreter','latex','fontsize',tickfont);            
legend("Direction: +135","Direction: -135",'interpreter','latex','fontsize',legendfont,'location','northwest')
grid on; 
saveas(gcf, save_path+"IAE_"+case_name, save_type)

