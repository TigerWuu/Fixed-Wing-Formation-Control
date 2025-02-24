# Fixed-wing formation control
The model-in-the-loop (MIL) simulation package for formation control, wind estimation, and compensation. 
## Follower System Block Diagram
The referenced fixed-wing UAV model is **Skywalk X8**, while the thesis assumes all the dynamics as a first-order system. The UAV dynamics can be toggled in _**Fixed Wing Model**_.
* **FW_formation_control_wind.slx**
![image](https://github.com/user-attachments/assets/9396d8f7-1155-4221-bef5-27362f36dfcb)

## Code Structure

```bash
├── csv
├── data
│   ├── formation
│   │   ├── wind
│   │   └── wind_no
│   └── observer
│       ├── init_error_0
│       ├── init_error_-10
│       └── init_error_10
├── result
├── ros
├   ├── rosbag
├   ├── px4_msgs
├   ├── self_msg
├── vehicles
├── visualization
│   ├── load
│   │   ├── formation
│   │   └── wind
│   ├── read
│   ├── ros-px4
│   └── slprj
│       └── sim
├── Fixed_Wing.slx
├── FW_control.slx
├── FW_control.slxc
├── FW_formation_control.slx
├── FW_formation_control.slxc
├── FW_formation_control_wind.slx
├── FW_formation_control_wind.slxc
├── main.m
├── Multi_FW_formation_control_wind.slx
├── Multi_FW_formation_control_wind.slxc
├── run_visualization.m
├── slblocks.m
├── test.slx
└── test.slxc


```
## Quick Start
1. Run `main.m`
2. Open `.slx` file according to your preference

    >  **.slx file lists** :
    > 
    > **FW_control.slx** : only fixed-wing UAV model.
    >  
    > **FW_formation_control.slx**: fixed-wing UAV with formation control algorithm.
    >
    > **FW_formation_control_wind.slx** : fixed-wing UAV with formation control and wind estimation algorithm.
    >
    > **Multi_FW_formation_control_wind.slx** : Three fixed-wing UAVs with formation control and wind estimation algorithm.
    >
3. After running the MIL simulation, you can visualize the data immediately through `./run_visualization.m`. The explanation of this file is as follows,
    ```
    addpath('./visualization');
    
    run("sim_visualization.m")  % generate the fixed-wing animation.
    run("FW_data_visualization.m") % visualize the single fixed-wing data
    run("Formation_data_visualization.m") % visualize the fixed-wing data with formation control
    run("Formation_multi_wind_data_visualization.m") % visualize the multiple fixed-wing data with formation control
    run("Wind_data_visualization.m") % visualize the wind and wind estimation data
    run("Trajectory_visualization.m") % visualize the fixed-wing and trajectory (single fixed-wing)
    ```
## Data Visualization
All the figures are generated through `./run_visualization.m`
### SMWO Performance Evaluation
1. Comparison of the Estimated Wind Velocity from Wind Velocity Observer
and Acceleration Observer
2. Observer Gain Influence on SMWO

    ```
    %% load wind
    addpath('./visualization/load/wind');
    run("Load_L1_vs_L2_visualization.m");
    % run("Load_initial_error_visualization.m");
    ```
3. Initial Formation Error Influence on SMWO

    ```
    %% load wind
    addpath('./visualization/load/wind');
    % run("Load_L1_vs_L2_visualization.m");
    run("Load_initial_error_visualization.m");
    ```
### LBFC-SMWO Performance Evaluation
1. Formation Flight in Straight Line Trajectory
    ```
    %% Load formation
    addpath('./visualization/load/formation');
    run("Load_LBFC_windno_vs_visualization.m") % different wind cases : no wind 
    run("Load_LBFC_wind_vs_visualization.m") % different wind cases, this file is gonna generate a csv file, about IAE and RMSE table, into `/.csv`
    ```

2. Formation Flight in Circular Orbit Trajectory
    ```
    %% Load formation
    addpath('./visualization/load/formation');
    run("Load_LBFC_circle_windno_vs_visualization.m") % different wind cases : no wind 
    run("Load_LBFC_circle_wind_vs_visualization.m") % different wind cases, this file is gonna generate a csv file, about IAE and RMSE table, into `/.csv`
    ```
3. IAE vs. RMSE 
    ```
    %% Read data from csv
    addpath('./visualization/read');
    run("Read_straight.m") % need to change this file manually to generate the same bar figure as the thesis, sorry...
    ```
### SITL Simulation
Before generating the SITL figures,
* you have to generate the **px4 message** and the **customized message** for matlab to read the bag files, please refer to the following link:
  * [ros2genmsg](https://www.mathworks.com/help/ros/ref/ros2genmsg.html)
* The **customized message** is _**self_msg**_, which is defined in [Formation-PX4](https://github.com/TigerWuu/Formation-PX4)
>[!NOTE]
>These figures can only be generated under the **OS** with **ROS2**

1. System Identification
    ```
    %% ros-px4
    addpath('./visualization/ros-px4');
    % run("ROS_Formation_data_visualization.m") $ for ICRA and progress report, only one UAV and one virtual leader
    % run("ROS_Formation_multi_data_visualization.m")
    run("PX4_fw_system_ID.m")
    ```
2. Three UAVs Formation Flight
    ```
    %% ros-px4
    addpath('./visualization/ros-px4');
    % run("ROS_Formation_data_visualization.m") $ for ICRA and progress report, only one UAV and one virtual leader
    run("ROS_Formation_multi_data_visualization.m")
    % run("PX4_fw_system_ID.m")
    ```
