#!/bin/bash

. ./style.sh

## AVOID MODULE prefix in name of module
branches=(
    lender-retail-duologi-form
    lender-retail-duologi
    lender-retail-duologi-rest
    lender-retail-form
    lender-retail-humm-form
    lender-retail-humm
    lender-retail-humm-rest
    lenders-retail
    lenders-retail-rest
);

first_letter_to_uppercase() {
    local input="$1"
    local first_char="$(echo "$input" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    local rest_of_string="$(echo "$input" | cut -c2-)"
    echo "$first_char$rest_of_string"
}

echo -e "${Green}Start create new modules${Default}"
for branch in "${branches[@]}"; do
    # Convert the branch name to uppercase first letter
    formatted_branch=$(first_letter_to_uppercase "$branch")

    # Use the formatted branch name in your script
    echo -e "${Yellow}Create new one module: $formatted_branch${Default}"
    source init-module.sh "$formatted_branch" CRM-999 "Init commit"
    cd -
done
echo -e "${Green}Finished created new modules${Default}"