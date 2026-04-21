#!/bin/bash

# Check if COPPELIASIM_ROOT_DIR is set
if [ -z "$COPPELIASIM_ROOT_DIR" ]; then
    echo "Error: COPPELIASIM_ROOT_DIR environment variable is not set"
    exit 1
fi

# Define the interface file path
INTERFACES_FILE="$COPPELIASIM_ROOT_DIR/programming/ros2_packages/sim_ros2_interface/meta/interfaces.txt"

echo "Adding message types to $INTERFACES_FILE"

cat >> "$INTERFACES_FILE" << EOF
std_msgs/msg/MultiArrayLayout
std_msgs/msg/MultiArrayDimension
std_msgs/msg/Float32MultiArray
std_msgs/msg/Float64MultiArray
geometry_msgs/msg/PoseStamped
geometry_msgs/msg/TwistStamped
sensor_msgs/msg/JointState
EOF

# Build the ROS2 packages
cd "$COPPELIASIM_ROOT_DIR/programming/ros2_packages" || exit 1
source /opt/ros/jazzy/setup.bash
colcon build
