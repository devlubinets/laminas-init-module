#!/bin/bash

toCamelCase() {
  # Convert string to lowercase and replace all non-primarynumeric characters with spaces
  local s="${1,,}"
  s="$(echo "$s" | sed 's/[^[:alnum:]]/ /g')"
  # Split string into words and capitalize the first letter of each word
  s="$(echo "$s" | sed -r 's/(^| )([a-z])/\1\u\2/g')"
  # Remove spaces from string
  echo "$s" | sed 's/ //g'
}

getVersion() {
  echo "ver. $version";
}
