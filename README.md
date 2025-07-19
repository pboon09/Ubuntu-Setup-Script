# Ubuntu Setup Script

Interactive installation script for Ubuntu system tools and development software.

## What it installs

Choose from:
- **System Tools**: System profiler, package manager, audio control, file manager
- **ROS 2 Humble**: Full desktop installation with development tools
- **GitHub Desktop**: Git GUI client
- **Google Chrome**: Web browser
- **Visual Studio Code**: Code editor

## How to use

1. **Make it executable**
   ```bash
   chmod +x setup.sh
   ```

2. **Run the script**
   ```bash
   ./setup.sh
   ```

3. **Answer the prompts**
   - Script asks y/n for each component
   - Shows summary of your choices
   - Confirms before installing

4. **Wait for completion**
   - Script installs selected components
   - Shows ✓ for successful installations

## After installation

- **ROS 2**: Restart terminal or run `source ~/.bashrc`
- **Test ROS 2**: 
  - Terminal 1: `ros2 run demo_nodes_cpp talker`
  - Terminal 2: `ros2 run demo_nodes_py listener`
- **Reboot recommended** for all changes to take effect

## What you may want

After running this script, you might also want to install:

### GNSS/GPS Development
- **u-center**: GNSS evaluation software for ArduSimple kits
  - Follow guide: [ArduSimple u-center Ubuntu Installation](https://www.ardusimple.com/how-to-use-ardusimple-kit-and-u-center-in-ubuntu/)
  - Required for GNSS receiver configuration and testing

### STM32 Development
- **STM32CubeIDE**: Official STM32 development environment
  - Download from [STMicroelectronics website](https://www.st.com/en/development-tools/stm32cubeide.html)
  - Includes STM32CubeMX code generator
- **STM32CubeMonitor**: Real-time monitoring tool
  - Download from [STMicroelectronics website](https://www.st.com/en/development-tools/stm32cubemonitor.html)
  - For debugging and monitoring STM32 applications

*Note: These require manual installation as they're not available in standard repositories*

## Requirements

- Ubuntu 22.04 (Jammy)
- Internet connection
- sudo privileges
