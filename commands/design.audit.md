---
description: 比對 HTML prototype 與 spec.md 的差異，找出設計額外和規格遺漏的項目，產出審查報告。
allowed-tools: Read, Write, Glob, Grep
argument-hint: [feature-path]
---

# /design.audit

比對 prototype 與 spec，找出差異。

## 輸入

```
$ARGUMENTS
```

若未指定 feature-path，自動偵測當前 feature。

## 執行流程

### Step 1: 載入檔案

讀取：
- `.specify/specs/{feature}/spec.md`
- `.specify/specs/{feature}/design/prototype/*.html`

### Step 2: 提取 Prototype 元素

掃描所有 HTML 檔案，提取：

```markdown
## Prototype 元素清單

### 頁面
- {filename}: {title}

### Components (data-component)
- {component-name}

### 按鈕
- "{button-text}" (type={type})

### 連結
- "{link-text}" → {href}

### 表單欄位
- {name} (type={type})
```

### Step 3: 提取 Spec 項目

讀取 spec.md，提取：

```markdown
## Spec 項目清單

### User Stories
- {US-ID}: {description}

### Acceptance Criteria
- {AC-ID}: {description}

### Data Model
- {Entity}: {fields}
```

### Step 4: 比對差異

依照 `references/audit-rules.md` 的規則比對：

1. **對齊**：Prototype 元素有對應 Spec 項目
2. **設計額外**：Prototype 有，Spec 沒有
3. **規格遺漏**：Spec 有，Prototype 沒有

排除通用元素（header, footer, nav 等）。

### Step 5: 產出報告

使用 `assets/audit-report.template.md` 產出報告到：
`.specify/specs/{feature}/design/audit-report.md`

### Step 6: 互動處理

```
報告已產出。

發現 {N} 個設計額外項目：
1. {item-1}
2. {item-2}
...

請問要怎麼處理？
- 輸入 "1A" 把第 1 項加入 Spec
- 輸入 "2F" 把第 2 項標記為 Future
- 輸入 "3R" 建議從 Prototype 移除
- 輸入 "all:A" 全部加入 Spec
- 輸入 "done" 結束
```

## 處理動作

### A - 加入 Spec
提供建議的 User Story / AC 內容，使用者確認後更新 spec.md。

### F - 標記為 Future
記錄到 audit-report.md 的「標記為 Future」區塊。

### R - 移除建議
記錄到 audit-report.md，提醒使用者從 prototype 移除。

## 輸出

```
.specify/specs/{feature}/design/audit-report.md
```

## 完成訊息

```
✅ 設計審查完成

📊 結果摘要：
- ✅ 對齊: {count}
- ⚠️ 設計額外: {count}（已處理）
- ❌ 規格遺漏: {count}

📁 報告位置: .specify/specs/{feature}/design/audit-report.md

下一步：
1. 處理規格遺漏項目（如有）
2. 使用 html.to.design 推送 prototype 到 Figma
3. 推送完成後執行 /design.mapping
```

## 參考資源

使用 design-system skill：
- `references/audit-rules.md` - 審查規則
- `assets/audit-report.template.md` - 報告模板
