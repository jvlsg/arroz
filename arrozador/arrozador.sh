#!/bin/bash
## $PROG 0.1 - Auto Ricer
##
## USAGE: $PROG [OPTION] COMMAND
##


cat ./title

arg_pkg="-p"
arg_link_files="-l"
arg_copy_files="-c"
arg_interactive="-i"

parse_strings(){
    if [ "$1" == "$arg_pkg" ];then
        install_packages
    
    elif [ "$1" == "$arg_link_files" ] || [ "$1" == "$arg_copy_files" ] ; then
        handle_files $1

    elif [ "$1" == "-h" ];then
        echo "usage: [-p] installs packages , [-f] links dotfiles"
    else
        echo "Interactive mode?"
    fi
}

install_packages(){
    echo "INSTALLLING PACKAGES"
    #Check for distro type, install packages
    #pacman -S vim i3-gaps urxvt firefox compton lxappearance arc-gtk-theme openvpn cronie keepassxc veracrypt
    #pacman -Syyu
}

handle_files(){
    
    dirs=('.config' '.urxvt')
    files=('.vimrc' '.bashrc' '.Xresources')
    arg_cp='-rf'
    #Iterate on both lists, cat ../ with the strings
    #pass as xargs to cp -rf 

    if [ "$1" == "$arg_link_files" ];then
        echo "LINKING FILES"
        cp -rfl ../.config $HOME/
        cp -rfl ../.urxvt $HOME/

        cp -fl ../.vimrc $HOME/
        cp -fl ../.bashrc $HOME/
        cp -fl ../.Xresources $HOME/    
    else
        echo "COPYING FILES"
        cp -rf ../.config $HOME/
        cp -rf ../.urxvt $HOME/

        cp -f ../.vimrc $HOME/
        cp -f ../.bashrc $HOME/
        cp -f ../.Xresources $HOME/
    fi

}

parse_strings $@ 
