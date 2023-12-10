#!/usr/bin/env bash

# Directory containing jails
JAIL_DIR="/usr/local/jails"

# Function to list jails
list_jails() {
    local index=1
    for jail in ${JAIL_DIR}/*; do
        echo "${index}. $(basename $jail)"
        index=$((index+1))
    done
    echo "${index}. Exit without snapshot"
    return $index
}

# Main script
main() {
    echo "Available jails:"
    list_jails
    local max_index=$?

    # Prompt for user input
    echo "Enter the number of the jail to snapshot (or ${max_index} to exit):"
    read selection

    # Check if selection is a number
    if ! [[ "$selection" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a number."
        exit 1
    fi

    # Validate input and handle exit option
    if [ "$selection" -eq "${max_index}" ]; then
        echo "Exiting without taking a snapshot."
        exit 0
    elif [ "$selection" -lt 1 ] || [ "$selection" -gt "${max_index}" ]; then
        echo "Invalid selection. Exiting."
        exit 1
    fi
    # Get the selected jail
    local selected_jail_path=$(ls -d ${JAIL_DIR}/* | sed -n "${selection}p")
    local jail_name=$(basename $selected_jail_path)

    # Map jail path to ZFS dataset
    local ZFS_DATASET="zroot/jails/${jail_name}"

    # Generate a timestamp
    local TIMESTAMP=$(date +%Y%m%d%H%M%S)

    # Create a snapshot with the timestamp
    zfs snapshot ${ZFS_DATASET}@${TIMESTAMP}

    # Optional: Echo a confirmation message
    echo "Snapshot of ${ZFS_DATASET} taken at ${TIMESTAMP}"
}

# Execute the main function
main

