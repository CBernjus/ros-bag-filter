#!/bin/bash

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
RESET="\033[0m"

can_overwrite_file() {
    local file="$1"

    if [ -f "$file" ]; then
        echo -e "${YELLOW}Warning: File $file already exists."
        echo -e -n "Do you want to overwrite it? [y/N]${RESET} "
        read -r choice
        case "$choice" in
            y|Y)
            rm "$file"
            ;;
            *)
            echo -e "${RED}Aborted.${RESET}"
            exit 0
            ;;
        esac
    fi
}

write_bag_info() {
    local bag_file="$1"
    local info_file="$2"

    echo -e "${GREEN}Writing info to file...${RESET}"
    can_overwrite_file "$info_file"
    touch "$info_file"

    if ! rosbag info "$bag_file" > "$info_file"; then
        echo -e "${RED}Error: Writing info to file failed.${RESET}"
        exit 1
    fi
}

# Check whether rosbag is installed
if ! command -v rosbag &> /dev/null; then
    echo -e "${RED}Error: rosbag could not be found.${RESET}"
    exit 1
fi

# Check if an argument is given
if [ "$#" -lt 2 ]; then
    echo -e "${RED}Error: No Bag-File provided.${RESET}"
    echo -e "Usage: $0 /path/to/rosbag.bag /topic1 /topic2 ..."
    exit 1
fi
ORIGINAL_BAG=$1
shift
TOPICS=("$@")

# Check whether the bag file exists
if [ ! -f "$ORIGINAL_BAG" ]; then
    echo -e "${RED}Error: File $ORIGINAL_BAG does not exist.${RESET}"
    exit 1
fi

BAG_NAME=$(basename "$ORIGINAL_BAG" .bag)
NEW_FOLDER=./${BAG_NAME}_filtered

# Create a new folder, if it does not already exist
if [ ! -d "$NEW_FOLDER" ]; then
    mkdir "$NEW_FOLDER"
fi

NEW_BAG_NAME=${BAG_NAME}_filtered
NEW_BAG=$NEW_FOLDER/${NEW_BAG_NAME}.bag
OLD_INFO_FILE=$NEW_FOLDER/${BAG_NAME}_info.txt
NEW_INFO_FILE=$NEW_FOLDER/${NEW_BAG_NAME}_info.txt

# Writing original bag info to file
echo -e "${GREEN}Original Bag Info:${RESET}"
rosbag info "$ORIGINAL_BAG"
write_bag_info "$ORIGINAL_BAG" "$OLD_INFO_FILE"

# Check whether the topics are available in the given bag
for topic in "${TOPICS[@]}"; do
  if ! grep -q "$topic" "$OLD_INFO_FILE"; then
      echo -e "${RED}Error: Topic $topic not found in the bag. ($ORIGINAL_BAG)${RESET}"
      exit 1
  fi
done

# Filter rosbag file
echo -e "${GREEN}Filtering bag file...${RESET}"
can_overwrite_file "$NEW_BAG"
if ! rosbag filter "$ORIGINAL_BAG" "$NEW_BAG" "topic in '${TOPICS[*]}'"; then
    echo -e "${RED}Error: Filtering failed.${RESET}"
    exit 1
fi

# Writing filtered bag info to file
echo -e "${GREEN}Filtered Bag Info:${RESET}"
rosbag info "$NEW_BAG"
write_bag_info "$NEW_BAG" "$NEW_INFO_FILE"

echo -e "${GREEN}Done."
echo -e "Filtered bag is $NEW_BAG."
echo -e "Original bag info is in $OLD_INFO_FILE"
echo -e "Filtered bag info is in $NEW_INFO_FILE.${RESET}"
exit 0
