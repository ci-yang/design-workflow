---
description: Figma 推送完成後，建立 prototype 與 Figma Pages 的對應表，產出 design.md。
allowed-tools: Read, Write, Glob, Figma:get_metadata, Figma:get_design_context
argument-hint: <figma-url> [feature-path]
---

# /design.mapping

建立 Prototype 與 Figma 的對應表。

## 輸入

```
$ARGUMENTS
```

- `figma-url`: Figma 檔案 URL（必要）
- `feature-path`: Feature 路徑（可選，自動偵測）

## 執行流程

### Step 1: 解析 Figma URL

從 URL 提取：
```
https://figma.com/design/{fileKey}/{fileName}?node-id={nodeId}

fileKey: {extracted}
nodeId: {extracted or "0:1"}
```

### Step 2: 讀取 Prototype 檔案

掃描 `.specify/specs/{feature}/design/prototype/`：

```
01-landing.html
02-dashboard.html
05-login.html
...
```

### Step 3: 讀取 Figma 結構

使用 Figma MCP 讀取檔案結構：

```
Figma:get_metadata
├── fileKey: {fileKey}
└── nodeId: "0:1"
```

取得所有 Pages/Frames 清單。

### Step 4: 建立對應

根據命名規範匹配：

| Prototype | 轉換 | Figma Page | Node ID |
|-----------|------|------------|---------|
| 01-landing.html | 01-Landing | 01-Landing | {id} |
| 02-dashboard.html | 02-Dashboard | 02-Dashboard | {id} |

### Step 5: 讀取 audit-report（如存在）

從 `design/audit-report.md` 提取：
- 已確認保留的項目
- 標記為 Future 的項目

### Step 6: 讀取 spec.md

提取 User Story ID 對應到頁面。

### Step 7: 產出 design.md

使用 `assets/design.md.template` 產出：
`.specify/specs/{feature}/design.md`

## 輸出

```
.specify/specs/{feature}/design.md
```

內容包含：
- Figma 檔案連結
- Page Mapping 對應表
- Design Decisions
- Component Mapping（如有）

## 錯誤處理

### 找不到對應的 Figma Page

```
⚠️ 以下 Prototype 找不到對應的 Figma Page：
- 12b-delete-confirm.html → 預期 "12b-DeleteConfirm"

請確認：
1. Figma 中已建立該頁面
2. 命名是否符合規範

或手動指定對應（輸入 Figma Page 名稱）：
> 12b-delete-confirm.html 對應到：
```

### Figma 存取錯誤

```
❌ 無法存取 Figma 檔案

可能原因：
1. URL 格式不正確
2. 沒有檔案存取權限
3. Figma MCP 未連線

請檢查後重試。
```

## 完成訊息

```
✅ Figma 對應表建立完成

📁 位置: .specify/specs/{feature}/design.md
📄 對應頁面: {count}/{total}
🔗 Figma: {figma-url}

下一步：
1. 檢查 design.md 內容
2. 執行 /speckit.plan 產出實作計畫
3. 執行 /design.verify plan 確認設計引用
```

## 參考資源

使用 design-system skill：
- `references/figma-mapping.md` - Figma 對應邏輯
- `assets/design.md.template` - design.md 模板
