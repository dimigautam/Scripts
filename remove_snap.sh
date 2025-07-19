#!/bin/bash

set -e

echo "🚨 This script will completely remove Snap, Snap packages, and prevent reinstallation."
read -p "Are you sure you want to continue? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "❌ Aborted."
    exit 1
fi

# Function: Remove all snap packages matching a pattern
remove_snap_pattern() {
    pattern="$1"
    if ! command -v snap &>/dev/null; then
        echo "⚠️  Snap is not installed. Skipping pattern: $pattern"
        return
    fi
    echo "🔍 Looking for snaps matching: $pattern"
    snap list | awk -v p="$pattern" '$1 ~ p {print $1}' | while read -r snapname; do
        echo "🧹 Removing: $snapname"
        sudo snap remove "$snapname" || true
    done
}

# Remove common Snap packages (all versions)
remove_snap_pattern "^firefox"
remove_snap_pattern "^snap-store"
remove_snap_pattern "^snapd-desktop-integration"
remove_snap_pattern "^firmware-updater"
remove_snap_pattern "^gtk-common-themes"
remove_snap_pattern "^bare"
remove_snap_pattern "^core[0-9]*"       # core, core18, core20, core22 etc.
remove_snap_pattern "^gnome-[0-9]+"     # gnome-41-2204, gnome-45-21244 etc.
remove_snap_pattern "^snapd"

# Disable and remove snapd
echo "🛑 Disabling snapd daemon..."
sudo systemctl stop snapd || true
sudo systemctl disable snapd || true
sudo systemctl mask snapd || true

echo "🧹 Purging snapd..."
sudo apt purge snapd -y
sudo apt-mark hold snapd

# Remove residual Snap directories
echo "🧹 Removing residual Snap directories..."
sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

# Block Snap from reinstalling
echo "🚫 Preventing Snap from being reinstalled..."
sudo mkdir -p /etc/apt/preferences.d
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref > /dev/null
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF

# Refresh package lists
echo "🔄 Running apt update..."
sudo apt update

echo "✅ Snap has been removed and blocked from reinstalling."

# Optional Browser Installation
# Ensure required tools are installed
echo "🛠️ Ensuring required tools (wget, curl) are available..."

if ! command -v wget &>/dev/null; then
    echo "📦 Installing wget..."
    sudo apt update && sudo apt install wget -y
fi

if ! command -v curl &>/dev/null; then
    echo "📦 Installing curl..."
    sudo apt update && sudo apt install curl -y
fi

read -p "🌐 Do you want to install a browser now? (firefox/brave/none): " browser_choice

case "$browser_choice" in
    firefox)
        echo "🦊 Installing Firefox (APT version)..."
        sudo install -d -m 0755 /etc/apt/keyrings
        wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
        echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
        echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | sudo tee /etc/apt/preferences.d/mozilla
        sudo apt update && sudo apt install firefox -y
        ;;
    brave)
        echo "🦁 Installing Brave browser..."
        echo "🧼 Cleaning any conflicting Brave keyrings..."
        sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
        sudo rm -f /etc/apt/keyrings/brave-browser-archive-keyring.gpg
        sudo rm -f /usr/share/keyrings/brave-browser-archive-keyring.gpg

        echo "🔐 Setting up Brave APT repository..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://brave-browser-apt-release.s3.brave.com/brave-core.asc \
        | gpg --dearmor | sudo tee /etc/apt/keyrings/brave-browser-archive-keyring.gpg > /dev/null

        echo "deb [signed-by=/etc/apt/keyrings/brave-browser-archive-keyring.gpg] \
        https://brave-browser-apt-release.s3.brave.com/ stable main" \
        | sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null

        sudo apt update && sudo apt install brave-browser -y
        ;;
    none|*)
        echo "❎ Skipping browser installation."
        ;;
esac

echo "🎉 Done."