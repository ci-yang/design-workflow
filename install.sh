#!/usr/bin/env bash
#
# Design Workflow Plugin Installer
# 安裝 Design Workflow Plugin 到 Claude Code
#

set -euo pipefail

# 顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 取得腳本所在目錄
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 預設值
INSTALL_MODE="plugin"  # plugin 或 legacy
FORCE=false

usage() {
    cat << EOF
Design Workflow Plugin Installer

Usage: ./install.sh [OPTIONS] [TARGET_DIR]

Options:
    --plugin          安裝為 Claude Code Plugin（預設）
    --legacy          安裝為傳統 .claude 結構（相容舊版）
    -f, --force       覆蓋現有檔案
    -h, --help        顯示說明

Plugin 安裝（推薦）:
    ./install.sh                      # 安裝到 ~/.claude/plugins/
    ./install.sh --plugin             # 同上

Legacy 安裝（相容舊版）:
    ./install.sh --legacy /path/to/project   # 安裝到專案 .claude/
EOF
}

log() {
    local level=$1
    shift
    local msg="$*"
    case $level in
        INFO)  echo -e "${BLUE}[INFO]${NC} $msg" ;;
        OK)    echo -e "${GREEN}[OK]${NC} $msg" ;;
        WARN)  echo -e "${YELLOW}[WARN]${NC} $msg" ;;
        ERROR) echo -e "${RED}[ERROR]${NC} $msg" ;;
    esac
}

install_as_plugin() {
    local plugins_dir="${HOME}/.claude/plugins"
    local plugin_dir="$plugins_dir/design-workflow"

    log INFO "安裝為 Claude Code Plugin..."

    # 建立 plugins 目錄
    mkdir -p "$plugins_dir"

    # 檢查是否已存在
    if [[ -d "$plugin_dir" && "$FORCE" != true ]]; then
        log WARN "Plugin 已存在: $plugin_dir"
        log INFO "使用 --force 覆蓋，或手動刪除後重試"
        exit 1
    fi

    # 移除舊版（如果存在）
    rm -rf "$plugin_dir"

    # 複製整個 plugin
    cp -r "$SCRIPT_DIR" "$plugin_dir"

    # 移除不需要的檔案
    rm -f "$plugin_dir/install.sh"
    rm -rf "$plugin_dir/.git"

    log OK "Plugin 安裝完成！"
    echo ""
    echo "位置: $plugin_dir"
    echo ""
    echo "可用指令："
    echo "  /design.prototype  - 產出 HTML Prototype"
    echo "  /design.audit      - 審查設計 vs 規格"
    echo "  /design.mapping    - 建立 Figma 對應表"
    echo "  /design.verify     - 驗證設計引用"
    echo ""
    echo "重啟 Claude Code 以載入 Plugin"
}

install_legacy() {
    local target="$1"

    log INFO "安裝為 Legacy 結構到: $target"

    # 建立目錄
    mkdir -p "$target/.claude/commands"
    mkdir -p "$target/.claude/skills"

    # 複製 commands
    cp "$SCRIPT_DIR/commands/"*.md "$target/.claude/commands/"
    log OK "已安裝 commands"

    # 複製 skills
    cp -r "$SCRIPT_DIR/skills/"* "$target/.claude/skills/"
    log OK "已安裝 skills"

    # 建立說明文件
    cat > "$target/.claude/DESIGN-WORKFLOW.md" << 'EOF'
# Design Workflow

## 可用指令

| 指令 | 說明 |
|------|------|
| `/design.prototype` | 從 spec.md 產出 HTML prototype |
| `/design.audit` | 比對 prototype 與 spec 差異 |
| `/design.mapping` | 建立 Figma 對應表 |
| `/design.verify` | 驗證設計引用完整性 |

*由 [design-workflow](https://github.com/ci-yang/design-workflow) 安裝*
EOF

    log OK "Legacy 安裝完成！"
    echo ""
    echo "位置: $target/.claude/"
    echo ""
}

# 解析參數
TARGET_DIR=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --plugin)
            INSTALL_MODE="plugin"
            shift
            ;;
        --legacy)
            INSTALL_MODE="legacy"
            shift
            ;;
        -f|--force)
            FORCE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            log ERROR "未知選項: $1"
            usage
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

# 執行安裝
echo ""
echo "╔══════════════════════════════════════╗"
echo "║   Design Workflow Plugin Installer   ║"
echo "╚══════════════════════════════════════╝"
echo ""

if [[ "$INSTALL_MODE" == "plugin" ]]; then
    install_as_plugin
else
    if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$(pwd)"
    fi
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        log ERROR "目標目錄不存在: $TARGET_DIR"
        exit 1
    }
    install_legacy "$TARGET_DIR"
fi
