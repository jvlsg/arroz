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

parse_args(){
    if [ "$1" == "$arg_pkg" ];then
        install_packages
    elif [ "$1" == "$arg_link_files" ];then
        handle_files -rfl
    elif [ "$1" == "$arg_copy_files" ] ; then
        handle_files -rf
    elif [ "$1" == "-h" ];then
        echo "usage: [$arg_pkg] installs packages , [$arg_link_files] links dotfiles, [$arg_copy_files] Copies dotfiles"
    else
        echo "Interactive mode?"
    fi
}

install_packages(){
    packages=" i3-gaps urxvt firefox compton lxappearance arc-gtk-theme openvpn cronie keepassxc veracrypt"

    echo "CHEKING DISTRO TYPE"

    . /etc/os-release
    #cond && codigo || codigoelse
    [ -n "$ID_LIKE" ] && distro=$ID_LIKE || distro=$ID
    case $distro in
    "arch")
        pacman 

    #pacman -S vim i3-gaps urxvt firefox compton lxappearance arc-gtk-theme openvpn cronie keepassxc veracrypt
    #pacman -Syyu
}

#ARGS: Args for cp: -rf (copy) or -rfl (link)
handle_files(){
    
    #OBS: Copying dirs merges contents with existing dirs
    files_and_dirs=('.config' '.urxvt' '.vimrc' '.bashrc' '.Xresources')

    
    #ITERATING
    for i in ${files_and_dirs[@]}
    do
        relative_path="dotfiles/$i"
        echo "Copying/Linking $i ($relative_path) to $HOME"
        cp $1 $relative_path $HOME/  
    done
}

parse_args $@ 
