# Bag Filtering Script

This set of scripts help you filter ROS bag files based on custom topics.

1. For each bag a new folder in the current working directory will be created named `BAG_NAME_filtered`.
2. It saves the filtered data in a new bag file `BAG_NAME_filtered.bag` inside this folder.
3. It saves the result of `rosbag info` for both bags:
   - The original bag info will be saved in the file `BAG_NAME_info.txt`.
   - The filtered bag info will be saved in the file `BAG_NAME_filtered_info.txt`.
4. If any of the specified files already exist, the user will be prompted to confirm
whether to overwrite the file.

## Prerequisites

**ROS installation is required.** <br>
Make sure you have ROS installed on your system. For installation instructions,
refer to the ROS documentation: http://wiki.ros.org/ROS/Installation

## Preparation

Make sure the scripts you want to use are executable:
```bash
chmod +x extract.bash
```

## Predefined Topics

In the `extract.bash` script, you will find predefined topics.
You can use this script to perform the filtering operation with the predefined topics
by providing the bag file path as an argument:

```bash
./extract.sh /path/to/rosbag.bag
```

**Note:** You can modify the predefined `extract.bash` script to use your own topics.

---

## Usage

If you want to use your own topics you can either modify the predefined `extract.bash`
or run the `filter_bag.bash` script directly using the following command:

```bash
./filter_bag.bash /path/to/rosbag.bag topic1 topic2 ...
```
Replace `/path/to/rosbag.bag` with the path to the ROS bag file you want to filter.
Replace `topic1 topic2 ...` with the desired topics to extract.

**Example:**
```bash
./filter_bag.bash /path/to/rosbag.bag /image_raw /radar/points /radar/range
```

## Downloading a Sample Bag

To experiment with the script, you can use the `download_demo_bag.bash`
script to download a sample bag. <br>
Run the following command:

```bash
./download_demo_bag.sh
```

A sample bag will be downloaded and saved in the current directory (as `demo.bag`),
which can then be used with the bag filtering script.

---
Please note that this scripts only include a simple form of error handling and validation.
Make sure you have the necessary prerequisites installed and use the commands correctly.