#!/bin/bash
# Bash Menu Script Example
ssh_dir="$HOME/.ssh/id_rsa"

PS3='Fill action: '
options=("Generate SSH key" "Copy SSH key" "Quit")
select opt in "${options[@]}"
do
    case $opt in
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
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
