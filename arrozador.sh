#!/bin/bash
## $PROG 0.1 - Auto Ricer
##
## USAGE: $PROG [OPTION] COMMAND
##
#Install desired packages
ARG_INSTALL_PKGS="p"
#Hardlink the Dotfiles
ARG_LINK_DOTS="l"
#Only Copy the Dotfiles
ARG_COPY_DOTS="c"
#Interactive mode
ARG_INTER="i"
#Force distro directory
ARG_FORCE_DISTRO="f"
#Print Help
ARG_HELP="h"


#Checks the User's base distro
get_distro(){
    . /etc/os-release
    #cond && codigo || codigo-else
    [ -n "$ID_LIKE" ] && CURR_DISTRO=$ID_LIKE || CURR_DISTRO=$ID
    echo "SELECTED $CURR_DISTRO AS DISTRO"
}

#SELECTS THE DISTRO DIRECTOY and files to use
#$1: Distros name
select_distro_dir(){
    candidate_distros=$(ls ./distros | grep $1)
    
    #Length of Array: ${#array_name[@]}

    if [ ${#candidate_distros[@]} -eq 0 ];then
        
        printf "ERROR: No ./distros/$1 (or similar) directory"
        return 1
    fi
    
    if [ ${#candidate_distros[@]} -eq 1 ];then
        echo "USING ./distros/$candidate_distros CONFIGS"
        cd ./distros/$candidate_distros
        return $?
    else
        for d in $candidate_distros
        do
            y_n_prompt "USE $d files?"
            if [ $? -eq 0 ];then

                echo "USING ./distros/$d CONFIGS"
                cd ./distros/$d
                return $?
            fi
        done
    fi
    return 1

}


print_help(){
    printf "usage:
    \n[-$ARG_INSTALL_PKGS] Installs the desired packages
    \n[-$ARG_LINK_DOTS] Links dotfiles
    \n[-$ARG_COPY_DOTS] Copies dotfiles
    \n[-$ARG_INTER] Run Interactive mode
    "
}


parse_args(){
    while getopts ":$ARG_FORCE_DISTRO $ARG_INSTALL_PKGS $ARG_LINK_DOTS $ARG_COPY_DOTS $ARG_INTER $ARG_HELP" arg;do
        case ${arg} in
            $ARG_FORCE_DISTRO)
                echo "TODO"
            ;;
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
            $ARG_HELP | * | \?)
                print_help
            ;;
        esac
    done
    shift $((OPTIND -1))
}

#Installs the desired packages for the distribution
install_pkgs(){ 

    . pkg.conf    #Runs the file

    if [ $? ];then

        echo "SYNCHRONIZING PACKAGE MANAGER"
        sudo $PKG_MAN_SYNC
        if [ $? -ne 0 ];then
            echo "ERROR: FAILED SYNCHRONIZING PACKAGE MANAGER"
        fi
        
        echo "INSTALLING PACKAGES"
        sudo $PKG_MAN_INSTALL $PKGS
        if [ $? -ne 0 ];then
            echo "ERROR: FAILED INSTALLING PACKAGES"
        fi
        
        echo "UPGRADING PACKAGES"
        sudo $PKG_MAN_UPGRADE
        if [ $? -ne 0 ];then
            echo "ERROR: FAILED UPGRADING PACKAGES"
        fi
        
        #Unsets the variables
        unset PKG_MAN_SYNC PKG_MAN_INSTALL PKGS PKG_MAN_UPGRADE
    
    else
        echo "ERROR, NO PKG.CONF FILE DETECTED"
    fi

}


#Handles the copying/Linking of files and directories
#$1: Args for cp: -rf (copy) or -rfl (link)
#OBS: Copying dirs merges contents with existing dirs
handle_files(){
    
    FILE_OP_STR=""
    
    if [ $1 == "-rf" ];then
        FILE_OP_STR="COPYING"
    elif [ $1 == "-rfl" ];then
        FILE_OP_STR="LINKING"
    else
        echo "ERROR: INVALID handle_files OPERATION "
    fi

    #Gets all files and dirs except . and ..
    files_and_dirs=$(ls ./dotfiles -A)    
    #ITERATING
    for i in ${files_and_dirs[@]}
    do
        relative_path="dotfiles/$i"
        echo "$FILE_OP_STR ($relative_path) to $HOME"
        
        cp $1 $relative_path $HOME/ 

        if [ $? -ne 0 ];then
            echo "ERROR: FAILED cp $1 $relative_path $HOME"
        fi
        
    done
}


#Acts as a wizard-thingny for arrozador
#Only called if no arguments are passed
interactive_mode(){
    echo "Interactive mode?"
    
    y_n_prompt "DETECTED $CURR_DISTRO AS BASE DISTRIBUTION - CORRECT?"

     
    if [ $? -eq 0 ];then
        . ./pkgs/$CURR_DISTRO
        im_prompt_package_edit
    else
        read -p "Type the distro's name (should same as the /pkg filename)\n > " $CURR_DISTRO 
    fi
}

    #Prompt for Package list editing or proceed with the install
#Requires the 
im_prompt_package_edit(){
    printf "ARROZADOR WILL INSTALL THE FOLLOWING PACKAGES:\n $PKGS\n"
    local input=""
    
    y_n_prompt "EDIT THE PACKAGE LIST?" 
    if [ $? -eq 0 ];then
        return sh $TERM -e $EDITOR ./pkgs/$CURR_DISTRO
    else
        return install_pkgs
    fi
}

y_n_prompt(){

    printf "$1\n"
    local input=""
    while read -p "[Y/N] > " input 
    do
        case $input in
            "Y"|"y")
                return 0
            ;;
            "N"|"n")
                return 1
            ;;
        esac
        printf "$1\n"
    done
}


###############################################################################
#MAIN
###############################################################################

cat ./title
get_distro
select_distro_dir $CURR_DISTRO
parse_args $@
echo "...Done"
