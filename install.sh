#!/usr/bin/env bash
#
# Design Workflow Installer
# 安裝 Design Workflow Skills & Commands 到目標專案
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
TARGET_DIR=""
FORCE=false
UPDATE=false
INCLUDE_DOCS=false

usage() {
    cat << EOF
Design Workflow Installer

Usage: ./install.sh [OPTIONS] [TARGET_DIR]

Options:
    -f, --force       覆蓋現有檔案
    -u, --update      更新模式（只更新 commands，保留 skills 自訂內容）
    -d, --docs        同時安裝工作流文件到 docs/
    -h, --help        顯示說明

Arguments:
    TARGET_DIR        目標專案目錄（預設：當前目錄）

Examples:
    ./install.sh                      # 安裝到當前目錄
    ./install.sh /path/to/project     # 安裝到指定目錄
    ./install.sh --docs               # 安裝並包含文件
    ./install.sh --update             # 更新現有安裝
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

check_prerequisites() {
    log INFO "檢查前置條件..."

    # 檢查 Claude CLI
    if ! command -v claude &> /dev/null; then
        log WARN "Claude Code 未安裝"
        log INFO "安裝方式: npm install -g @anthropic-ai/claude-code"
    fi
}

install_commands() {
    local target="$1"
    local cmd_dir="$target/.claude/commands"

    log INFO "安裝 Commands..."

    mkdir -p "$cmd_dir"

    for cmd_file in "$SCRIPT_DIR/commands/"*.md; do
        local filename=$(basename "$cmd_file")
        local target_file="$cmd_dir/$filename"

        if [[ -f "$target_file" && "$FORCE" != true && "$UPDATE" != true ]]; then
            log WARN "跳過已存在: $filename（使用 --force 覆蓋）"
        else
            cp "$cmd_file" "$target_file"
            log OK "已安裝 command: $filename"
        fi
    done
}

install_skills() {
    local target="$1"
    local skills_dir="$target/.claude/skills"

    log INFO "安裝 Skills..."

    mkdir -p "$skills_dir"

    for skill_dir in "$SCRIPT_DIR/skills/"*/; do
        local skill_name=$(basename "$skill_dir")
        local target_skill="$skills_dir/$skill_name"

        if [[ -d "$target_skill" && "$UPDATE" == true ]]; then
            # Update 模式：只更新 SKILL.md 和 references，保留自訂內容
            log INFO "更新 skill: $skill_name"
            cp "$skill_dir/SKILL.md" "$target_skill/" 2>/dev/null || true
            if [[ -d "$skill_dir/references" ]]; then
                cp -r "$skill_dir/references/"* "$target_skill/references/" 2>/dev/null || true
            fi
            if [[ -d "$skill_dir/assets" ]]; then
                cp -r "$skill_dir/assets/"* "$target_skill/assets/" 2>/dev/null || true
            fi
            log OK "已更新 skill: $skill_name"
        elif [[ -d "$target_skill" && "$FORCE" != true ]]; then
            log WARN "跳過已存在: $skill_name（使用 --force 覆蓋）"
        else
            cp -r "$skill_dir" "$target_skill"
            log OK "已安裝 skill: $skill_name"
        fi
    done
}

install_docs() {
    local target="$1"
    local docs_dir="$target/docs/workflow"

    if [[ "$INCLUDE_DOCS" != true ]]; then
        return 0
    fi

    log INFO "安裝文件..."

    mkdir -p "$docs_dir"

    cp "$SCRIPT_DIR/docs/design-workflow.md" "$docs_dir/"
    log OK "已安裝 design-workflow.md"
}

create_readme() {
    local target="$1"
    local readme="$target/.claude/DESIGN-WORKFLOW.md"

    cat > "$readme" << 'EOF'
# Design Workflow

## 可用指令

| 指令 | 說明 |
|------|------|
| `/design.prototype` | 從 spec.md 產出 HTML prototype |
| `/design.audit` | 比對 prototype 與 spec 差異 |
| `/design.mapping` | 建立 Figma 對應表 |
| `/design.verify` | 驗證設計引用完整性 |

## 工作流程

```
1. /design.prototype  → prototype/*.html
         ↓
2. /design.audit      → audit-report.md
         ↓
3. Push to Figma      → (html.to.design)
         ↓
4. /design.mapping    → design.md
         ↓
5. /design.verify     → 驗證通過
```

## 前置條件

- spec.md 已完成（Phase 1）
- plan.md 已完成（Phase 2）
- Figma MCP Server 已連接（Step 3-4 需要）

## 相關 Skills

- `design-system` - 主要設計規範
- `design-audit` - 審查規則
- `design-prototype` - Prototype 規範

---

*由 [design-workflow](https://github.com/ci-yang/design-workflow) 安裝*
EOF

    log OK "已建立 .claude/DESIGN-WORKFLOW.md"
}

# 解析參數
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -u|--update)
            UPDATE=true
            shift
            ;;
        -d|--docs)
            INCLUDE_DOCS=true
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

# 設定目標目錄
if [[ -z "$TARGET_DIR" ]]; then
    TARGET_DIR="$(pwd)"
fi

# 轉為絕對路徑
TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
    log ERROR "目標目錄不存在: $TARGET_DIR"
    exit 1
}

# 確認不是安裝到自己
if [[ "$TARGET_DIR" == "$SCRIPT_DIR" ]]; then
    log ERROR "不能安裝到 design-workflow 本身"
    exit 1
fi

# 執行安裝
echo ""
echo "╔══════════════════════════════════════╗"
echo "║     Design Workflow Installer        ║"
echo "╚══════════════════════════════════════╝"
echo ""

check_prerequisites

install_commands "$TARGET_DIR"
install_skills "$TARGET_DIR"
install_docs "$TARGET_DIR"
create_readme "$TARGET_DIR"

echo ""
log OK "安裝完成！"
echo ""
echo "已安裝指令："
echo "  /design.prototype  - 產出 HTML Prototype"
echo "  /design.audit      - 審查設計 vs 規格"
echo "  /design.mapping    - 建立 Figma 對應表"
echo "  /design.verify     - 驗證設計引用"
echo ""
echo "開始使用："
echo "  cd $TARGET_DIR"
echo "  claude"
echo "  > /design.prototype"
echo ""
