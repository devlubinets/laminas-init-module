#!/bin/bash

devEnvFlag=0;

checkEnv() {
  if [ "$devEnvFlag" = 1 ]; then
    echo "Environment variable name: $1"
    echo "Error description: $2"
    echo "Fix command or advice: $3"
  fi

  if [ -z "$1" ]; then
    echo "$2"
    echo "For example:"
    echo "$3"
    exit 1;
  fi
}

checkEnv "$VCSP_REPO_BASE_MODULE" \
          "VCSP_REPO_BASE_MODULE doesn't exist. Please add it to your environment" \
          "export VCSP_REPO_BASE_MODULE=git@github.com:devlubinets/laminas-primary-module.git >> ~/.zshrc"

checkEnv "$VCSP_DEV_WORKSPACE" \
          "VCSP_DEV_WORKSPACE doesn't exist. Please add it to your environment" \
          "export VCSP_DEV_WORKSPACE=devlubinets >> ~/.zshrc"

checkEnv "$VCSP_PROVIDER" \
          "VCSP_PROVIDER doesn't exist. Please add it to your environment" \
          "export VCSP_PROVIDER=git@github.com >> ~/.zshrc"

checkEnv "$ROOT_MODULE_PATH" \
          "$ROOT_MODULE_PATH doesn't exist. Please add it to your environment" \
          "export ROOT_MODULE_PATH=/home/ad/PhpstormProjects/module-name >> ~/.zshrc"
