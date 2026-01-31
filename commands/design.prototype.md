---
description: 從 spec.md 產出 HTML prototype，整合 ui-ux-pro-max skill 產出設計概念後轉換為可互動的 HTML 原型。
allowed-tools: Read, Write, Glob, Bash(mkdir:*), Bash(cp:*)
argument-hint: [spec-path]
---

# /design.prototype

從 spec.md 產出 HTML prototype。

## 輸入

```
$ARGUMENTS
```

若未指定 spec-path，自動偵測當前 feature：
1. 檢查 SPECIFY_FEATURE 環境變數
2. 或讀取最近的 .specify/specs/{feature}/spec.md

## 執行流程

### Step 1: 載入 Spec

讀取 spec.md，提取：
- User Stories（頁面規劃依據）
- Acceptance Criteria（功能需求）
- Data Model（表單欄位）

### Step 2: 規劃頁面

根據 User Stories 規劃頁面清單：

```markdown
## 頁面規劃

### 主要頁面
| 編號 | 頁面 | User Story | 說明 |

### 流程頁面（多步驟流程）
| 編號 | 頁面 | User Story | 說明 |

### 狀態頁面
| 編號 | 頁面 | 說明 |
```

向使用者確認頁面規劃。

### Step 3: 產出設計概念

使用 ui-ux-pro-max skill 產出 3 個設計概念：
- 概念 A: {風格描述}
- 概念 B: {風格描述}
- 概念 C: {風格描述}

向使用者展示概念，讓使用者選擇。

### Step 4: 產出 HTML Prototype

選定概念後，產出完整 HTML：

1. 建立目錄結構：
```bash
mkdir -p .specify/specs/{feature}/design/prototype
```

2. 依照 `references/prototype-patterns.md` 產出每個頁面的 HTML

3. 使用 Tailwind CSS + 深色模式支援

4. 每個可識別元件加上 `data-component` 屬性

### Step 5: 產出設計規格

產出 `design/design-spec.md`：
- 設計概念說明
- 色彩方案
- 字體規範
- 間距系統

## 輸出

```
.specify/specs/{feature}/
└── design/
    ├── prototype/
    │   ├── 01-landing.html
    │   ├── 02-dashboard.html
    │   └── ...
    └── design-spec.md
```

## 完成訊息

```
✅ Prototype 產出完成

📁 位置: .specify/specs/{feature}/design/prototype/
📄 頁面數: {count}
🎨 設計風格: {concept-name}

下一步：
1. 在本機預覽 prototype（用 Live Server 或類似工具）
2. 執行 /design.audit 檢查與 spec 的差異
3. 使用 html.to.design 推送到 Figma
```

## 參考資源

使用 design-system skill：
- `references/ui-ux-guidelines.md` - UI/UX 設計規範
- `references/prototype-patterns.md` - HTML 模板和元件
