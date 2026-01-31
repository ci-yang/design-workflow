# Figma Mapping

## 對應流程

### Step 1: 讀取 Prototype 檔案
掃描 `design/prototype/` 目錄：

```bash
design/prototype/
├── 01-landing.html
├── 02-dashboard.html
├── 05-login.html
└── ...
```

提取檔名清單，解析編號和頁面名稱。

### Step 2: 讀取 Figma 結構
使用 Figma MCP 讀取檔案結構：

```
Figma:get_metadata
├── fileKey: 從 URL 提取
└── nodeId: "0:1"（根節點）
```

解析回傳的 Pages 清單。

### Step 3: 建立對應表
根據命名規範匹配：

| Prototype | 轉換邏輯 | Figma Page |
|-----------|----------|------------|
| `01-landing.html` | 去副檔名 → PascalCase | `01-Landing` |
| `02-dashboard.html` | | `02-Dashboard` |
| `12b-delete-confirm.html` | | `12b-DeleteConfirm` |

### Step 4: 產出 design.md
根據對應結果產出 design.md 檔案。

## 命名轉換規則

### Prototype → Figma Page

```javascript
function toFigmaPageName(filename) {
  // 01-landing.html → 01-Landing
  const name = filename.replace('.html', '');
  const parts = name.split('-');
  const prefix = parts[0]; // 保留編號
  const rest = parts.slice(1)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join('');
  return `${prefix}-${rest}`;
}
```

### 範例

| Prototype 檔案 | Figma Page 名稱 |
|----------------|-----------------|
| `01-landing.html` | `01-Landing` |
| `02-dashboard.html` | `02-Dashboard` |
| `05-login.html` | `05-Login` |
| `06-add-input.html` | `06-AddInput` |
| `07-add-processing.html` | `07-AddProcessing` |
| `12b-delete-confirm.html` | `12b-DeleteConfirm` |
| `14-empty-state.html` | `14-EmptyState` |

## Figma MCP 操作

### 讀取檔案結構
```
Tool: Figma:get_metadata
Parameters:
  fileKey: "wLnoR6WYzmWwuCjcLBgCDl"  # 從 URL 提取
  nodeId: "0:1"                       # 根節點
```

### 讀取特定頁面設計
```
Tool: Figma:get_design_context
Parameters:
  fileKey: "wLnoR6WYzmWwuCjcLBgCDl"
  nodeId: "{page-node-id}"
```

### 從 URL 提取資訊
```
URL: https://figma.com/design/wLnoR6WYzmWwuCjcLBgCDl/clipwise?node-id=0-1

fileKey: wLnoR6WYzmWwuCjcLBgCDl
nodeId: 0:1 (將 0-1 轉換為 0:1)
```

## design.md 格式

```markdown
# Design Specification

## Overview

- **Figma 檔案**: {figma-url}
- **Prototype 目錄**: .specify/specs/{feature}/design/prototype/
- **設計風格**: {design-concept-name}
- **建立時間**: {timestamp}

## Page Mapping

| 編號 | 頁面名稱 | Prototype | Figma Page | Node ID | User Story |
|------|----------|-----------|------------|---------|------------|
| 01 | Landing | 01-landing.html | 01-Landing | 15:55 | - |
| 02 | Dashboard | 02-dashboard.html | 02-Dashboard | 16:1 | US5 |
| 05 | Login | 05-login.html | 05-Login | 17:1 | US2 |
| 06 | 輸入連結 | 06-add-input.html | 06-AddInput | 18:1 | US1,3,4 |
| 07 | AI 處理中 | 07-add-processing.html | 07-AddProcessing | 19:1 | US1,3,4 |
| ... | ... | ... | ... | ... | ... |

## Design Decisions

### 已確認保留
| 項目 | 說明 | 來源 |
|------|------|------|
| Google OAuth | 社群登入 | design-audit |
| Dark Mode Toggle | 深色模式切換 | spec US10 |

### 標記為 Future
| 項目 | 說明 | 預計版本 |
|------|------|----------|
| 多語系切換 | 語言選擇器 | v2.0 |

## Component Mapping

| Component | Figma Location | 用途 |
|-----------|----------------|------|
| Header | Components > Header | 全域導覽列 |
| BookmarkCard | Components > Cards > Bookmark | 書籤卡片 |
| TagBadge | Components > Badges > Tag | 標籤徽章 |

## Design Tokens

參考 Figma Variables：

| Token | Light | Dark |
|-------|-------|------|
| --color-primary | #3B82F6 | #60A5FA |
| --color-background | #FFFFFF | #111827 |
| --color-surface | #F9FAFB | #1F2937 |
```

## 錯誤處理

### 找不到對應的 Figma Page

```markdown
⚠️ 無法對應的 Prototype：
- 12b-delete-confirm.html → 找不到 Figma Page "12b-DeleteConfirm"

建議：
1. 確認 Figma 中是否已建立該頁面
2. 檢查命名是否符合規範
3. 手動指定對應
```

### 手動指定對應

```markdown
## Manual Mapping

以下頁面需要手動對應（命名不符規範）：

| Prototype | 實際 Figma Page | Node ID |
|-----------|-----------------|---------|
| 12b-delete-confirm.html | DeleteDialog | 25:100 |
```
