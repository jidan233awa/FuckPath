#!/bin/bash

echo "   _____ _   _  ____ _  __  ____   _  _____ _   _ "
echo "  |  ___| | | |/ ___| |/ / |  _ \ / \|_   _| | | | "
echo "  | |_  | | | | |   | ' /  | |_) / _ \ | | | |_| | "
echo "  |  _| | |_| | |___| . \  |  __/ ___ \| | |  _  | "
echo "  |_|    \___/ \____|_|\_\ |_| /_/   \_\_| |_| |_| "
echo ""

progress_bar() {
    local duration=$1
    local message=$2
    if ! command -v tput &> /dev/null || ! command -v bc &> /dev/null; then
        echo "$message..."
        sleep "$duration"
        return
    fi
    local columns=$(tput cols)
    local width=$((columns - 10))
    local progress=0
    local sleep_duration=$(echo "$duration / $width" | bc -l)

    echo -n "$message [
    for ((i=0; i<width; i++)); do
        echo -n "#"
        sleep $sleep_duration
    done
    echo "] 100%"
}

CONFIG_DIR="$HOME/.config/fuck"
CONFIG_FILE="$CONFIG_DIR/settings"
DEFAULT_COMMAND="fuck"
COMMAND="$DEFAULT_COMMAND"

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source "$CONFIG_FILE"
        if [ -z "$LANG" ]; then
            LANG="zh"
        fi
    fi
}

save_config() {
    if ! mkdir -p "$CONFIG_DIR" 2>/dev/null; then
        echo "$msg_config_dir_error $CONFIG_DIR" >&2
        return 1
    fi
    
    if [ ! -w "$CONFIG_DIR" ]; then
        echo "$msg_config_write_error $CONFIG_DIR" >&2
        return 1
    fi
    
    if echo "COMMAND='$COMMAND'" > "$CONFIG_FILE" && echo "LANG='$LANG'" >> "$CONFIG_FILE"; then
        echo "$msg_config_saved"
    else
        echo "$msg_config_save_error" >&2
        return 1
    fi
}

change_command_name() {
    read -p "$msg_enter_new_cmd" new_cmd
    if [ ${#new_cmd} -ge 1 ] && [ ${#new_cmd} -le 10 ]; then
        if echo "$new_cmd" | grep -q '[;&|`$(){}\[\]<>"'\'']'; then
            echo "$msg_invalid_cmd"
        elif [ "$new_cmd" != "${new_cmd// /}" ]; then
            echo "$msg_invalid_cmd"
        else
            COMMAND="$new_cmd"
            save_config
            echo "$msg_cmd_updated '$COMMAND'"
        fi
    else
        echo "$msg_invalid_cmd"
    fi
    read -p "$msg_press_enter"
}

show_about_info() {
    clear
    echo "$msg_about_github"
    echo "$msg_about_qq"
    read -p "$msg_press_enter"
}

show_settings_menu() {
    local settings_options=("$msg_change_cmd" "$msg_about" "$msg_back")
    
    while true; do
        clear
        echo "$msg_settings"
        echo "----------------"
        select_option "${settings_options[@]}"
        local choice=$?
        case $choice in
            0) change_command_name;;
            1) show_about_info;;
            2) break;;
        esac
    done
}

check_dependencies() {
    local missing_deps=()
    
    local tput_path bc_path
    tput_path=$(command -v tput 2>/dev/null)
    bc_path=$(command -v bc 2>/dev/null)
    
    if [ -z "$tput_path" ]; then
        missing_deps+=("tput")
    fi
    
    if [ -z "$bc_path" ]; then
        missing_deps+=("bc")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "$msg_dep_error: ${missing_deps[*]}"
        
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case $ID in
                ubuntu|debian)
                    echo "$msg_dep_install_debian"
                    ;;
                fedora|centos|rhel)
                    echo "$msg_dep_install_redhat"
                    ;;
                arch)
                    echo "$msg_dep_install_arch"
                    ;;
                *)
                    echo "$msg_dep_manual"
                    ;;
            esac
        else
            echo "$msg_dep_manual"
        fi
        exit 1
    fi
}

select_option() {
    ESC=$( printf "\033" )
    cursor_blink_on()  { printf "$ESC[?25h"; }
    cursor_blink_off() { printf "$ESC[?25l"; }
    cursor_to()        { printf "$ESC[$1;${2:-1}H"; }
    print_option()     { printf "   $1 "; }
    print_selected()   { printf "$ESC[7m > $1 $ESC[27m"; }
    get_cursor_row()   { IFS=';' read -sdR -p $'\E[6n' ROW COL; echo ${ROW#*[}; }
    key_input()        { read -s -n3 key 2>/dev/null >&2
                         if [[ $key = $ESC[A ]]; then echo up;    fi
                         if [[ $key = $ESC[B ]]; then echo down;  fi
                         if [[ $key = "" ]];  then echo enter; fi; }

    for ((i=0; i<$#; i++)); do
        echo
    done

    local lastrow=`get_cursor_row`
    local startrow=$(($lastrow - $#))

    cleanup_terminal() {
        cursor_blink_on
        stty echo
        printf '\n'
        exit 130
    }
    trap cleanup_terminal 2 15 1
    cursor_blink_off

    local selected=0
    while true; do
        local idx=0
        for opt; do
            cursor_to $(($startrow + $idx))
            if [ $idx -eq $selected ]; then
                print_selected "$opt"
            else
                print_option "$opt"
            fi
            ((idx++))
        done

        case `key_input` in
            enter) break;;
            up)    ((selected--));
                   if [ $selected -lt 0 ]; then selected=$(($# - 1)); fi;;
            down)  ((selected++));
                   if [ $selected -ge $# ]; then selected=0; fi;;
        esac
    done

    cursor_to $lastrow
    printf "\n"
    cursor_blink_on

    return $selected
}

load_config

if [ -z "$LANG" ] || [ "$LANG" = "" ]; then
    echo "语言/Language（使用方向键并按回车/use arrow keys and press Enter）:"
    echo "默认/Default: 中文"
    lang_options=("English" "中文")
    select_option "${lang_options[@]}"
    lang_choice=$?

    if [ $lang_choice -eq 0 ]; then
        LANG="en"
    else
        LANG="zh"
    fi
    save_config
fi

if [ "$LANG" = "zh" ]; then
    msg_root="此脚本必须以 root 身份运行。"
    msg_action="请使用上下箭头选择一个操作，然后按 Enter 键："
    msg_install="安装"
    msg_uninstall="卸载"
    msg_exit="退出"
    msg_settings="设置"
    msg_change_cmd="更改命令名称"
    msg_about="关于"
    msg_back="返回"
    msg_about_github="GitHub：https://github.com/jidan233awa/fuckpath"
    msg_about_qq="QQ交流群：565813851"
    msg_enter_new_cmd="请输入新的命令名称 (1-10 个字母或汉字): "
    msg_cmd_updated="命令已更新为"
    msg_invalid_cmd="无效的命令名称。请确保它是 1-10 个字符长，并且只包含字母或汉字。"
    msg_config_saved="配置已保存。"
    msg_press_enter="按 Enter 键继续..."
    msg_invalid_choice="无效的选择。"
    msg_installing="正在安装脚本..."
    msg_complete="安装完成。您现在可以使用命令了。"
    msg_not_found_local="错误：在当前目录中未找到脚本。"
    msg_downloading="在本地未找到脚本，正在尝试下载..."
    msg_testing_speed="正在测试多个源的下载速度..."
    msg_testing_speeds="正在测试下载速度..."
    msg_github_speed="GitHub 速度："
    msg_cdn_speed="CDN 速度："
    msg_github_faster="GitHub 更快，正在从 GitHub 下载..."
    msg_cdn_faster="CDN 更快，正在从 CDN 下载..."
    msg_trying_github="尝试使用 GitHub 作为备用源..."
    msg_trying_cdn="尝试使用 CDN 作为备用源..."
    msg_download_failed="下载失败：%s。正在尝试备用源..."
    msg_download_error="错误：无法下载脚本：%s"
    msg_download_success="脚本下载成功。"
    
    msg_uninstalling="正在卸载脚本..."
    msg_uninstall_complete="卸载完成。"
    msg_not_found_system="错误：未找到已安装的命令。"
    msg_dep_error="错误：缺少必要的依赖项"
    msg_dep_install_debian="在 Debian/Ubuntu 上，请运行：sudo apt-get install -y ncurses-bin bc"
    msg_dep_install_redhat="在 Fedora/CentOS/RHEL 上，请运行：sudo yum install -y ncurses bc || sudo dnf install -y ncurses bc"
    msg_dep_install_arch="在 Arch Linux 上，请运行：sudo pacman -S --noconfirm ncurses bc"
    msg_dep_manual="请使用您系统的包管理器手动安装它们。"
    msg_no_permission_bin="错误：没有对 /usr/local/bin 目录的写入权限。"
    msg_config_dir_error="警告：无法创建配置目录"
    msg_config_write_error="警告：没有配置目录的写入权限"
    msg_config_save_error="警告：配置保存失败"
else
    msg_root="This script must be run as root."
    msg_action="Select an action using arrow keys and press Enter:"
    msg_install="Install"
    msg_uninstall="Uninstall"
    msg_exit="Exit"
    msg_settings="Settings"
    msg_change_cmd="Change Command Name"
    msg_about="About"
    msg_back="Back"
    msg_about_github="GitHub: https://github.com/jidan233awa/fuckpath"
    msg_about_qq="QQ Group: 565813851"
    msg_enter_new_cmd="Enter the new command name (1-10 letters or Chinese characters): "
    msg_cmd_updated="Command updated to"
    msg_invalid_cmd="Invalid command name. Please ensure it is 1-10 characters long and contains only letters or Chinese characters."
    msg_config_saved="Configuration saved."
    msg_press_enter="Press Enter to continue..."
    msg_invalid_choice="Invalid choice."
    msg_installing="Installing script..."
    msg_complete="Installation complete. You can now use the command."
    msg_not_found_local="Error: script not found in the current directory."
    msg_downloading="Script not found locally, attempting to download..."
    msg_testing_speed="Testing download speed from multiple sources..."
    msg_testing_speeds="Testing download speeds..."
    msg_github_speed="GitHub Speed:"
    msg_cdn_speed="CDN Speed:"
    msg_github_faster="GitHub is faster, downloading from GitHub..."
    msg_cdn_faster="CDN is faster, downloading from CDN..."
    msg_trying_github="Trying GitHub as alternative..."
    msg_trying_cdn="Trying CDN as alternative..."
    msg_download_failed="Download failed: %s. Trying alternative source..."
    msg_download_error="Error: Failed to download script: %s"
    msg_download_success="Script downloaded successfully."
    
    msg_uninstalling="Uninstalling script..."
    msg_uninstall_complete="Uninstallation complete."
    msg_not_found_system="Error: command is not installed."
    msg_dep_error="Error: Missing required dependencies"
    msg_dep_install_debian="On Debian/Ubuntu, please run: sudo apt-get install -y ncurses-bin bc"
    msg_dep_install_redhat="On Fedora/CentOS/RHEL, please run: sudo yum install -y ncurses bc || sudo dnf install -y ncurses bc"
    msg_dep_install_arch="On Arch Linux, please run: sudo pacman -S --noconfirm ncurses bc"
    msg_dep_manual="Please install them manually using your system's package manager."
    msg_no_permission_bin="Error: No write permission to /usr/local/bin directory."
    msg_config_dir_error="Warning: Unable to create config directory"
    msg_config_write_error="Warning: No write permission to config directory"
    msg_config_save_error="Warning: Failed to save configuration"
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "$msg_root" >&2
    exit 1
fi

check_dependencies
echo "$msg_action"

options=()
options+=("$msg_install")
options+=("$msg_uninstall")
options+=("$msg_settings")
options+=("$msg_exit")

select_option "${options[@]}"
choice=$?

case $choice in
    0)
        if [ ! -f "./$DEFAULT_COMMAND" ]; then
            echo "$msg_not_found_local '$DEFAULT_COMMAND'"
            echo "$msg_downloading $DEFAULT_COMMAND"
            
            GITHUB_URL="https://raw.githubusercontent.com/jidan233awa/FuckPath/main/fuck"
            CDN_URL="https://fp.cdn.cworld.me/fuck"
            
            test_speed() {
                local url=$1
                local result=$(curl -s -m 20 -o /dev/null -w "%{time_total}" "$url" 2>/dev/null)
                if [ $? -ne 0 ] || [ -z "$result" ] || [ "$result" = "0.000000" ]; then
                    echo "999"
                    return 1
                fi
                echo "$result"
            }
            
            echo "$msg_testing_speed"
            
            echo "$msg_github_speed"
            github_speed=$(test_speed "$GITHUB_URL")
            echo "GitHub: ${github_speed}s"
            
            echo "$msg_cdn_speed"
            cdn_speed=$(test_speed "$CDN_URL")
            echo "CDN: ${cdn_speed}s"
            
            if (( $(echo "$github_speed < $cdn_speed" | bc -l) )); then
                echo "$msg_github_faster"
                DOWNLOAD_URL="$GITHUB_URL"
            else
                echo "$msg_cdn_faster"
                DOWNLOAD_URL="$CDN_URL"
            fi
            
            error_output=$(curl -s -m 30 -o "./$DEFAULT_COMMAND" "$DOWNLOAD_URL" 2>&1) || {
                [ -f "./$DEFAULT_COMMAND" ] && rm -f "./$DEFAULT_COMMAND"
                printf "$msg_download_failed" "${error_output}" >&2
                
                if [ "$DOWNLOAD_URL" = "$GITHUB_URL" ]; then
                    echo "$msg_trying_cdn"
                    error_output_alt=$(curl -s -m 30 -o "./$DEFAULT_COMMAND" "$CDN_URL" 2>&1) || {
                        [ -f "./$DEFAULT_COMMAND" ] && rm -f "./$DEFAULT_COMMAND"
                        printf "$msg_download_error" "${error_output_alt}" >&2
                        exit 1
                    }
                else
                    echo "$msg_trying_github"
                    error_output_alt=$(curl -s -m 30 -o "./$DEFAULT_COMMAND" "$GITHUB_URL" 2>&1) || {
                        [ -f "./$DEFAULT_COMMAND" ] && rm -f "./$DEFAULT_COMMAND"
                        printf "$msg_download_error" "${error_output_alt}" >&2
                        exit 1
                    }
                fi
            }
            
            chmod +x "./$DEFAULT_COMMAND"
            echo "$msg_download_success $DEFAULT_COMMAND"
        fi
        
        if [ ! -d "/usr/local/bin" ]; then
            mkdir -p "/usr/local/bin"
        fi
        
        if [ ! -w "/usr/local/bin" ]; then
            echo "$msg_no_permission_bin" >&2
            exit 1
        fi
        
        progress_bar 2 "$msg_installing $COMMAND"
        mv "./$DEFAULT_COMMAND" "/usr/local/bin/$COMMAND"
        chmod +x "/usr/local/bin/$COMMAND"
        echo "$msg_complete '$COMMAND'"
        ;;
    1)
        if [ ! -f "/usr/local/bin/$COMMAND" ]; then
            echo "$msg_not_found_system '$COMMAND'" >&2
            exit 1
        fi
        progress_bar 2 "$msg_uninstalling $COMMAND"
        rm "/usr/local/bin/$COMMAND"
        echo "$msg_uninstall_complete"
        ;;
    2)
        show_settings_menu
        ;;
    3)
        exit 0
        ;;
    *)
        echo "$msg_invalid_choice"
        exit 1
        ;;
esac