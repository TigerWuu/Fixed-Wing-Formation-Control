#!/bin/bash

ros2 bag record -o $1 \
\
/px4_1/fmu/out/vehicle_local_position \
/px4_1/fmu/out/vehicle_attitude \
/px4_1/fmu/out/vehicle_status \
/px4_1/data/control_inputs \
/px4_1/data/formation_error \
/px4_1/wind_estimation_information \
\
/px4_2/fmu/out/vehicle_local_position \
/px4_2/fmu/out/vehicle_attitude \
/px4_2/fmu/out/vehicle_status \
/px4_2/data/control_inputs \
/px4_2/data/formation_error \
/px4_2/wind_estimation_information \
\
/px4_3/fmu/out/vehicle_local_position \
/px4_3/fmu/out/vehicle_attitude \
/px4_3/fmu/out/vehicle_status \
/px4_3/data/control_inputs \
/px4_3/data/formation_error \
/px4_3/wind_estimation_information \
\
/virtual_leader_information \





