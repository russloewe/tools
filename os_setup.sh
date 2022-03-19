#! /bin/bash

# wget -O - https://raw.githubusercontent.com/russloewe/tools/main/os_setup.sh | bash

sudo apt-get update
sudo apt-get install -y synaptic geany geany-plugins  xfce4-goodies python3-gpg git 
sudo wget -O ./dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
sudo apt-get install ./dropbox.deb
dropbox start -i
wget -c https://raw.githubusercontent.com/russloewe/tools/main/panel.tar.gz -O - | tar -xz
rm -r ~/.config/xfce4/panel
mv panel ~/.config/xfce4/
echo "Success"
