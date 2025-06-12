#!/bin/sh

# Source /etc/os-release
. /etc/os-release

if [ "$NAME" != "Ubuntu" ]
then
  echo "This script is only written to support Ubuntu; found $NAME."
  exit 1
fi

if [ "$VERSION_ID" != "24.04" ]
then
  echo "This script is written for Ubuntu 24.04; found $VERSION_ID."
  exit 1
fi

# Install Curl
sudo apt-get install -y curl

# Install Microsoft's public key
curl -s https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --yes --dearmor -o /etc/apt/trusted.gpg.d/microsoft-prod.gpg

# Install Microsoft Repo
curl https://packages.microsoft.com/config/ubuntu/${VERSION_ID}/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-${VERSION_CODENAME}-prod.list

# Install Jammy repo - The VPN client hasn't made it to the 24.04 repo
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/microsoft-ubuntu-jammy-prod.list

# Fix key location
sudo sed -i 's/\/usr\/share\/keyrings/\/etc\/apt\/trusted\.gpg\.d/g' /etc/apt/sources.list.d/microsoft-ubuntu-${VERSION_CODENAME}-prod.list

# MS Edge Repo
echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge/ stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
sudo apt-get update

sudo apt-get -y install microsoft-edge-stable microsoft-azurevpnclient intune-portal

# Set Edge as the default browser - Needed for VPN auth
xdg-settings set default-web-browser microsoft-edge.desktop

# Update PAM password configuration; note the $ in retry=3$ to make sure it's the end of the line
sudo sed -i 's/retry=3$/retry=3 dcredit=-1 ocredit=-1 ucredit=-1 lcredit=-1 minlen=12/' /etc/pam.d/common-password

# Add Azure CLI; not necessary for intune, but we'll need it for work anyway
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs 2>/dev/null) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt-get update
sudo apt-get install -y azure-cli

echo "You may consider rebooting here so that the microsoft-identity-broker service can be initialized."
