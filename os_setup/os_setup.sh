#! /bin/bash

# wget -O - https://raw.githubusercontent.com/russloewe/tools/main/os_setup/os_setup.sh | bash

echo "Updating apt..."
sudo apt-get update

echo "Installing base packages..."
sudo apt-get install -y synaptic geany geany-plugins  xfce4-goodies python3-gpg git codeblocks qgis sqlitebrowser texmaker

echo "Installing Dropbox..."
sudo wget -O ./dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
sudo apt-get install ./dropbox.deb
dropbox start -i
 
echo "Setting up xfce4 panel..."
wget -O ~/xfce4-backup-panel.tar.bz2 https://raw.githubusercontent.com/russloewe/tools/main/os_setup/xfce4-backup-panel.tar.bz2 
xfce4-panel-profiles load xfce4-backup-panel.tar.bz2

echo "Disabling Touchpad..."
a=`xinput | grep Touchpad`
regex='id=([0-9]+)'
if [[ $a =~ $regex ]]; then
	id=${BASH_REMATCH[1]}
	echo "Found touchpad at device #$id"
	echo "Disabling touchpad"
	xinput --disable $id
else
	echo "No touchpad found"
fi

echo "Success"
