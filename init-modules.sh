#!/bin/bash

. ./style.sh

branches=(
    placeholder-sample-joki-form-module
    placeholder-sample-joki-module
    placeholder-sample-joki-rest-module
    placeholder-sample-form-module
    placeholder-sample-boom-form-module
    placeholder-sample-boom-module
    placeholder-sample-boom-rest-module
    placeholders-sample-module
    placeholders-sample-rest-module
);

first_letter_to_uppercase() {
    local input="$1"
    local first_char="$(echo "$input" | cut -c1 | tr '[:lower:]' '[:upper:]')"
    local rest_of_string="$(echo "$input" | cut -c2-)"
    echo "$first_char$rest_of_string"
}

echo "${Green}Start create new modules${Default}"
for branch in "${branches[@]}"; do
    # Convert the branch name to uppercase first letter
    formatted_branch=$(first_letter_to_uppercase "$branch")

    # Use the formatted branch name in your script
    echo "${Yellow}Create new one module: $formatted_branch${Default}"
    source init-module.sh "$formatted_branch" CRM-999 "Init ticket"
    cd -
done
echo "${Green}Finished created new modules${Default}"