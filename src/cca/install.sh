#!/usr/bin/env bash
set -e

echo "Activating feature 'CCA CPU'"

# Clean up
rm -rf /var/lib/apt/lists/*

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u ${CURRENT_USER} > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u ${USERNAME} > /dev/null 2>&1; then
    USERNAME=root
fi

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

# Checks if packages are installed and installs them if not
check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

# Ensure apt is in non-interactive to avoid prompts
export DEBIAN_FRONTEND=noninteractive

# remove previous versions
rm -rf /usr/local/share/cca
rm -rf /opt/fvp
rm -rf /usr/local/bin/lkvm
rm -rf /usr/local/etc/fvp

# create directories
mkdir -p /usr/local/share/cca
mkdir -p /opt/fvp
mkdir -p /usr/local/etc/fvp

check_packages ca-certificates libatomic1 kmod wget iptables screen telnet

cp lkvm-cca /usr/local/share/cca
chmod ugo+x /usr/local/share/cca/lkvm-cca
cp fvp-cca /usr/local/share/cca
chmod ugo+x /usr/local/share/cca/fvp-cca
cp cca.config /usr/local/etc/fvp

cd /opt/fvp
if [ `uname -m` = "aarch64" ] ; then wget https://developer.arm.com/-/media/Files/downloads/ecosystem-models/FVP_Base_RevC-2xAEMvA_11.21_15_Linux64_armv8l.tgz ; \
                                    else wget https://developer.arm.com/-/media/Files/downloads/ecosystem-models/FVP_Base_RevC-2xAEMvA_11.21_15_Linux64.tgz ; fi \
    && tar xf F*.tgz && rm *.tgz

# grab artifacts
cd /usr/local/share/cca

wget -O Image https://github.com/ericvh/cca-cpu/releases/latest/download/Image
wget -O Image.guest https://github.com/ericvh/cca-cpu/releases/latest/download/Image.guest
wget -O initramfs.cpio https://github.com/ericvh/cca-cpu/releases/latest/download/initramfs.cpio
wget -O rmm.img https://github.com/ericvh/cca-cpu/releases/latest/download/rmm.img
wget -O bl1-linux.bin https://github.com/ericvh/cca-cpu/releases/latest/download/bl1-linux.bin
wget -O fip-linux.bin https://github.com/ericvh/cca-cpu/releases/latest/download/fip-linux.bin

cd /usr/local/bin
wget -O lkvm https://github.com/ericvh/cca-cpu/releases/latest/download/lkvm
chmod ugo+x /usr/local/bin/lkvm

ln -sf /opt/fvp/Base_RevC_AEMvA_pkg/models/Linux64*/FVP_Base_RevC-2xAEMvA fvp
ln -sf /usr/local/share/cca/fvp-cca fvp-cca

cd /workspaces
