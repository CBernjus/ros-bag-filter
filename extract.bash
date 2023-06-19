#!/bin/bash

UNFILTERED_POINT_CLOUD="/sensors/lidar/velodyne/velodyne_points";
FILTERED_POINT_CLOUD="/sense/lidar/velodyne_filtered_points";
LIDAR_DETECTIONS="/sense/lidar/detections";
# DEBUG_BBOXES="/DEBUG_Lidar_Bounding_Boxes";

TOPICS="${UNFILTERED_POINT_CLOUD} ${FILTERED_POINT_CLOUD} ${LIDAR_DETECTIONS}"

# Check if an argument is given
if [ "$#" -ne 1 ]; then
    echo -e "${RED}Error: No Bag-File provided.${RESET}"
    echo -e "Usage: $0 /path/to/rosbag.bag"
    exit 1
fi

./filter_bag.bash "$1" "$TOPICS"