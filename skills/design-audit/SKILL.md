---
name: design-audit
description: "比對 HTML prototype 與 spec.md 的差異。找出設計中有但規格沒有的功能，讓使用者決定是否加入 spec。當使用者說「檢查設計」「對齊規格」「audit prototype」「設計審查」時觸發。"
---

# Design Audit - Prototype vs Spec 對齊檢查

## Overview

`design-audit` 分析 HTML prototype 與 spec.md 的差異：

- **找出設計多餘的功能** → 讓你決定是否加入 spec
- **找出規格遺漏的實作** → 提醒設計沒有涵蓋
- **產出對齊報告** → 清楚的差異清單

## 使用時機

```
prototype 產出後 → design-audit → 決定是否更新 spec → 繼續實作
```

## 輸入

| 輸入 | 說明 | 預設 |
|------|------|------|
| `prototype-dir` | HTML prototype 目錄 | `designs/{feature}/prototype/` |
| `spec-path` | 規格文件路徑 | `specs/{feature}/spec.md` |

## 輸出

```
designs/{feature}/
└── audit-report.md    # 對齊報告
```

---

## 執行流程

### Phase 1: 解析 Prototype

掃描 prototype 目錄中的所有 HTML 檔案，提取：

**1. Pages（頁面）**
- 每個 HTML 檔案 = 一個頁面
- 提取 `<title>` 作為頁面名稱

**2. Components（元件）**
- 有 `data-component` 屬性的元素
- 有 `id` 或特定 class 的區塊
- 表單元素（input, button, select）
- 導航元素（nav, menu）

**3. Interactions（互動）**
- 按鈕和連結
- 表單提交
- 狀態變體（`data-variant`）

**4. Data Display（資料呈現）**
- 列表和表格
- 卡片和項目
- 動態內容區域

### Phase 2: 解析 Spec

從 spec.md 提取：

**1. User Stories**
```markdown
## User Stories
- US-1: 作為用戶，我可以...
- US-2: 作為管理員，我可以...
```

**2. Features / Requirements**
```markdown
## Features
- F-1: 登入功能
- F-2: 註冊功能
```

**3. Acceptance Criteria**
```markdown
### AC for US-1
- [ ] 可以輸入帳號密碼
- [ ] 可以看到錯誤訊息
```

**4. UI Elements（如果有描述）**
```markdown
## UI 需求
- 登入表單
- 忘記密碼連結
```

### Phase 3: 比對差異

建立映射關係：

| Prototype 元素 | 可能對應的 Spec 項目 |
|----------------|---------------------|
| `data-component="login-form"` | US: 登入功能 |
| `<button>註冊</button>` | F: 註冊功能 |
| `<a>忘記密碼</a>` | AC: 忘記密碼流程 |

分類結果：

1. **✅ 對齊（Aligned）**
   - Prototype 有，Spec 也有

2. **⚠️ 設計額外（Design Extra）**
   - Prototype 有，但 Spec 沒有明確提到
   - **這是你要關注的！**

3. **❌ 規格遺漏（Spec Missing）**
   - Spec 有，但 Prototype 沒有實現

### Phase 4: 產出報告

```markdown
# Design Audit Report

## Summary
- 對齊項目: 12
- 設計額外: 3
- 規格遺漏: 1

## ⚠️ 設計額外（需要決定是否加入 Spec）

### 1. Social Login Buttons
**位置**: `prototype/index.html` line 45
**元素**: 
```html
<button data-component="social-login-google">Google 登入</button>
<button data-component="social-login-github">GitHub 登入</button>
```
**建議 Spec 補充**:
```markdown
- US-X: 作為用戶，我可以使用 Google/GitHub 帳號快速登入
  - AC: 點擊 Google 登入按鈕可以跳轉到 OAuth 流程
  - AC: 點擊 GitHub 登入按鈕可以跳轉到 OAuth 流程
```
[ ] 加入 Spec  [ ] 從設計移除  [ ] 標記為 Future

### 2. Remember Me Checkbox
...

## ❌ 規格遺漏（Prototype 沒有實現）

### 1. 密碼強度提示
**Spec 來源**: US-2 AC-3
**描述**: 註冊時應顯示密碼強度指示
**建議**: 在 prototype 中加入密碼強度元件

## ✅ 對齊項目
| Prototype | Spec | 狀態 |
|-----------|------|------|
| login-form | US-1 | ✅ |
| register-form | US-2 | ✅ |
...
```

---

## 關鍵：識別「設計額外」的邏輯

### 自動識別規則

| Prototype 特徵 | 判斷為「額外」的條件 |
|----------------|---------------------|
| 按鈕/連結 | Spec 沒有對應的 User Story 或 AC |
| 表單欄位 | Spec 沒有提到需要這個資料 |
| 頁面區塊 | Spec 沒有描述這個功能區域 |
| 狀態變體 | Spec 沒有定義這個狀態 |

### 模糊匹配

允許一定程度的模糊匹配：
- `login-form` ≈ "登入功能" / "用戶登入"
- `submit-button` ≈ "提交" / "送出"
- `error-message` ≈ "錯誤提示" / "驗證失敗"

### 需要人工判斷的情況

- 隱含需求（Spec 沒寫但合理應該有）
- 通用 UI 元素（header, footer, breadcrumb）
- 裝飾性元素（icon, divider）

---

## 互動模式

產出報告後，提供互動選項：

```
發現 3 個設計額外項目：

1. Social Login Buttons
   [A] 加入 Spec  [R] 從設計移除  [F] 標記 Future  [S] 跳過

2. Remember Me Checkbox
   [A] 加入 Spec  [R] 從設計移除  [F] 標記 Future  [S] 跳過

3. Dark Mode Toggle
   [A] 加入 Spec  [R] 從設計移除  [F] 標記 Future  [S] 跳過

請選擇每個項目的處理方式，或輸入 'all:A' 全部加入 Spec
```

選擇 `A` 後，自動產出 Spec 補充建議。

---

## 使用範例

```bash
# 基本用法
/design-audit designs/auth/prototype specs/auth/spec.md

# 只看差異摘要
/design-audit --summary

# 自動產出 Spec 補充建議
/design-audit --suggest-spec

# 互動模式
/design-audit --interactive
```

---

## 相關檔案

- `references/element-extraction.md` - HTML 元素提取規則
- `references/spec-parsing.md` - Spec 解析規則
- `references/matching-rules.md` - 比對邏輯說明
