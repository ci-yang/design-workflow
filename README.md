# Design Workflow

**前端設計工作流程** - Claude Code Skills & Commands for Design-to-Development

將設計流程標準化：從 spec 到 HTML Prototype，再到 Figma 整合，最後驗證開發任務的設計引用。

## 特色

- **Prototype 產出** - 從 spec.md 自動產出可互動 HTML 原型
- **設計審查** - 比對 Prototype vs Spec，找出差異
- **Figma 整合** - 建立 Prototype 與 Figma 的對應表
- **驗證機制** - 確保 plan.md 和 tasks.md 正確引用設計資源
- **可自訂規則** - Skills 提供參考文件和模板

## 工作流程

```
┌─────────────────────────────────────────────────────────────────┐
│                        Design Phase                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Prototype      Step 2: Audit       Step 3: Figma       │
│  ┌──────────────┐      ┌─────────────┐     ┌─────────────────┐  │
│  │ /design.     │  →   │ /design.    │  →  │ Push to Figma   │  │
│  │ prototype    │      │ audit       │     │ via MCP         │  │
│  └──────────────┘      └─────────────┘     └─────────────────┘  │
│         ↓                    ↓                     ↓             │
│  prototype/*.html    audit-report.md         Figma File         │
│                                                    ↓             │
│  Step 4: Mapping       Step 5: Verify                           │
│  ┌──────────────────┐  ┌─────────────────────────────────────┐  │
│  │ /design.mapping  │  │ /design.verify plan|tasks           │  │
│  └──────────────────┘  └─────────────────────────────────────┘  │
│         ↓                           ↓                            │
│     design.md              驗證通過 / 自動修復                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 快速安裝

### 方式 1: Clone 後安裝

```bash
git clone https://github.com/ci-yang/design-workflow.git
cd design-workflow
./install.sh /path/to/your/project
```

### 方式 2: 一行安裝

```bash
curl -fsSL https://raw.githubusercontent.com/ci-yang/design-workflow/main/install.sh | bash -s -- /path/to/project
```

### 安裝選項

```bash
./install.sh                      # 基本安裝
./install.sh --docs               # 包含工作流文件
./install.sh --force              # 覆蓋現有檔案
./install.sh --update             # 更新模式（保留自訂內容）
```

## 指令說明

### `/design.prototype`

從 spec.md 產出 HTML Prototype。

```bash
/design.prototype              # 自動偵測當前 feature
/design.prototype specs/001    # 指定 feature 路徑
```

**產出：**
```
specs/{feature}/design/
├── prototype/
│   ├── 01-landing.html
│   ├── 02-dashboard.html
│   └── ...
└── design-spec.md
```

### `/design.audit`

比對 Prototype 與 spec.md 差異。

```bash
/design.audit
```

**產出：** `audit-report.md` - 包含設計額外、規格遺漏等分析

### `/design.mapping`

建立 Figma 對應表（需先推送到 Figma）。

```bash
/design.mapping https://figma.com/design/xxx/yyy
```

**產出：** `design.md` - Figma Node ID 對應表

### `/design.verify`

驗證設計整合完整性。

```bash
/design.verify              # 驗證全部
/design.verify plan         # 只驗證 plan.md
/design.verify tasks        # 只驗證 tasks.md
/design.verify --fix        # 自動修復
```

## 前置條件

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- spec.md（Phase 1 產出）
- plan.md（Phase 2 產出，驗證時需要）
- Figma MCP Server（Step 3-4 需要）

## 目錄結構

安裝後的專案結構：

```
your-project/
└── .claude/
    ├── commands/
    │   ├── design.prototype.md
    │   ├── design.audit.md
    │   ├── design.mapping.md
    │   └── design.verify.md
    ├── skills/
    │   ├── design-system/
    │   │   ├── SKILL.md
    │   │   ├── references/
    │   │   │   ├── ui-ux-guidelines.md
    │   │   │   ├── prototype-patterns.md
    │   │   │   ├── audit-rules.md
    │   │   │   ├── figma-mapping.md
    │   │   │   └── verification-rules.md
    │   │   └── assets/
    │   │       ├── audit-report.template.md
    │   │       └── design.md.template
    │   ├── design-audit/
    │   │   ├── SKILL.md
    │   │   └── references/
    │   └── design-prototype/
    │       ├── SKILL.md
    │       └── references/
    └── DESIGN-WORKFLOW.md
```

## 自訂規則

### 修改 Prototype 樣式

編輯 `skills/design-system/references/prototype-patterns.md`

### 修改審查規則

編輯 `skills/design-system/references/audit-rules.md`

### 修改報告模板

編輯 `skills/design-system/assets/audit-report.template.md`

## 與 spec-kit 整合

Design Workflow 設計為 [spec-kit](https://github.com/anthropics/spec-kit) 的 Phase 2.5：

```bash
# Phase 1: Specification
/speckit.specify

# Phase 2: Planning
/speckit.plan

# Phase 2.5: Design
/design.prototype
/design.audit
# Push to Figma
/design.mapping <figma-url>
/design.verify --fix

# Phase 3-4: Review & Tasks
/speckit.tasks

# Phase 5: Implementation
/speckit.implement
```

## 貢獻

歡迎提交 Issue 和 PR！

## 授權

MIT License

---

*Design Phase 工作流程，讓設計到開發無縫銜接*
