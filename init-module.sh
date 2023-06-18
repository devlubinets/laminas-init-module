#!/bin/sh

# todo: Add custom code to customize main work flow

version=0.4

. ./utils.sh
. ./help.sh
. ./env.sh
. ./option.sh

### Setup

# development flags
devFlag=1
gitFlagPull=1
gitFlagPush=1
optionalFlag=1

echo "Init new laminas module"
# Rename composer's files
projectName="$5"
nameSpace="$(echo $1 | sed 's/-\([a-z]\)/\U\1/g' | sed 's/-//g')"
nameSpaceTest="$nameSpace"
moduleName=$(echo "$1" | tr '[:upper:]' '[:lower:]')
moduleName="$moduleName"
varName=$(echo $nameSpace | awk '{print tolower(substr($0,1,1)) substr($0,2)}')
ticketDescription=$3
moduleDescription=$3
ticket=$2
repoNameSsh=$4
gitRepoBaseModule=$VCSP_REPO_BASE_MODULE
# Git
primaryCommit="Init $moduleName's commit"
moduleCommit="Init $moduleName's commit"


if [ "$devFlag" = 1 ]; then
  echo "projectName: $projectName"
  echo "nameSpace $nameSpace"
  echo "nameSpaceTest $nameSpaceTest"
  echo "moduleName $moduleName"
  echo "varName $varName"
  echo "ticket $ticket"
  echo "ticketDescription $ticketDescription"
  echo "moduleDescription $moduleDescription"
  echo "repoNameSsh $repoNameSsh"
  echo "gitRepoBaseModule $gitRepoBaseModule"
  echo "gitFlagPull $gitFlagPull"
  echo "gitFlagPush $gitFlagPush"
  echo "optionalFlag $optionalFlag"

  echo "ENVIROMENT VARIABLE \n"
  echo "VCSP_REPO_BASE_MODULE $VCSP_REPO_BASE_MODULE"
  echo "VCSP_DEV_WORKSPACE $VCSP_DEV_WORKSPACE"
  echo "VCSP_PROVIDER $VCSP_PROVIDER"
  echo "ROOT_MODULE_PATH $ROOT_MODULE_PATH"

  echo "\n"
  sleep 5
fi

# Step 1: get base module
if [ "$gitFlagPull" = 1 ]; then
  # Get base module
  git clone "$VCSP_REPO_BASE_MODULE" "$ROOT_MODULE_PATH/$moduleName"
  cd "$ROOT_MODULE_PATH/$moduleName"
  # Create new branch to push like init branch to primary's repo
  git commit -am "$primaryCommit"
  git checkout -b "$moduleName"
else
  echo "You avoid the step of getting code from the remote repo"
  cd "$ROOT_MODULE_PATH/$moduleName"
  sleep 1
fi

# Step 2: update clone base module
# Rename composer's files
sed -i "s/project-name/$projectName/" ./composer.json
sed -i "s/primary/$moduleName/" ./composer.json
sed -i "s/Primary/$nameSpace/" ./composer.json
# Rename README.md
sed -i "s/MODULE_REPO/$moduleName/" ./README.md
sed -i "s/MODULE_NAME/$nameSpace/" ./README.md
sed -i "s/PURPOSE_DESCRIPTION/$nameSpace/" ./README.md
sed -i "s/REPO_NAME_SSH/$repoNameSsh/" ./README.md
sed -i "s/PROJECT_NAME/$projectName/" ./README.md
sed -i "s/MODULE_PACKAGE_NAME/$moduleName/" ./README.md

# Change files' name and content in src
# Content
find "./config" -type f -exec sed -i "s/primary-module/$moduleName-module/g" {} + #change literal module name
find "./config" -type f -exec sed -i "s/primary/$varName/g" {} +
find "./config" -type f -exec sed -i "s/Primary/$nameSpace/g" {} +
find "./config" -type f -exec sed -i "s/\\Primary/\\$nameSpace/g" {} +

find "./src" -type f -exec sed -i "s/primary-module/$moduleName-module/g" {} + #change literal module name
find "./src" -type f -exec sed -i "s/primary/$varName/g" {} +
find "./src" -type f -exec sed -i "s/Primary/$nameSpace/g" {} +
find "./src" -type f -exec sed -i "s/\\Primary/\\$nameSpace/g" {} +
# Name
find "./src" -type f -name "*.php" -execdir rename "s/Primary/$nameSpace/" "{}" \;

# Change files' name and content in test
find "./test" -type f -exec sed -i "s/primary-module/$moduleName-module/g" {} + #change literal module name
find "./test" -type f -exec sed -i "s/primary/$varName/g" "{}" +
find "./test" -type f -exec sed -i "s/Primary/$nameSpace/g" "{}" +
find "./test" -type f -exec sed -i "s/\\Primary/\\$nameSpace/g" {} +
# Name
find "./test" -type f -name "*.php" -execdir rename "s/Primary/$nameSpaceTest/g" "{}" \;
# Change view's folder name
mv "./view/primary-module" "./view/${moduleName}-module"
mv "./view/${moduleName}-module/primary" "./view/${moduleName}-module/$moduleName"

### Add ticket to CHANGELOG.md
sed -i "/^\#\#\ \[Unreleased\]/a \\\n- $ticket: $ticketDescription" CHANGELOG.md

# Step 3: Run scripts
### Finish
echo "Run composer's scripts"
if [ "$optionalFlag" = 1 ]; then
  # Run composer's scripts
  composer install
  composer dump-autoload
  composer test
  composer csfix
  composer cs
  composer stan
  composer cover
else
  echo "Avoid composer section"
  sleep 1
fi

# Step 4: VCS section
if [ "$gitFlagPush" = 1 ]; then
  # Push initial renamed module back to alpha parent module
  git commit -am "$primaryCommit" && git push --set-upstream origin $moduleName
  # Delete the original .git directory
  rm -rf "./.git"

  # Init git directory for new module repo
  git init
  # Init gitflow
  git flow init -d

  # Add origin to the module repo
  git remote add origin "$repoNameSsh"

  # Start feature
  featureName="$ticket/init-module"
  echo "Start a new feature"
  git flow feature start "$featureName"
  # Git push
  git add .
  git commit -m "$moduleCommit"
  git push -u origin "feature/$featureName"
  echo "Finished! Module $nameSpace has been initialized."
else
  echo "Do you have trouble with the repo"
fi

echo "Finished! Module $nameSpace has been initialized."

if [ "$optionalFlag" = 1 ]; then
  # Create and open PHPStorm project
  echo "Create and open PHPStorm project"
  # Indexing and open the project like a daemon
  nohup phpstorm . >/dev/null 2>&1 &
# Finish
fi