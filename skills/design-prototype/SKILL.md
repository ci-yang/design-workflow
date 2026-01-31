---
name: design-prototype
description: "將 UI/UX 設計轉換為 HTML Prototype 並推送到 Figma。整合 ui-ux-designer subagent 確保設計規格完整，使用 html.to.design MCP 建立可編輯的 Figma 設計稿。當使用者說「產出 prototype」「設計轉 Figma」「建立設計稿」時觸發。"
---

# Design Prototype - 設計到 Figma 工作流

## Overview

`design-prototype` 將 UI/UX 設計概念轉換為：
1. **HTML Prototype** - 可互動的原型
2. **Figma 設計稿** - 可編輯、可協作
3. **設計規格文件** - 給實作階段參考

**核心價值**：消除「設計 → 實作」之間的幻覺，讓 AI 有精確的設計規格可依循。

## 工作流程位置

```
spec-kit spec.md
       ↓
ui-ux-pro-max (產出多個設計概念)
       ↓
選擇一個設計
       ↓
design-prototype (本 Skill) ← 產出 prototype + Figma
       ↓
Figma 微調（手動）
       ↓
spec-kit implement ← 用 Figma MCP 讀取精確規格
       ↓
Production Code
```

## 前置要求

### 1. html.to.design MCP（必須）

用於把 HTML 推到 Figma。

設置方式：
1. 到 https://html.to.design/docs/mcp-tab/ 取得 MCP URL
2. 加入 `.mcp.json`：
```json
{
  "mcpServers": {
    "html-to-design": {
      "url": "YOUR_MCP_URL"
    }
  }
}
```

### 2. ui-ux-designer Subagent（建議）

用於確認設計規格。放在 `.claude/agents/ui-ux-designer.md`。

你現有的 agent 已經涵蓋：
- User research and persona development
- Wireframing and prototyping workflows
- Design system creation and maintenance
- Accessibility and inclusive design principles
- Information architecture and user flows
- Usability testing and iteration strategies

**在本 skill 中的角色**：
1. 審核設計概念是否符合 spec 需求
2. 產出 design system components 和 guidelines
3. 定義 accessibility annotations 和 requirements
4. 產出 prototype specifications for development

### 3. Figma 帳號

需要有 Figma 帳號和目標檔案。

---

## 執行流程

### Phase 1: 設計規格確認

Spawn `ui-ux-designer` subagent 來：
- 審核設計是否符合 spec 需求
- 定義 component 結構
- 確保 accessibility 標準
- 產出設計規格文件

**輸出**：`designs/{feature}/design-spec.md`

### Phase 2: HTML Prototype 產出

根據設計規格產出 HTML prototype：
- 單一 HTML 檔案（含 inline CSS/JS）
- 使用 Tailwind CDN 快速樣式
- 包含所有互動狀態（hover, active, focus）
- 標註 component 邊界（用 data 屬性）

**輸出**：`designs/{feature}/prototype/index.html`

### Phase 3: 推送到 Figma

使用 html.to.design MCP：
- 把 prototype 推到指定的 Figma 檔案
- 自動產生 Figma component
- 保留層級結構

**輸出**：Figma URL

### Phase 4: 產出整合文件

產出設計規格文件，供實作階段參考：
- Design tokens（顏色、spacing、typography）
- Component 清單和結構
- Figma node ID 對應表
- 實作注意事項

**輸出**：`designs/{feature}/implementation-guide.md`

---

## 輸入格式

### 必要輸入

1. **spec.md** - spec-kit 產出的規格文件
2. **設計概念** - ui-ux-pro-max 產出並選定的設計

### 可選輸入

- **Figma 檔案 URL** - 目標 Figma 檔案
- **Page 名稱** - 要建立設計的 page
- **Tech stack** - 目標技術棧（影響 prototype 結構）

---

## 輸出格式

```
designs/{feature}/
├── design-spec.md           # 設計規格（Phase 1）
├── prototype/
│   ├── index.html           # HTML prototype（Phase 2）
│   └── assets/              # 圖片等資源
├── figma-url.txt            # Figma 連結（Phase 3）
└── implementation-guide.md  # 實作指南（Phase 4）
```

---

## Prototype 產出規範

### HTML 結構

```html
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Feature} Prototype</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    /* Custom styles and design tokens */
  </style>
</head>
<body>
  <!-- 用 data-component 標註 component 邊界 -->
  <div data-component="header" data-figma-name="Header">
    ...
  </div>
  
  <main data-component="main-content">
    <!-- 用 data-variant 標註狀態 -->
    <button data-component="primary-button" data-variant="default">
      Submit
    </button>
  </main>
</body>
</html>
```

### 標註規範

| 屬性 | 用途 |
|------|------|
| `data-component` | Component 名稱 |
| `data-figma-name` | 對應的 Figma layer 名稱 |
| `data-variant` | 狀態變體（default, hover, active, disabled）|
| `data-token` | 使用的 design token |

---

## 設計規格文件格式

```markdown
# {Feature} Design Specification

## Design Tokens

### Colors
| Token | Value | Usage |
|-------|-------|-------|
| primary | #3B82F6 | Primary buttons, links |
| secondary | #6B7280 | Secondary text |

### Typography
| Token | Font | Size | Weight |
|-------|------|------|--------|
| heading-1 | Inter | 24px | 700 |
| body | Inter | 16px | 400 |

### Spacing
| Token | Value |
|-------|-------|
| sm | 8px |
| md | 16px |
| lg | 24px |

## Components

### Component: PrimaryButton
- States: default, hover, active, disabled
- Props: label, icon, size
- Figma path: Page > Frame > PrimaryButton

## Accessibility

- Color contrast: WCAG AA compliant
- Focus states: visible focus ring
- Screen reader: all interactive elements labeled
```

---

## 與 Figma MCP 的整合

實作階段使用 Figma Dev Mode MCP：

```bash
# Figma Desktop App 設定
Preferences → Enable local MCP Server
# Server: http://127.0.0.1:3845/mcp

# Claude Code 設定
{
  "mcpServers": {
    "figma": {
      "url": "http://127.0.0.1:3845/sse"
    }
  }
}
```

實作時 AI 可以：
- 讀取精確的 design tokens
- 取得 component 結構
- 下載 assets（icons, images）
- 對照 Figma 驗證實作

---

## 最佳實踐

### Prototype 階段

1. **保持簡單**：prototype 目的是建立 Figma 結構，不是完整功能
2. **標註清楚**：用 data 屬性標註所有 component 邊界
3. **包含狀態**：hover, active, disabled 等狀態都要有
4. **響應式**：至少包含 desktop 和 mobile 版本

### Figma 微調

1. **建立 component**：把重複元素轉成 Figma component
2. **設定 variants**：為不同狀態建立 variants
3. **定義 tokens**：用 Figma variables 定義 design tokens
4. **命名一致**：layer 命名要符合程式碼命名規範

### 實作階段

1. **先讀 Figma**：用 Figma MCP 讀取規格再寫 code
2. **對照驗證**：實作後對照 Figma 檢查
3. **回報差異**：發現無法實現的設計要回報

---

## 相關檔案

- `commands/design-prototype.md` - /design-prototype 命令
- `references/prototype-guidelines.md` - Prototype 產出指南
- `references/figma-structure.md` - Figma 結構建議
