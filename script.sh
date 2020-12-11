#!/bin/bash
# Bash Menu Script Example
ssh_dir="$HOME/.ssh/id_rsa"
proj_dir="$HOME/projects"
compose_version="1.27.4"
toolbox="jetbrains-toolbox-1.18.7609"


options=(\
"Add a repository to repositories.txt" \
"Download repositories" \
"go to repository folder" \
"Add SSH host" \
"Connect to SSH host" \
"Generate SSH key" \
"Copy SSH key" \
"Install docker" \
"Install toolbox" \
"Add script to alias" \
"Quit")
PS3="#:"
select opt in "${options[@]}"
do
    case $opt in
        "Add a repository to repositories.txt")
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
            echo "Missing repositories in $HOME/repositories.txt file"
            fi
            ;;
        "go to repository folder")
            select d in $proj_dir/*/;
            do cd "$d" && $SHELL;
            echo ">>> Invalid Selection";
            done
            ;;
        "Add SSH host")
            echo "Fill host name (without spaces):"
            read -r host_name
            echo "Fill IP address with user ex. root@127.0.0.1:"
            read -r host_ip
            if [ -f "$HOME/ssh_hosts.txt" ]
            then
              echo "$host_name added"
              echo "$host_name|$host_ip" >> "$HOME/ssh_hosts.txt"
            else
              if ! grep -Fxq "$host_name|$host_ip" "$HOME/ssh_hosts.txt"
              then
                echo "$host_name added"
                echo "$host_name|$host_ip" >> "$HOME/ssh_hosts.txt"
              else
                echo "$host_name already in hosts list"
              fi
            fi
            ;;
        "Connect to SSH host")
          if [ -f "$HOME/ssh_hosts.txt" ]
          then

            select d in $(<"$HOME/ssh_hosts.txt");
            do ssh "$( cut -d '|' -f 2 <<< "$d" )"
            $SHELL;
            done
          else
            echo "no hosts found"
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
