# FUCK PATH

A simple shell tool [[中文(这里)]](README.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)]()   [![GitHub stars](https://badgen.net/github/stars/jidan233awa/fuckpath)](https://github.com/jidan233awa/FuckPath/stargazers)   [![GitHub issues](https://img.shields.io/github/issues/jidan233awa/FuckPath)](https://github.com/jidan233awa/FuckPath/issues)   [![QQ Group](https://img.shields.io/badge/QQ%E7%BE%A4-565813851-blue.svg)](https://qm.qq.com/q/c7PQ7bwPN8)

## Core Features

- 🚀 **Minimalist Installation**: Use arrow keys to select options, supporting the entire process of installation, uninstallation, and configuration.
- 🌐 **Bilingual Switching**: Choose between Chinese/English interface at startup to meet different needs.
- 🔍 **Environment Detection**: Automatically detects dependencies like `tput` and `bc`, providing installation guidance for mainstream distributions such as Debian/Ubuntu, Fedora/CentOS, and Arch.
- ⚙️ **Personalized Command Settings**: Supports 1-10 character English/Chinese command aliases (default is `fuck`) to avoid conflicts with system commands.
- 💾 **Cloud Configuration Sync**: User settings are automatically saved to `~/.config/fuck/settings` and won't be lost after reinstalling the system.
- 📊 **Visual Progress Feedback**: The installation/uninstallation process includes a dynamic progress bar for a clear view of the operation status.

## Quick Start

### 🚀 Recommended Installation Method

Choose any of the following commands for a quick installation (adapted for domestic network environments in China):

```bash
# CDN Mirror (Recommended for users in mainland China)
bash <(curl -sL https://fp.cdn.cworld.me/install.sh)

# Short Link (Blocked)
bash <(curl -sL https://bit.ly/FuckPath)

# GitHub Address
bash <(curl -sL https://raw.githubusercontent.com/jidan233awa/FuckPath/main/install.sh)
```

### 🔧 Manual Installation

Suitable for advanced users who need to customize the installation path:

```bash
git clone https://github.com/jidan233awa/FuckPath.git
cd FuckPath
sudo bash install.sh  # Requires root privileges to execute
```

4.  **Navigation Menu**:
    -   After the script starts, first use the **up and down arrows** to select the language (English/中文).
    -   In the main menu, use the **up and down arrows** to select the operation you want to perform (Install, Uninstall, Settings, Exit), then press the **Enter** key to confirm.
    -   After entering the "Settings" menu, you can use the same method to select "Change Command Name" or view "About" information.

## Installation Script Execution Process

The installation script (install.sh) performs the following operations when executed:

1. **Display Welcome Interface**: Shows the project's ASCII art title.

2. **Language Selection**: Provides options for Chinese and English, which users can select with the up and down arrow keys.

3. **Dependency Check**:
   - Checks if the system has the necessary dependencies (`tput` and `bc`).
   - If dependencies are missing, it provides the corresponding installation commands based on the detected operating system (Debian/Ubuntu, Fedora/CentOS/RHEL, Arch Linux).

4. **Load Configuration**:
   - Loads saved configurations (like custom command names) from `~/.config/fuck/settings`.
   - If the configuration file does not exist, it uses the default settings.

5. **Main Menu Options**:
   - **Install**: Copies the script to the `/usr/local/bin` directory.
     - Checks if the target directory exists, and creates it if it doesn't.
     - Checks for write permissions.
     - Displays a progress bar to show the installation progress.
   - **Uninstall**: Removes the installed command from the system.
   - **Settings**: Provides options to change the command name and view "About" information.
   - **Exit**: Exits the installer.

6. **Permission Check**:
   - Verifies if the script is run with root privileges, as it needs to write to system directories.

7. **Configuration Save**:
   - When the command name is changed, the new setting is saved to the configuration file.

## Usage Example

After installation, use the command you set (default is `fuck`) to experience the following features:

```bash
# Clear the current directory
fuck

# Clear a specified directory
fuck /path/to/dir

# Delete the entire directory (including itself)
fuck -c
fuck /path/to/dir -c

# Mysterious Easter Egg (There's a surprise~)
fuck crworld
```

## Contact Us

- **Author**: CRWorld
- **GitHub**: [https://github.com/jidan233awa/fuckpath](https://github.com/jidan233awa/fuckpath)
- **QQ Communication Group**: 565813851

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.