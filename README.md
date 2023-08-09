# Init module


Init-module is script which init your laminas module fast and cleary without any left move.

### Example:

```shell
 ./init-module.sh Unleash-Pipe CRM-604 "Description ticket" git@bitbucket.org:dev.lubinets/orm-super.git "project-name"
```

Description:

* with - because it is laminas convention for module
* name of repo git without module suffix
* module name same to create repo for module
* project name is package name (**symfony**/something)


### Glosary 

* VCSP - version control system provider (git, bitbucet and ect)

## Prerequsites

Make that sctipt executable to execute that script:)

```shell
chmod u+x init-module.sh
```

For rename folders install **rename** command _it isn't exsist on Ubuntu by default_

```shell
sudo apt-get install -y rename
```


## Setup

### Phpstorm configuration

Need root right to create symbolic link create symbolik link to work with phpstorm-cli
```shell
ln -s "$(locate phpstorm.sh)" /usr/local/bin/phpstorm
```

### Default settings

* module directory: ~/PhpstormProjects 

### Enviroment 

Add next enviroment to your shell configuration variable to provide your special configuration

* Bash: ~/.bashrc or ~/.bash_profile
* Zsh: ~/.zshrc
* Fish: ~/.config/fish/config.fish


```shell
echo "export VCSP_REPO_BASE_MODULE=git@github.com:devlubinets/laminas-primary-module.git" >> ~/.zshrc
echo "export VCSP_DEV_WORKSPACE=devlubinets" >> ~/.zshrc
echo "export VCSP_PROVIDER=git@github.com" >> ~/.zshrc
echo "export ROOT_MODULE_PATH=/home/ad/PhpstormProjects/module-name" >> ~/.zshrc
```

## Dev section

### Error handle

```shell
./init-module.sh: /bin/sh^M: bad interpreter: No such file or directory
```

Descriptions: 

This error message usually occurs when a script was created on a Windows system and then transferred to a Unix-based system without properly converting the line endings.The "^M" character is a carriage return character that is used in Windows line endings. Unix-based systems use only the line feed character.To fix this error, you need to convert the line endings in the script from Windows-style (CRLF) to Unix-style (LF) using a text editor or a command-line utility such as dos2unix.

Solutions:
1. sudo apt install dos2unix &&  dos2unix init-module.sh 
2. sed -i -e 's/\r$//' init-module.sh


## Features:
* Add check to symbolic link
* Add check to installed PHPStorm
* Get path to module dir from Enviroment

