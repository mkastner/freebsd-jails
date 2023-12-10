#!/usr/bin/env bash

# Define the base directory of the jails
JAIL_DIR="/usr/local/jails"

# Function to list snapshots for a given jail dataset
list_snapshots() {
    local jail_dataset=$1
    echo "Snapshots for jail '${jail_dataset}':"
    zfs list -t snapshot -o name -s creation | grep "^${jail_dataset}@" || echo "No snapshots found for ${jail_dataset}"
}

# Main script execution
main() {
    for jail in ${JAIL_DIR}/*; do
        if [ -d "$jail" ]; then
            jail_name=$(basename "$jail")
            jail_dataset="zroot/jails/${jail_name}" # Replace with actual ZFS dataset path pattern
            list_snapshots "${jail_dataset}"
        fi
    done
}

# Execute the main function
main
