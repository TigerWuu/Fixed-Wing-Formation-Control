close all;
addpath('./visualization');

% run("sim_visualization.m")
% run("FW_data_visualization.m")
% run("Formation_data_visualization.m")
% run("Formation_multi_wind_data_visualization.m")
% run("Wind_data_visualization.m")
% run("Trajectory_visualization.m")

%% ros-px4
addpath('./visualization/ros-px4');
% run("ROS_Formation_data_visualization.m")
run("PX4_fw_system_ID.m")

%% load wind
addpath('./visualization/load/wind');
% run("Load_L1_vs_L2_visualization.m");
% run("Load_initial_error_visualization.m");

%% Load formation
addpath('./visualization/load/formation');
% run("Load_LBFC_vs_visualization.m") % original vs modified
run("Load_LBFC_windno_vs_visualization.m") % different wind cases : no wind 
% run("Load_LBFC_circle_windno_vs_visualization.m") % different wind cases : no wind 
% run("Load_LBFC_wind_vs_visualization.m") % different wind cases

%% Read data from csv
addpath('./visualization/read');
% run("Read_straight.m") % different wind cases




