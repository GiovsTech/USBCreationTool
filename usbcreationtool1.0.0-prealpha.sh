#!/bin/bash
clear
latest_release_tag=$(curl -s https://api.github.com/repos/GiovsTech/USBCreationTool/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
current_version=$(git describe --tags)


if [[ $EUID -ne 0 ]]; then
  echo " This script must be run as root."
  exit 1
fi

if ! which git > /dev/null; then
   clear
   echo " GIT package not detected. Please install it and run the program again."
   exit 1
fi

if ! which wget > /dev/null; then
   clear
   echo " GIT package not detected. Please install it and run the program again."
   exit 1
fi

if ! which parted > /dev/null; then
   clear
   echo " GIT package not detected. Please install it and run the program again."
   exit 1
fi

## Manual way


inj_pr_manual(){
        mkdir /mnt/ISOCreationTool
        mkdir /mnt/USBCreationTool
        mount "$iso_path" /mnt/ISOCreationTool -o loop
        partitions=$(lsblk -l | grep "^$disk_path" | awk '{print $4}')
        for partition in $partitions; do
        if findmnt "$partition" | grep "$partition" ; then
        umount -f "$partition"
       fi 
       done
        clear
        echo " "
        echo " Partitioning the USB drive..."
        if [[ "$iso_path" == *"Win"* ]]; then
        parted "$disk_path" mklabel msdos
        else
        parted "$disk_path" mklabel gpt
        fi
        parted "$disk_path" mkpart primary fat32 0% 100%
        parted "$disk_path" set 1 boot on
        clear
        exit_code=$?
       if [[ $exit_code -eq 0 ]]; then
        echo " "
        echo " The partitioning step is successfully completed."
        echo " "
        echo " Formatting the usb drive "
        p=1
        mkfs.fat -F32 "$disk_path$p"
        mount "$disk_path$p" /mnt/USBCreationTool
        exit_code_mk=$?
        if [[ $exit_code_mk -eq 0 ]]; then
        echo " "
        echo " Injecting the file ISO to the USB drive $disk_path..."
        cp -v -r /mnt/ISOCreationTool/* /mnt/USBCreationTool
        echo " "
        echo " ISO image successfully injected in USB drive."
        echo " To unmount your USB drive, run the script with "
        echo " the option '-u usb_drive_name'."
        exit 0
        else
        umount -f /mnt/ISOCreationTool
        umount -f /mnt/USBCreationTool
        rm -r /mnt/ISOCreationTool
        rm -f /mnt/USBCreationTool
        echo "" 
        echo " An error was encoutered"
        exit $exit_code_mk
        fi
        
       else
        umount -f /mnt/ISOCreationTool
        umount -f /mnt/USBCreationTool
        rm -r /mnt/ISOCreationTool
        rm -f /mnt/USBCreationTool
        echo "" 
        echo " An error was encoutered"
        exit $exit_code
       fi
      
}

verbose=$1
d=$2
device=$3
iso=$4
iso_file=$5

if [[ $1 == "-h" ]]; then
clear
echo " "
echo "   #####################################################"
echo "  #                 USBCreationTool                 #"
echo " #####################################################"
echo " "
echo " USBCreationTool is a simple bash script that helps"
echo " you to make a bootable USB in a short time. "
echo " This script is set in manual mode. If you want to run "
echo " the scripted mode, don't write any arguments. "
echo " "
echo " List of available commands: "
echo "  -h  show this help text"
echo "  -v  set the manual mode"
echo "  -d (followed by your USB Drive path) sets your USB drive path "
echo "  -i (followed by your ISO image file) sets your ISO image file "
echo " "
echo "  Note: These commands ( -d, -i ) have to be executed with -V (verbose option)"
echo " "
echo "  -u (followed by your USB drive path) unmount your USB drive, removing also the folder where it was mounted. "
exit
fi

if [[ $1 == "-u" ]]; then
clear
 partitions=$(lsblk -l | grep "^$2" | awk '{print $4}')
        for partition in $partitions; do
        if findmnt "$partition" | grep "$partition" ; then
        umount -f "$partition"
       fi 
       done
echo " "
echo " USB Disk successfully unmounted."
exit 0
fi


if [[ $verbose == "-v" ]]; then
  echo " "
  echo " USBCreationTool is set in manual mode. "
  echo " "
  clear
  if [[ $d == "-d" ]]; then
  disk_path=$device
  if [[ $iso == "-i" ]]; then
  iso_path=$iso_file
  inj_pr_manual
  else
clear
echo " "
echo "   #####################################################"
echo "  #                 USBCreationTool                 #"
echo " #####################################################"
echo " "
echo " Command not found. "
echo " "
echo " USBCreationTool is a simple bash script that helps"
echo " you to make a bootable USB in a short time. "
echo " This script is set in manual mode. If you want to run "
echo " the scripted mode, don't write any arguments. "
echo " "
echo " List of available commands: "
echo "  -h  show this help text"
echo "  -v  set the manual mode"
echo "  -d (followed by your USB Drive path) sets your USB drive path "
echo "  -i (followed by your ISO image file) sets your ISO image file "
echo " "
echo "  Note: These commands ( -d, -i ) have to be executed with -V (verbose option)"
echo " "
echo "  -u (followed by your USB drive path) unmount your USB drive, removing also the folder where it was mounted. "
  fi
  else
clear
echo " "
echo "   #####################################################"
echo "  #                 USBCreationTool                 #"
echo " #####################################################"
echo " "
echo " Command not found. "
echo " "
echo " USBCreationTool is a simple bash script that helps"
echo " you to make a bootable USB in a short time. "
echo " This script is set in manual mode. If you want to run "
echo " the scripted mode, don't write any arguments. "
echo " "
echo " List of available commands: "
echo "  -h  show this help text"
echo "  -v  set the manual mode"
echo "  -d (followed by your USB Drive path) sets your USB drive path "
echo "  -i (followed by your ISO image file) sets your ISO image file "
echo " "
echo "  Note: These commands ( -d, -i ) have to be executed with -V (verbose option)"
echo " "
echo "  -u (followed by your USB drive path) unmount your USB drive, removing also the folder where it was mounted. "
  fi
else
clear
echo " "
echo "   #####################################################"
echo "  #                 USBCreationTool                 #"
echo " #####################################################"
echo " "
echo " Command not found. "
echo " "
echo " USBCreationTool is a simple bash script that helps"
echo " you to make a bootable USB in a short time. "
echo " This script is set in manual mode. If you want to run "
echo " the scripted mode, don't write any arguments. "
echo " "
echo " List of available commands: "
echo "  -h  show this help text"
echo "  -v  set the manual mode"
echo "  -d (followed by your USB Drive path) sets your USB drive path "
echo "  -i (followed by your ISO image file) sets your ISO image file "
echo " "
echo "  Note: These commands ( -d, -i ) have to be executed with -V (verbose option)"
echo " "
echo "  -u (followed by your USB drive path) unmount your USB drive, removing also the folder where it was mounted. "
fi


## Scripted Way
main(){
clear
clear
echo " "
echo "   #####################################################"
echo "  #                 USBCreationTool                 #"
echo " #####################################################"
echo " "
echo " Welcome to USBCreationTool. This program is meant to create"
echo " a bootable USB drive in a short time. This script is made by GiovsTech."
echo " This program has two different ways to execute this purpose:"
echo " scripted mode and manual mode. Choose your favorite one!"
echo " "
echo " USBCreationTool could be used to inject any ISO files in a USB Drive."
echo " This script also includes some ISO download URL by default, but you can"
echo " select your custom ISO file, of course!"
echo " "
echo " "
read -s -r -p "   - Press any key to continue..."
if [ -d /mnt/USBCreationTool ]; then
  if mount | grep "/mnt/USBCreationTool" > /dev/null; then
    umount -f /mnt/USBCreationTool
    umount -f /mnt/ISOCreationTool
    mainmenu
  fi
fi
mainmenu
}

quit ()
{
  if [ -d /mnt/USBCreationTool ]; then
  if mount | grep "/mnt/USBCreationTool" > /dev/null; then
    echo " " 
    echo " Unmounting the USB drive"
    umount -f /mnt/ISOCreationTool 
    umount -f /mnt/USBCreationTool
  fi
  rm -r /mnt/USBCreationTool
  rm -r /mnt/ISOCreationTool
fi
  clear
  echo " "
  echo "   #####################################################"
  echo "  #                  USBCreationTool                  #"
  echo " #####################################################"
  echo " "
  echo " USBCreationTool version $current_version"
  echo " "
  echo " Developed by GiovsTech"
  echo " "
  echo " "
  echo " GitHub Repository [https://github.com/GiovsTech/USBCreationTool]"
  echo " Report an issue [https://github.com/GiovsTech/USBCreationTool/issues]"
  echo " "
  echo " Have a good day!"
  echo " "
  echo " "
  read -s -r -p "   - Press any key to exit..."
  exit 0
}

upgrade ()
{

if [[ $latest_release_tag > $current_version ]]; then
  clear
  echo " "
  echo "   #####################################################"
  echo "  #                 USBCreationTool                 #"
  echo " #####################################################"
  echo " "
  echo "                      Upgrade Menu"
  echo " "
  echo " It seems there is a new update for your script. "
  echo " "
  read -p "   - Press U to install the update or B to go back to the main menu..." ch3
  while true; do
    case $ch3 in
      B)
        mainmenu
        ;;
      b)
        mainmenu
        ;;
      U)
        clear
        echo " "
        echo " Installing the update..."
        git init
        git remote add origin https://github.com/GiovsTech/USBCreationTool.git
        git pull origin master
        echo " "
        echo " "
        echo " Update installed successfully. Please run the new updated script."
        exit 0
        ;;
      u)
        clear
        echo " "
        echo " Installing the update..."
        git init
        git remote add origin https://github.com/GiovsTech/USBCreationTool.git
        git pull origin master
        echo " "
        echo " "
        echo " Update installed successfully. Please run the new updated script."
        exit 0
        
        ;;
      *)
        upgrade
        ;;
    esac
  done
else
  clear
  echo " "
  echo "   #####################################################"
  echo "  #                  USBCreationTool                  #"
  echo " #####################################################"
  echo " "
  echo "                      Upgrade Menu"
  echo " "
  echo " USBCreationTool is up to date. "
  echo " "
  read -s -r -p "   - Press any key to go back to the main menu..."
  mainmenu
fi

}


inj_pr(){
        mkdir /mnt/ISOCreationTool
        mkdir /mnt/USBCreationTool
        mount "$iso_path" /mnt/ISOCreationTool -o loop
        partitions=$(lsblk -l | grep "^$disk_path" | awk '{print $4}')
        for partition in $partitions; do
        if findmnt "$partition" | grep "$partition" ; then
        umount -f "$partition"
       fi 
       done
        clear
        echo " "
        echo " Partitioning the USB drive..."
        if [[ "$iso_path" == *"Win"* ]]; then
        parted "$disk_path" mklabel msdos
        else
        parted "$disk_path" mklabel gpt
        fi
        parted "$disk_path" mkpart primary fat32 0% 100%
        parted "$disk_path" set 1 boot on
        clear
        exit_code=$?
       if [[ $exit_code -eq 0 ]]; then
        echo " "
        echo " The partitioning step is successfully completed."
        echo " "
        echo " Formatting the usb drive "
        p=1
        mkfs.fat -F32 "$disk_path$p"
        mount "$disk_path$p" /mnt/USBCreationTool
        exit_code_mk=$?
        if [[ $exit_code_mk -eq 0 ]]; then
        echo " "
        echo " Injecting the file ISO to the USB drive $disk_path..."
        cp -v -r /mnt/ISOCreationTool/* /mnt/USBCreationTool
        quit
        else
        umount -f /mnt/ISOCreationTool
        umount -f /mnt/USBCreationTool
        rm -r /mnt/ISOCreationTool
        rm -f /mnt/USBCreationTool
        echo "" 
        echo " An error was encoutered"
        exit $exit_code_mk
        fi
        
       else
        umount -f /mnt/ISOCreationTool
        umount -f /mnt/USBCreationTool
        rm -r /mnt/ISOCreationTool
        rm -f /mnt/USBCreationTool
        echo "" 
        echo " An error was encoutered"
        exit $exit_code
       fi
      
}

injecting_mainmenu ()
{
  clear
  echo " "
  echo "   #####################################################"
  echo "  #                 USBCreationTool                 #"
  echo " #####################################################"
  echo " "
  echo " The USB Drive is selected. Now, choose an option."
  echo " "
  echo " 1. Inject your ISO Image"
  echo " 2. Browse different ISO images"
  echo " "
  echo " E. Exit"
  echo " " 
  echo " "
  read -p "   - Enter your choice:" ch2
  while true; do
    case $ch2 in
      1)
        clear     
        echo " "
        echo "   #####################################################"
        echo "  #                  USBCreationTool                 #"
        echo " #####################################################"
        echo " "
        read -p "   - Enter your ISO image path:" iso_path
        while [[ ! -f "$iso_path" ]]; do
        echo " The specified ISO image is not valid. Please enter a valid ISO image file."
        read -p "   - Enter your partiton path:" iso_path
        done
        inj_pr
     ;;
      2)
        clear
        echo " "
        echo "   #####################################################"
        echo "  #                 USBCreationTool                 #"
        echo " #####################################################"
        echo " "
        echo " Choose between these ISO images in order to download them"
        echo " from their mirrors. You will see the download process."
        echo " "
        echo " 1. Arch Linux (Worldwide mirror - AMD64)"
        echo " 2. Ubuntu Lunar Lobster (AMD64)"
        echo " 3. Debian 12 (AMD64)"
        echo " "
        echo " B. Go back"
        echo " " 
        echo " "
        read -p "   - Enter your choice:" ch1
        while true; do
        case $ch1 in
        1) 
          clear
          echo " "
          echo " Download the latest Arch Linux ISO"
          if [[ ! -f "/tmp/archlinux-x86_64.iso" ]]; then
          wget https://geo.mirror.pkgbuild.com/iso/latest/archlinux-x86_64.iso -P /tmp/
           exit_code_ar=$?
           if [[ $exit_code_ar -eq 0 ]]; then
           echo " "
           echo " The latest Arch Linux ISO is downloaded."
           echo " Now, let's inject your ISO in your USB Drive."
           iso_path="/tmp/archlinux-x86_64.iso"
          inj_pr
        else 
        echo "" 
        echo " An error was encoutered"
        exit $exit_code_ar
      fi
          else
          echo "" 
          echo " Ops! There is already a downloaded ISO in this path"
          echo " So, let's inject this ISO!"
          iso_path="/tmp/archlinux-x86_64.iso"
          inj_pr
        fi
      ;;
      2) 
          clear
          echo " "
          echo " Download the latest Ubuntu Lunar Lobster ISO"
          if [[ ! -f "/tmp/ubuntu-23.04-desktop-amd64.iso" ]]; then
           wget https://releases.ubuntu.com/23.04/ubuntu-23.04-desktop-amd64.iso -P /tmp/
           exit_code_ub=$?
           if [[ $exit_code_ub -eq 0 ]]; then
           echo " "
           echo " The Ubuntu Lunar Lobster ISO is downloaded."
           echo " Now, let's inject your ISO in your USB Drive."
           iso_path="/tmp/ubuntu-23.04-desktop-amd64.iso"
          inj_pr
        else 
        echo "" 
        echo " An error was encoutered"
        exit $exit_code_ub
      fi
          else
          echo "" 
          echo " Ops! There is already a downloaded ISO in this path"
          echo " So, let's inject this ISO!"
          iso_path="/tmp/ubuntu-23.04-desktop-amd64.iso"
          inj_pr
        fi
     ;;

     3)
          clear
          echo " "
          echo " Download the latest Debian 12 ISO"
          if [[ ! -f "/tmp/debian-12.1.0-amd64-netinst.iso" ]]; then
           wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-12.1.0-amd64-netinst.iso -P /tmp/
           exit_code_db=$?
           if [[ $exit_code_db -eq 0 ]]; then
           echo " "
           echo " The latest Debian 12 is downloaded."
           echo " Now, let's inject your ISO in your USB Drive."
           iso_path="/tmp/debian-12.1.0-amd64-netinst.iso"
          inj_pr
        else 
        echo "" 
        echo " An error was encoutered"
        exit $exit_code_db
      fi
          else
          echo "" 
          echo " Ops! There is already a downloaded ISO in this path"
          echo " So, let's inject this ISO!"
          iso_path="/tmp/debian-12.1.0-amd64-netinst.iso"
          inj_pr
        fi
;;
b) 
injecting_mainmenu
;;
B)
injecting_mainmenu

        esac 
        done
        ;;
  
      e) 
        quit
        ;;
      E) 
        quit
        ;;
      
      *)
        injecting_mainmenu
        ;;
    esac
  done
}


mainmenu () 
{
  clear
  echo " "
  echo "   #####################################################"
  echo "  #                  USBCreationTool                  #"
  echo " #####################################################"
  echo " "
  echo " The USB Drive is not selected."
  echo " "
  echo " 1. Mount USB drive partition to /mnt/USBCreationTool"
  echo " "
  echo " U. Upgrade your script "
  echo " " 
  echo " E. Exit"
  echo " " 
  echo " "
  while true; do
    read -p "   - Enter your choice:" ch0
    case $ch0 in
      E) 
        quit
        ;;
      e) 
        quit
        ;;
      u)
        upgrade
        ;;
      U) 
        upgrade
        ;;
      1)
        clear
        echo " "
        echo " In order to mount your USB Drive, you need to specify your usb drive's path."
        echo " From the below list, enter the path (sdc, sda, ...) of your USB drive partition, without '/dev/'."
        echo " "
        lsblk
        echo " "
        read -p "   - Enter your partiton path:" disk_path_sel
        while [[ ! $(lsblk | grep -w -c "$disk_path_sel") -eq 1 ]]; do
          echo " The specified partition is not valid. Please enter a valid partition path."
          read -p "   - Enter your partiton path:" disk_path_sel
        done
        disk_path="/dev/$disk_path_sel"
        injecting_mainmenu
        ;;
      *)
        mainmenu  
        ;;
   esac
  done
}
if [[ $1 == "" ]]; then
main
fi