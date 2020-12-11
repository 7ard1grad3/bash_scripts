#!/bin/bash
# Bash Menu Script Example
ssh_dir="$HOME/.ssh/id_rsa"
proj_dir="$HOME/projects"
compose_version="1.27.4"
toolbox="jetbrains-toolbox-1.18.7609"

PS3='Fill action: '
options=(\
"Download repositories" \
"Add repository to repositories.txt" \
"Generate SSH key" \
"Copy SSH key" \
"Install docker" \
"Install toolbox" \
"Add script to alias" \
"Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Download repositories")
            if [ -f "$HOME/repositories.txt" ]
            then
            grep -v '^ *#' < "$HOME/repositories.txt" | while IFS= read -r line
            do
              rep_name=$(echo "${line##*"/"}" | sed -e "s/.git$//")
              if [ -d "$proj_dir/$rep_name" ]
              then
              echo "$proj_dir/$rep_name rep exist"
              else
              git clone "$line" "$proj_dir/$rep_name"
              if [ -f "$proj_dir/$rep_name/.env.example" ] && [ ! -f "$proj_dir/$rep_name/.env" ]
              then
              echo "copy .env file from .env.example"
              cp "$proj_dir/$rep_name/.env.example" "$proj_dir/$rep_name/.env"
              fi
              fi
            done
            else
            echo "Need to add $HOME/repositories.txt file with list of repositories"
            fi
            ;;
        "Add repository to repositories.txt")
            echo "Fill repository url: (ex:git@bitbucket.org:unilog/logivice_v2.git)"
            read -r repository
            if ! grep -Fxq "$repository" "$HOME/repositories.txt"
            then
              echo "$repository added"
              echo "$repository" >> "$HOME/repositories.txt"
            else
              echo "repository $repository exists"
            fi
            ;;
        "Generate SSH key")
            if [ -f "$ssh_dir" ]
            then
            echo "SSH key exist"
            else
            echo "Fill email address"
            read -r email
            ssh-keygen -t rsa -b 4096 -C "$email"
            echo "Directory created"
            fi
            ;;
        "Copy SSH key")
            if [ -f "$ssh_dir" ]
            then
            echo "Copy following:"
            cat "$ssh_dir.pub"
            else
            echo "Missing SSH key"
            fi
            ;;
        "Install docker")
            echo "Will try to install docker and docker compose"
            sudo apt update
            sudo apt upgrade
            sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
            sudo apt install curl
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg
            sudo apt-key add "–"
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
            sudo apt update
            sudo apt-get install docker-ce
            sudo systemctl start docker
            sudo systemctl enable docker
            sudo groupadd docker
            sudo usermod -aG docker "$USER"
            su - "$USER"
            sudo curl -L "https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            ;;
        "Install toolbox")
            echo "Will try to install toolbox"
            curl "https://download-cf.jetbrains.com/toolbox/$toolbox.tar.gz" | tar xvz
            ./$toolbox/jetbrains-toolbox
            rm -rd $toolbox
            ;;
        "Add script to alias")
            alias="alias tool='bash $PWD/script.sh'" >> "$HOME/.bash_aliases"
            if ! grep -Fxq "$alias" "$HOME/.bash_aliases"
            then
              echo "alias tool added to ~/.bash_aliases"
              echo "$alias" >> "$HOME/.bash_aliases"
              source "$HOME/.bashrc"
            fi
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
