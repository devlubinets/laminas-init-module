#!/bin/bash

branches=(
    lender-retail-duologi-form-module
    lender-retail-duologi-module
    lender-retail-duologi-rest-module
    lender-retail-form-module
    lender-retail-humm-form-module
    lender-retail-humm-module
    lender-retail-humm-rest-module
    lenders-retail-module
    lenders-retail-rest-module
);

first_letter_to_uppercase() {
    local input="$1"
    local first_char="$(echo "$input" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    local rest_of_string="$(echo "$input" | cut -c2-)"
    echo "$first_char$rest_of_string"
}

# Iterate through the branch names and convert them
for branch in "${branches[@]}"; do
    # Convert the branch name to uppercase first letter
    formatted_branch=$(first_letter_to_uppercase "$branch")

    # Use the formatted branch name in your script
    echo "Formatted branch: $formatted_branch"
    source init-module.sh "$formatted_branch" CRM-999 "Description ticket"
done