#!/bin/sh

########################################################################################################################
sudo raspi-config
# 1. Enter
# sudo raspi-config in a terminal window
# 2. Select Interfacing Options
# 3. Navigate to and select SSH
# 4. Choose Yes
# 5. Select Ok
# 6. Choose Finish
sudo systemctl enable ssh
sudo systemctl start ssh

########################################################################################################################
apt update
apt upgrade
apt -y install aptitude mc iotop htop iftop usbutils smartmontools alsa-utils alsa-tools
apt -y install bash-completion
apt -y install python python-setuptools mpd mpc ncmpc git python-pip python-dev build-essential
apt -y install libao-dev libssl-dev libcrypt-openssl-rsa-perl libio-socket-inet6-perl libwww-perl avahi-utils libmodule-build-perl
apt -y install bc sysstat logrotate
apt -y install exfat-fuse exfat-utils
pip install python-mpd2 tinytag termcolor web.py python-mpd pyserial tornado argparse requests socketIO-client websocket-client pexpect pybluez bluetool
apt -y install hostapd udhcpd
apt -y install samba smbclient
apt -y install tree
apt -y install netcat

########################################################################################################################
# shairport-sync

apt -y install build-essential git xmltoman
apt -y install autoconf automake libtool libdaemon-dev libpopt-dev libconfig-dev
apt -y install libasound2-dev
apt -y install libpulse-dev
apt -y install avahi-daemon libavahi-client-dev
apt -y install libssl-dev
apt -y install libmbedtls-dev
apt -y install libsoxr-dev

git clone https://github.com/mikebrady/shairport-sync.git
autoreconf -i -f
./configure --sysconfdir=/etc --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-soxr --with-systemd
make
make install
systemctl start shairport-sync
systemctl enable shairport-sync

# shairport-sync dacp
git clone https://gist.github.com/unnmd/b64c3a98076a57717aeeaa5bebd3eef7#file-main-c
gcc main.c -o dacp_client -L /usr/lib/x86_64-linux-gnu/ -lavahi-client -lavahi-common

git clone https://gist.github.com/unnmd/b64c3a98076a57717aeeaa5bebd3eef7#file-rtsp-c-diff
patch -p1 rtsp.c < rtsp.c.diff

chmod +x ./dacp_client
cp ./dacp_client /usr/bin/dacp_client
cp ./dacp_client.service /lib/systemd/system/dacp_client.service
chmod 644 /lib/systemd/system/dacp_client.service
systemctl daemon-reload
systemctl enable dacp_client.service
systemctl start dacp_client.service

########################################################################################################################
# Install motd

git clone https://github.com/fedya/omv_motd.git
cp -v motd_hello_gen /usr/bin/
cp motd.service motd.timer /etc/systemd/system/
systemctl enable motd.timer
systemctl start motd.timer

########################################################################################################################
# VOLUMIO + BLUEZ-ALSA (A2DP BLUETOOTH SUPPORT)
# https://volumio.org/forum/volumio-bluetooth-receiver-t8937.html
pip install bluetool

apt-cache search libasound
apt -y install libasound2-dev
apt -y install dh-autoreconf
apt -y install libortp-dev
apt -y install bluez pi-bluetooth bluez-tools libbluetooth-dev bluetooth
apt -y install libusb-dev libglib2.0-dev libudev-dev libical-dev libreadline-dev
apt -y install libsbc1 libsbc-dev
apt -y install tcpbridge python-dbus python-gobject
apt -y install libdbus-1-dev
apt -y install gawk

git clone https://github.com/Arkq/bluez-alsa.git
cd bluez-alsa
autoreconf --install
mkdir build && cd build
../configure --disable-hcitop --with-alsaplugindir=/usr/lib/arm-linux-gnueabihf/alsa-lib
make && sudo make install

systemctl daemon-reload

systemctl enable bluealsa.service
systemctl start bluealsa.service

systemctl enable bluetooth.service
systemctl start bluetooth.service

chmod a+rwx /root/bin/a2dp-autoconnect
chmod a+rw /var/log/a2dp-autoconnect

########################################################################################################################



