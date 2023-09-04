#!/bin/bash

# todo: Add custom code to customize main work flow

version=0.4.1

. ./utils.sh
. ./help.sh
. ./env.sh
. ./option.sh

### todo: move to another file style.sh
Default='\033[0m'         # Text Reset
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White


### Setup

# development flags
devFlag=1
gitFlagPull=1
gitFlagPush=0
optionalFlag=0
gitFlagPushToParentModuleTemplate=1

# Rename composer's files
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

# Template settings
# @todo: move to env or cli options
key="alpha"
Key="Alpha"
#templateProjectName="project-name" # now doesn't used
projectName="iss-module"

echo -e "${Yellow}Init new laminas module: $moduleName ${Default}"

#@todo: move to dev-features.sh to make main script more readable
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
  echo -e "${Yellow}Step 1: get base module. Clone base module to local file system${Default}";
  git clone "$VCSP_REPO_BASE_MODULE" "$ROOT_MODULE_PATH/$moduleName"
  echo -e "${Blue}Move to local module directory${Default}";
  cd "$ROOT_MODULE_PATH/$moduleName"
  git checkout alpha ##todo: setup default branch

  # Create new branch to push like init branch to template's repo
  echo -e "${Blue}Create new branch to push like init branch to template's repo${Default}"
  git checkout -b "$moduleName"

  # Step 2: update clone base module
  echo -e "${Yellow}Step 2: update clone base module${Default}"
  # Rename composer's files
  # sed -i "s/$templateProjectName/$projectName/" ./composer.json # change name for project (deprecated), maybe in future
  sed -i "s/$key/$moduleName/" ./composer.json # change name of package
  sed -i "s/$Key/$nameSpace/" ./composer.json # change any OOP class name
  # Rename README.md
  sed -i "s/{MODULE_NAME}/$nameSpace/" ./README.md
  sed -i "s/{PURPOSE_DESCRIPTION}/$nameSpace/" ./README.md
  sed -i "s/{MODULE_REPO}/$moduleName/" ./README.md

  sed -i "s/REPO_NAME_SSH/$repoNameSsh/" ./README.md # git link to modules remote repo
  sed -i "s/PROJECT_NAME/$projectName/" ./README.md # name for current module package
  sed -i "s/MODULE_PACKAGE_NAME/$moduleName/" ./README.md
  sed -i "s/$key/$moduleName/" ./README.md
  sed -i "s/$Key/$nameSpace/" ./README.md

  # Change files' name and content in src
  # Content
  find "./config" -type f -exec sed -i "s/$key-module/$moduleName-module/g" {} + #change literal module name (in view manager)
  find "./config" -type f -exec sed -i "s/$Key/$nameSpace/g" {} +
  find "./config" -type f -exec sed -i "s/\\$Key/\\$nameSpace/g" {} +

  find "./src" -type f -exec sed -i "s/$key-module/$moduleName-module/g" {} + #change literal module name
  find "./src" -type f -exec sed -i "s/$key/$varName/g" {} +
  find "./src" -type f -exec sed -i "s/$Key/$nameSpace/g" {} +
  find "./src" -type f -exec sed -i "s/\\$Key/\\$nameSpace/g" {} +
  # Name
  find "./src" -type f -name "*.php" -execdir rename "s/$Key/$nameSpace/" "{}" \;

  # Change files' name and content in test
  find "./test" -type f -exec sed -i "s/$key-module/$moduleName-module/g" {} + #change literal module name
  find "./test" -type f -exec sed -i "s/$key/$varName/g" "{}" +
  find "./test" -type f -exec sed -i "s/$Key/$nameSpace/g" "{}" +
  find "./test" -type f -exec sed -i "s/\\$Key/\\$nameSpace/g" {} +
  # Name
  find "./test" -type f -name "*.php" -execdir rename "s/$Key/$nameSpaceTest/g" "{}" \;
  # Change view's folder name
  mv "./view/$key-module" "./view/${moduleName}-module"
  mv "./view/${moduleName}-module/$key" "./view/${moduleName}-module/$moduleName"

  ### Add ticket to CHANGELOG.md
  sed -i "/^\#\#\ \[Unreleased\]/a \\\n- $ticket: $ticketDescription" CHANGELOG.md

  # Step 3: Run scripts
  ### Finish
  echo -e "${Yellow}Run composer's scripts${Default}"
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
    echo -e "${Red}Avoid composer section${Default}"
    sleep 1
  fi

  # Create new branch to push like init branch to primary's repo
  #git commit -am "$primaryCommit"
  #git checkout -b "$moduleName"
else
  echo -e "${Red}You avoid the step of getting code from the remote repo${Default}"
  cd "$ROOT_MODULE_PATH/$moduleName"
  sleep 1
fi

echo -e "${Yellow}Step 4.1: VCS section (send commit to remote parent module template remote origin)${Default}"
if [ "$gitFlagPushToParentModuleTemplate" = 1 ]; then
    # Push initial renamed module back to parent module template parent module
    git commit -am "$primaryCommit" && git push --set-upstream origin $moduleName
fi

echo -e "${Yellow}Step 4.2: VCS section (remove current .git and reinit git repo and push code to module repo)${Default}"
if [ "$gitFlagPush" = 1 ]; then
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
  echo -e "${Blue}Start a new feature${Default}"
  git flow feature start "$featureName"
  # Git push
  git add .
  git commit -m "$moduleCommit"
  git push -u origin "feature/$featureName"
  echo -e "${Green}Finished! Module $nameSpace has been initialized${Default}"
else
  echo "${Red}Do you have trouble with the repo${Default}"
fi

 echo -e "${Cyan}Optionals work with module $nameSpace${Default}"
if [ "$optionalFlag" = 1 ]; then
  # Create and open PHPStorm project
  echo "${Yellow}Create and open PHPStorm project${Default}"
  # Indexing and open the project like a daemon
  nohup phpstorm . >/dev/null 2>&1 &
# Finish
fi
