#!/bin/bash

# Complete Ubuntu Setup Script with Options
# Installs system tools, ROS 2 Humble, GitHub Desktop, Google Chrome, and VS Code

set -e  # Exit on any error

echo "========================================="
echo "Ubuntu Setup Script with Options"
echo "========================================="

# Function to ask yes/no questions
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

echo "This script will install various packages. You can choose what to install."
echo ""

# Ask user preferences
INSTALL_SYSTEM_TOOLS=false
INSTALL_ROS2=false
INSTALL_GITHUB_DESKTOP=false
INSTALL_CHROME=false
INSTALL_VSCODE=false

if ask_yes_no "Install System Tools (hardinfo, synaptic, pavucontrol, thunar, thunar-archive-plugin)?"; then
    INSTALL_SYSTEM_TOOLS=true
fi

if ask_yes_no "Install ROS 2 Humble Desktop?"; then
    INSTALL_ROS2=true
fi

if ask_yes_no "Install GitHub Desktop?"; then
    INSTALL_GITHUB_DESKTOP=true
fi

if ask_yes_no "Install Google Chrome?"; then
    INSTALL_CHROME=true
fi

if ask_yes_no "Install Visual Studio Code?"; then
    INSTALL_VSCODE=true
fi

echo ""
echo "========================================="
echo "Installation Summary:"
echo "System Tools: $($INSTALL_SYSTEM_TOOLS && echo "Yes" || echo "No")"
echo "ROS 2 Humble: $($INSTALL_ROS2 && echo "Yes" || echo "No")"
echo "GitHub Desktop: $($INSTALL_GITHUB_DESKTOP && echo "Yes" || echo "No")"
echo "Google Chrome: $($INSTALL_CHROME && echo "Yes" || echo "No")"
echo "Visual Studio Code: $($INSTALL_VSCODE && echo "Yes" || echo "No")"
echo "========================================="
echo ""

if ask_yes_no "Continue with installation?"; then
    echo "Starting installation..."
else
    echo "Installation cancelled."
    exit 0
fi

# Update system first
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

if [ "$INSTALL_SYSTEM_TOOLS" = true ]; then
    echo "========================================="
    echo "Installing System Tools"
    echo "========================================="
    sudo apt install -y hardinfo synaptic pavucontrol thunar thunar-archive-plugin
    echo "✓ System tools installed successfully"
fi

if [ "$INSTALL_ROS2" = true ]; then
    echo "========================================="
    echo "Setting up ROS 2 Humble Installation"
    echo "========================================="

    # Set locale
    echo "Setting up locale..."
    sudo apt update && sudo apt install -y locales
    sudo locale-gen en_US en_US.UTF-8
    sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
    export LANG=en_US.UTF-8

    # Setup Sources
    echo "Setting up ROS 2 repositories..."
    sudo apt install -y software-properties-common
    sudo add-apt-repository universe -y

    # Install curl and setup ROS 2 apt source
    sudo apt update && sudo apt install -y curl
    export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F\" '{print $4}')
    curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo $VERSION_CODENAME)_all.deb"
    sudo dpkg -i /tmp/ros2-apt-source.deb

    # Install ROS 2 packages
    echo "Installing ROS 2 Humble..."
    sudo apt update
    sudo apt upgrade -y

    # Desktop Install (Recommended): ROS, RViz, demos, tutorials
    sudo apt install -y ros-humble-desktop

    # Development tools
    sudo apt install -y ros-dev-tools

    # Setup ROS 2 environment for current user
    echo "# ROS 2 Humble setup" >> ~/.bashrc
    echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc

    echo "✓ ROS 2 Humble installed successfully"
fi

if [ "$INSTALL_GITHUB_DESKTOP" = true ]; then
    echo "========================================="
    echo "Installing GitHub Desktop"
    echo "========================================="
    
    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    sudo apt update && sudo apt install -y github-desktop
    
    echo "✓ GitHub Desktop installed successfully"
fi

if [ "$INSTALL_CHROME" = true ]; then
    echo "========================================="
    echo "Installing Google Chrome"
    echo "========================================="
    
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    sudo apt update && sudo apt install -y google-chrome-stable
    
    echo "✓ Google Chrome installed successfully"
fi

if [ "$INSTALL_VSCODE" = true ]; then
    echo "========================================="
    echo "Installing Visual Studio Code"
    echo "========================================="
    
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update && sudo apt install -y code
    
    echo "✓ Visual Studio Code installed successfully"
fi

echo "========================================="
echo "Final cleanup"
echo "========================================="

# Clean up temporary files
rm -f /tmp/ros2-apt-source.deb
rm -f packages.microsoft.gpg

echo "========================================="
echo "Installation Complete!"
echo "========================================="
echo ""
echo "Installed packages:"

if [ "$INSTALL_SYSTEM_TOOLS" = true ]; then
    echo "✓ System Tools: hardinfo, synaptic, pavucontrol, thunar, thunar-archive-plugin"
fi

if [ "$INSTALL_ROS2" = true ]; then
    echo "✓ ROS 2 Humble Desktop (full installation)"
    echo "✓ ROS 2 Development Tools"
fi

if [ "$INSTALL_GITHUB_DESKTOP" = true ]; then
    echo "✓ GitHub Desktop"
fi

if [ "$INSTALL_CHROME" = true ]; then
    echo "✓ Google Chrome"
fi

if [ "$INSTALL_VSCODE" = true ]; then
    echo "✓ Visual Studio Code"
fi

echo ""

if [ "$INSTALL_ROS2" = true ]; then
    echo "ROS 2 environment has been added to ~/.bashrc"
    echo "Please restart your terminal or run 'source ~/.bashrc' to load ROS 2 environment"
    echo ""
    echo "You can test ROS 2 installation with:"
    echo "  Terminal 1: ros2 run demo_nodes_cpp talker"
    echo "  Terminal 2: ros2 run demo_nodes_py listener"
    echo ""
fi

echo "Reboot recommended to ensure all changes take effect."
