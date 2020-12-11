A set of scripts that I'm usually using
## Setup
* Need to place repositories.txt file with a list of repositories in ~/repositories.txt
## Options
* Add a repository to repositories.txt - Add a new repository to your list
* Download repositories - Download your repositories from ~/repositories.txt file
* Go to repository folder in project directory
* Add SSH host - Will add ssh server to ~/ssh_hosts.txt
* Connect to SSH host - Pick and connect to stored server
* Generate SSH key - Will generate ssh key in ~/.ssh if missing
* Copy SSH key - Will show public ssh key
* Install docker - Will install docker and docker compose
* Install toolbox - Will install Jetbrains toolbox
* Add script to alias - Add alias to ~/.bash_aliases. Script will be available from everywhere by typing `tool`


### Variables
* proj_dir: place where repositories will be installed
* compose_version: version of docker compose to be installed
* toolbox: name of Jetbrains toolbox release file