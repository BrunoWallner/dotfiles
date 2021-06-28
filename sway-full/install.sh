#!/bin/sh

USER=$SUDO_USER

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

full_install()
{
	echo ""
	echo "[Backing up data to ./backup]"
	mkdir backup
	mkdir ./backup/config/
	cp -r /home/$USER/.config/* ./backup/config/
	cp -r /etc/environment ./backup/
	cp ./background.jpg /usr/share/backgrounds/
	
	# writes environment vars to /etc/environment
	echo ""
	echo "[writing environment varialbes to /etc/enviroment]"
	echo "XDG_CURRENT_DESKTOP=Unity" >> /etc/environment
	echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
	
	# copies .config files
	echo ""
	echo "[copying .config files]"
	cp -r ./config/* /home/$USER/.config/
	
	if command -v /usr/bin/flatpak &> /dev/null
	then
		echo ""
		echo "[Flatpak themeing]"
		flatpak install org.gtk.Gtk3theme.Breeze-Dark -y
		flatpak override --system --env GTK_THEME=Breeze-Dark
	fi

	
	echo ""
	echo "[DONE]"
	echo "you need to manually install following packages:"
	echo "> sway"
	echo "> waybar"
	echo "> swaylock"
	echo "> light"
	echo "> wofi"
	echo "> alacritty"
	
	echo ""
	
	echo "you also need to execute 'qt5ct' to set qt5 theme and"
	echo "'chmod u+s /usr/bin/light for working backlight controll"
	echo ""
	
	exit
	
}

echo "this script will delete all configs for:"
echo "/home/$USER/.config/sway /usr/share/backgrounds"
echo "/home/$USER/.config/waybar"
echo ""
echo "it will also modify:"
echo "/etc/enviroment"
echo "/usr/share/backgrounds/"
echo ""

read -p "Do you wish to continue [Y/N]" yn
case $yn in
    [Yy]* ) full_install break;;  
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no.";;
esac

