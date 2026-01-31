---
name: design-prototype
description: "將 UI/UX 設計轉換為 HTML Prototype 並推送到 Figma"
allowed-tools:
  - Read
  - Write
  - Bash
  - Task
  - mcp__html-to-design
---

# /design-prototype

將選定的 UI/UX 設計轉換為 HTML Prototype 並推送到 Figma。

## 用法

```
/design-prototype [design-path] [--figma-url URL] [--page PAGE_NAME]
```

## 參數

| 參數 | 說明 | 預設值 |
|------|------|--------|
| `design-path` | 設計概念檔案路徑 | 自動偵測 |
| `--figma-url` | 目標 Figma 檔案 URL | 詢問使用者 |
| `--page` | Figma page 名稱 | "UI Designs" |
| `--skip-figma` | 只產出 prototype，不推 Figma | false |

## 範例

```bash
# 基本用法
/design-prototype designs/auth-page/concept-a.md

# 指定 Figma 檔案
/design-prototype designs/auth-page/concept-a.md --figma-url https://figma.com/file/xxx

# 只產 prototype
/design-prototype designs/auth-page/concept-a.md --skip-figma
```

---

## 執行流程

### Step 1: 解析輸入

```
IF design-path 未指定:
  - 搜尋 designs/ 目錄
  - 列出可用的設計概念讓使用者選擇

讀取相關檔案:
  - spec.md（如果存在）
  - 設計概念檔案
  - CLAUDE.md（專案上下文）
```

### Step 2: 設計規格確認

Spawn `ui-ux-designer` subagent：

```
Task(ui-ux-designer, "
根據以下 spec 和設計概念，產出 prototype specifications for development。

## Spec 內容
{SPEC_CONTENT}

## 設計概念
{DESIGN_CONTENT}

## 請產出以下內容（存到 designs/{feature}/design-spec.md）

### 1. User Journey Map
- 驗證設計是否涵蓋所有 user story
- 標註關鍵互動點和決策點

### 2. Design System Components
- Component 清單和層級結構
- 每個 component 的狀態（default, hover, active, disabled, focus, error）
- 可重用 component 標註

### 3. Design Tokens / Guidelines
- Colors（primary, secondary, semantic, neutral）
- Typography scale（heading, body, caption）
- Spacing system（section, component, element）
- Border radius, shadows, transitions

### 4. Accessibility Annotations
- 顏色對比度要求（WCAG AA/AAA）
- Focus states 定義
- Screen reader 標註（aria labels）
- 鍵盤導航流程

### 5. Prototype Specifications
- 需要呈現的頁面/狀態清單
- 響應式斷點（desktop: 1280px, tablet: 768px, mobile: 375px）
- 互動行為描述（hover effects, transitions, animations）
- Component 命名規範（供 Figma 和 code 對應）

Include design rationale for key decisions.
")
```

**輸出**：`designs/{feature}/design-spec.md`

### Step 3: 產出 HTML Prototype

根據設計規格產出 HTML：

```bash
# 建立目錄
mkdir -p designs/{feature}/prototype

# 產出 HTML
# 參考 references/prototype-guidelines.md
```

**HTML 結構要求**：
- 使用 Tailwind CDN
- 用 `data-component` 標註 component 邊界
- 包含所有互動狀態
- 響應式設計（desktop + mobile）

**輸出**：`designs/{feature}/prototype/index.html`

### Step 4: 推送到 Figma

使用 html.to.design MCP：

```javascript
// MCP 呼叫
mcp__html-to-design.convert({
  html: PROTOTYPE_HTML,
  figma_file_url: FIGMA_URL,
  page_name: PAGE_NAME,
  options: {
    create_components: true,
    preserve_structure: true
  }
})
```

**輸出**：Figma URL 存到 `designs/{feature}/figma-url.txt`

### Step 5: 產出實作指南

整合所有資訊產出實作指南：

```markdown
# {Feature} Implementation Guide

## Figma Reference
URL: {figma_url}

## Design Tokens
{從 design-spec.md 提取}

## Components
{列出所有 component 和對應的 Figma node}

## Implementation Notes
{特殊實作注意事項}
```

**輸出**：`designs/{feature}/implementation-guide.md`

---

## 輸出結構

```
designs/{feature}/
├── design-spec.md           # 設計規格（Step 2）
├── prototype/
│   ├── index.html           # HTML prototype（Step 3）
│   └── assets/              # 資源檔案
├── figma-url.txt            # Figma 連結（Step 4）
└── implementation-guide.md  # 實作指南（Step 5）
```

---

## 終端輸出

```
╭─────────────────────────────────────────────────────────╮
│  Design Prototype: auth-page                            │
╰─────────────────────────────────────────────────────────╯

📋 Phase 1: 設計規格確認
   → Spawning ui-ux-designer...
   ✅ 設計規格已產出: designs/auth-page/design-spec.md
   
   Components: 8 個
   Design Tokens: 12 個
   Accessibility: WCAG AA

📄 Phase 2: HTML Prototype
   → 產出 prototype...
   ✅ Prototype 已產出: designs/auth-page/prototype/index.html
   
   預覽: file:///path/to/prototype/index.html

🎨 Phase 3: 推送到 Figma
   → 連接 html.to.design MCP...
   → 推送中...
   ✅ Figma 設計稿已建立
   
   URL: https://figma.com/file/xxx?node-id=123

📝 Phase 4: 實作指南
   ✅ 實作指南已產出: designs/auth-page/implementation-guide.md

╭─────────────────────────────────────────────────────────╮
│  ✅ 完成！                                               │
│                                                         │
│  下一步:                                                 │
│  1. 在 Figma 中微調設計                                  │
│  2. 實作時使用 Figma MCP 讀取精確規格                     │
│     /spec-kit.implement --figma {figma_url}             │
╰─────────────────────────────────────────────────────────╯
```

---

## 錯誤處理

| 錯誤 | 處理方式 |
|------|----------|
| html.to.design MCP 未設定 | 顯示設定指引，或用 `--skip-figma` |
| ui-ux-designer 不存在 | 跳過 Phase 1，直接產出 prototype |
| Figma 推送失敗 | 保留 prototype，顯示手動推送指引 |

---

## 與其他工具整合

```bash
# 完整流程
/speckit.specify "用戶認證功能"      # 產出 spec
/ui-ux-pro-max specs/auth/spec.md    # 產出設計概念
/design-prototype designs/auth/       # 產出 prototype + Figma
# （在 Figma 微調）
/speckit.implement task-1            # 用 Figma MCP 實作
```
