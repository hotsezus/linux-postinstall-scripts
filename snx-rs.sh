#!/usr/bin/env bash

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Installing dependencies using package manager${NC}"
if [ -x "$(command -v apt)" ];
then
    apt install -y libayatana-appindicator3-dev
elif [ -x "$(command -v dnf)" ];
then
    dnf install -y libayatana-appindicator-gtk3-devel
else
    echo "Package manager not found. You must manually install: libappindicator-gtk3-devel. Package should provide `libappindicator3` dynamic libraries because snx-rs-gui depends on `libappindicator3`";
fi

echo -e "${YELLOW}Stop service${NC}"
systemctl stop snx-rs.service
systemctl status snx-rs.service

echo -e "${YELLOW}Copy binaries to /opt/snx-rs/${NC}"
mkdir -vp /opt/snx-rs
cp --verbose snxctl /opt/snx-rs/snxctl
cp --verbose snx-rs /opt/snx-rs/snx-rs
cp --verbose snx-rs-gui /opt/snx-rs/snx-rs-gui

echo -e "${YELLOW}Add desktop entry /usr/share/applications/snx-rs-gui.desktop${NC}"
cp --verbose snx-rs-gui.desktop /usr/share/applications/snx-rs-gui.desktop
sed -i 's/^Icon=network-vpn/Icon=network-vpn-symbolic/' /usr/share/applications/snx-rs-gui.desktop
sed -i 's/^Name=SNX-RS VPN client/Name=SNX/' /usr/share/applications/snx-rs-gui.desktop

echo -e "${YELLOW}Add service /usr/lib/systemd/system/snx-rs.service${NC}"
cp --verbose snx-rs.service /usr/lib/systemd/system/snx-rs.service

echo -e "${YELLOW}Apply permissions${NC}"
chmod --verbose 755 /opt/snx-rs/snxctl  /opt/snx-rs/snx-rs /opt/snx-rs/snx-rs-gui
chmod --verbose 644 /usr/share/applications/snx-rs-gui.desktop
chmod --verbose 644 /usr/lib/systemd/system/snx-rs.service

echo -e "${YELLOW}Enable service${NC}"
systemctl daemon-reload
systemctl enable snx-rs.service
systemctl start snx-rs.service
systemctl status snx-rs.service
