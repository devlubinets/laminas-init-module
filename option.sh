if [ -z "$1" ]; then
  echo "Module name should be added "
  exit 1
fi

if echo "$1" | grep -q '^[[:lower:]].*$'; then
  echo "Module name should begin with an uppercase letter "
  exit 1
fi

if [ -z "$2" ]; then
  echo "Ticket name should be added "
  exit 1
fi

if [ -z "$3" ]; then
  echo "Description should be added "
  exit 1
fi

if [ -z "$4" ]; then
  echo "Git repository should be added "
  exit 1
fi

if [ -z "$5" ]; then
  echo "Project name should be added "
  exit 1
fi