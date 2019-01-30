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
#Print Help
ARG_HELP="-h"


parse_args(){
    if [ -z $@ ];then
        print_help
        return 1
    fi

    for arg in $@
    do
        case $arg in
            $ARG_INSTALL_PKGS)
                install_pkgs
            ;;
            $ARG_LINK_DOTS)
                handle_files -rfl
            ;;
            $ARG_COPY_DOTS)
                handle_files -rf
            ;;
            
            $ARG_INTER)
                interactive_mode
            ;;

            $ARG_HELP | *)
                print_help
            ;;
        esac
    done
}

print_help(){
    printf "usage:
    \n[$ARG_INSTALL_PKGS] Installs the desire packages
    \n[$ARG_LINK_DOTS] Links dotfiles
    \n[$ARG_COPY_DOTS] Copies dotfiles
    \n[$ARG_INTER] Run Interactive mode
    "
}

#Checks the User's base distro
distro_check(){
    . /etc/os-release
    #cond && codigo || codigoelse
    [ -n "$ID_LIKE" ] && CURR_DISTRO=$ID_LIKE || CURR_DISTRO=$ID
}

#Installs the desired packages for the distribution
install_pkgs(){ 
    #List of supported Distros
    distro_list=$(ls ./pkgs)
    
    for d in $distro_list 
    do
        if [ $CURR_DISTRO = $d ];then
            . ./pkgs/$d
            sudo $PKG_MAN_SYNC
            sudo $PKG_MAN_INSTALL $PKGS
            sudo $PKG_MAN_UPGRADE
            #Unsets the variables
            unset PKG_MAN_SYNC PKG_MAN_INSTALL PKGS PKG_MAN_UPGRADEU
	    return 0
        fi
    done

    printf "ERROR: No ./pkgs/$CURR_DISTRO variable script"
    return 1
}

#Handles the copying/Linking of files and directories
#$1: Args for cp: -rf (copy) or -rfl (link)
#OBS: Copying dirs merges contents with existing dirs
handle_files(){
    
    #Gets all files and dirs except . and ..
    files_and_dirs=$(ls ./dotfiles -A)    
    #ITERATING
    for i in ${files_and_dirs[@]}
    do
        relative_path="dotfiles/$i"
        echo "Copying/Linking $i ($relative_path) to $HOME"
        cp $1 $relative_path $HOME/  
    done
}


#Acts as a wizard-thingny for arrozador
#Only called if no arguments are passed
interactive_mode(){
    echo "Interactive mode?"
    printf "DETECTED $CURR_DISTRO AS BASE DISTRIBUTION - CORRECT?\n"
    
    local input=""

    while $1
    do
        read -p "[Y/N] > " input
        case $input in
            "Y"|"y")
                . ./pkgs/$CURR_DISTRO
                im_prompt_package_edit
            ;;
            "N"|"n")
               read -p "Type the distro's name (should same as the /pkg filename)\n > " $CURR_DISTRO 
            ;;
            *)
                read -p "[Y/N] > " input
            ;;
        esac
    done
}

#Prompt for Package list editing or proceed with the install
#Requires the 
im_prompt_package_edit(){
    printf "ARROZADOR WILL INSTALL THE FOLLOWING PACKAGES:\n $PKGS\n"
    local input=""
    read -p "EDIT THE PACKAGE LIST? [Y/N] > " input 
    case $input in
        "Y"|"y")
            echo $WEEE
            $TERM -e $EDITOR ./pkgs/$CURR_DISTRO
        ;;
        "N"|"n")
            install_pkgs
        ;;
        *)
            echo "Nope"
    esac
            
}

###############################################################################
cat ./title
distro_check
parse_args $@ 
