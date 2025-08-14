# FUCK PATH

一个简单的shell工具  [[English(here)]](README_en.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)]()   [![GitHub stars](https://badgen.net/github/stars/jidan233awa/fuckpath)](https://github.com/jidan233awa/FuckPath/stargazers)   [![GitHub issues](https://img.shields.io/github/issues/jidan233awa/FuckPath)](https://github.com/jidan233awa/FuckPath/issues)   [![QQ Group](https://img.shields.io/badge/QQ群-565813851-blue.svg)](https://qm.qq.com/q/c7PQ7bwPN8)

## 核心功能

- 🚀 **极简安装**：方向键选择操作选项，支持安装/卸载/配置全流程
- 🌐 **双语切换**：启动时可选中文/英文界面，满足不同场景需求（真的有用？
- 🔍 **环境检测**：自动识别tput、bc等依赖，为Debian/Ubuntu、Fedora/CentOS、Arch等主流发行版提供安装指引
- ⚙️ **个性化命令设置**：支持1-10位中英文命令别名（默认`fuck`），避免系统命令冲突
- 💾 **配置云端同步**：用户设置自动保存至`~/.config/fuck/settings`
- 📊 **可视化进度反馈**：安装/卸载过程带有动态进度条，操作状态一目了然！

## 快速开始

### 🚀 推荐安装方式

任选以下命令快速安装（已适配国内网络环境）：

```bash
# CDN镜像源（推荐大陆用户使用）
bash <(curl -sL https://fp.cdn.cworld.me/install.sh)

# 短链接（被墙）
bash <(curl -sL https://bit.ly/FuckPath)

# GitHub地址
bash <(curl -sL https://raw.githubusercontent.com/jidan233awa/FuckPath/main/install.sh)
```

### 🔧 手动安装

适合需要自定义安装路径的高级用户：

```bash
git clone https://github.com/jidan233awa/FuckPath.git
cd FuckPath
sudo bash install.sh  # 需要root权限执行
```

4.  **导航菜单**：
    -   脚本启动后，首先使用**上下箭头**选择语言（English/中文）。
    -   在主菜单中，使用**上下箭头**选择你想要执行的操作（安装、卸载、设置、退出），然后按 **Enter** 键确认。
    -   进入“设置”菜单后，可以同样方式选择“更改命令名称”或查看“关于”信息。

## 安装脚本执行过程

安装脚本（install.sh）执行时会进行以下操作：

1. **显示欢迎界面**：展示项目的ASCII艺术标题。

2. **语言选择**：提供中文和英文两种语言选项，用户可以使用上下箭头键选择。

3. **依赖检查**：
   - 检查系统是否安装了必要的依赖（`tput`和`bc`）
   - 如果缺少依赖，会根据检测到的操作系统（Debian/Ubuntu、Fedora/CentOS/RHEL、Arch Linux）提供相应的安装命令

4. **加载配置**：
   - 从`~/.config/fuck/settings`加载已保存的配置（如自定义命令名称）
   - 如果配置文件不存在，则使用默认设置

5. **主菜单选项**：
   - **安装**：将脚本复制到`/usr/local/bin`目录并设置执行权限
     - 检查目标目录是否存在，不存在则创建
     - 检查是否有写入权限
     - 显示进度条反馈安装进度
   - **卸载**：从系统中删除已安装的命令
   - **设置**：提供更改命令名称和查看关于信息的选项
   - **退出**：退出安装程序

6. **权限检查**：
   - 验证脚本是否以root权限运行，因为需要写入系统目录

7. **配置保存**：
   - 当更改命令名称时，会将新设置保存到配置文件中

## 使用示例

安装完成后，使用您设置的命令（默认`fuck`）体验以下功能：

```bash
# 清空当前目录
fuck

# 清空指定目录
fuck /path/to/dir

# 删除整个目录（包括自身）
fuck -c
fuck /path/to/dir -c

# 神秘彩蛋（有惊喜~）
fuck crworld
```

## 联系我们

- **作者**: CRWorld
- **GitHub**: [https://github.com/jidan233awa/fuckpath](https://github.com/jidan233awa/fuckpath)
- **QQ交流群**: 565813851

## 许可证

本项目采用MIT许可证 - 详情请参阅[LICENSE](LICENSE)文件。