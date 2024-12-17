#!/bin/bash

# Function to check if an email address is valid and routable
is_valid_email() {
    local email="$1"
    # Check for a simple regex pattern for valid email addresses
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Read the input file line by line
while IFS=',' read -r name email id; do
    # Trim whitespace from variables
    name=$(echo "$name" | xargs)
    email=$(echo "$email" | xargs)
    id=$(echo "$id" | xargs)

    # Check if ID is specified and is a number
    if [[ -n "$id" && "$id" =~ ^[0-9]+$ ]]; then
        # Determine if ID is odd or even
        if (( id % 2 == 0 )); then
            num="even"
        else
            num="odd"
        fi

        # Check if the email address is valid and routable
        if is_valid_email "$email"; then
            echo "The $id of $email is $num number."
        else
            echo "Warning: Invalid email address for user '$name'."
        fi
    else
        echo "Warning: Invalid parameters for user '$name'."
    fi

done < db.txt
