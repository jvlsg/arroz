#!/bin/bash
## $PROG 0.1 - Auto Ricer
##
## USAGE: $PROG [OPTION] COMMAND
##
#Install desired packages
ARG_INSTALL_PKGS="-p"
#Hardlink the Dotfiles
ARG_LINK_DOTS="-l"
#Only Copy the Dotfiles
ARG_COPY_DOTS="-c"
#Interactive mode
ARG_INTER="-i"

parse_args(){
    if [ "$1" = "$ARG_INSTALL_PKGS" ];then
        install_pkgs
    elif [ "$1" = "$ARG_LINK_DOTS" ];then
        handle_files -rfl
    elif [ "$1" = "$ARG_COPY_DOTS" ] ; then
        handle_files -rf
    elif [ "$1" = "-h" ];then
        echo "usage: [$ARG_INSTALL_PKGS] installs pkgs , 
        [$ARG_LINK_DOTS] links dotfiles, 
        [$ARG_COPY_DOTS] Copies dotfiles"
    else
        echo "Interactive mode?"
    fi
}

#Checks the User's base distro
distro_check(){
    echo "CHECKING DISTRO TYPE"
    . /etc/os-release
    #cond && codigo || codigoelse
    [ -n "$ID_LIKE" ] && CURR_DISTRO=$ID_LIKE || CURR_DISTRO=$ID
    echo "DETECTED $CURR_DISTRO AS BASE"
}

#Installs the desired packages for the distribution
install_pkgs(){ 
    #List of supported Distros
    distro_list=$(ls ./pkgs)
    
    for d in $distro_list 
    do
        if [ $CURR_DISTRO = $d ];then
            . ./pkgs/$d
            $PKG_MAN_SYNC
            $PKG_MAN_INSTALL $PKGS
            $PKG_MAN_UPGRADE
            #Unsets the variables
            unset PKG_MAN_SYNC PKG_MAN_INSTALL PKGS PKG_MAN_UPGRADE
            break
        fi
    done
     
}

#Handles the copying/Linking of files and directories
#$1: Args for cp: -rf (copy) or -rfl (link)
#OBS: Copying dirs merges contents with existing dirs
handle_files(){
    
    #Gets all files and dirs except . and ..
    files_and_dirs=$(ls -a | cut -d " " -f3-)    
    echo ">  $files_and_dirs"
    #ITERATING
    for i in ${files_and_dirs[@]}
    do
        relative_path="dotfiles/$i"
        echo "Copying/Linking $i ($relative_path) to $HOME"
        #cp $1 $relative_path $HOME/  
    done
}

###############################################################################
cat ./title
distro_check
parse_args $@ 
