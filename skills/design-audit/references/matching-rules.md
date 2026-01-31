# Matching Rules

Prototype 元素與 Spec 項目的比對邏輯。

---

## 比對策略

### 1. 精確匹配

直接名稱對應：

| Prototype | Spec |
|-----------|------|
| `data-component="login-form"` | Feature: 登入功能 |
| `id="register-button"` | AC: 點擊註冊按鈕 |
| `name="email"` | Field: email |

### 2. 關鍵字匹配

提取關鍵字比對：

```
Prototype: <button>Google 登入</button>
Keywords: ["google", "登入"]

Spec: 無 "google" 或 "social" 或 "oauth" 相關描述
Result: ⚠️ Design Extra
```

### 3. 語意匹配

同義詞/近義詞：

```javascript
const synonyms = {
  "登入": ["login", "sign in", "signin"],
  "註冊": ["register", "sign up", "signup"],
  "提交": ["submit", "送出", "確認"],
  "密碼": ["password", "pwd", "pass"],
  "記住我": ["remember me", "keep logged in", "stay signed in"]
};
```

### 4. 推斷匹配

根據上下文推斷：

```
Prototype: <input type="checkbox" name="remember">
推斷: 這是「記住我」功能

Spec: US-1 提到「用戶可以保持登入狀態」
Result: ✅ Aligned（推斷匹配）
```

---

## 分類邏輯

### ✅ Aligned（對齊）

條件：
- 精確匹配 OR
- 關鍵字匹配 >= 2 個 OR
- 語意匹配 + 上下文確認

```json
{
  "status": "aligned",
  "prototype": { "name": "login-form", "type": "component" },
  "spec": { "id": "US-1", "title": "用戶登入" },
  "matchType": "keyword",
  "confidence": 0.9
}
```

### ⚠️ Design Extra（設計額外）

條件：
- Prototype 有元素
- 找不到任何 Spec 項目匹配
- 不是「排除」類別（見下方）

```json
{
  "status": "design_extra",
  "prototype": {
    "name": "social-login-google",
    "type": "button",
    "text": "Google 登入",
    "location": { "file": "index.html", "line": 45 }
  },
  "spec": null,
  "reason": "Spec 中沒有提到 Google/OAuth/Social 登入",
  "suggestedSpec": "US-X: 作為用戶，我可以使用 Google 帳號登入"
}
```

### ❌ Spec Missing（規格遺漏）

條件：
- Spec 有明確要求
- Prototype 沒有對應元素

```json
{
  "status": "spec_missing",
  "spec": {
    "id": "AC-2.3",
    "description": "密碼強度指示器"
  },
  "prototype": null,
  "reason": "Prototype 的註冊表單沒有密碼強度元件"
}
```

---

## 排除規則（不報告為差異）

### 通用 UI 元素

以下元素除非 Spec 特別提到，否則不報告：

```
- Header / Navigation
- Footer
- Logo
- Breadcrumb
- Loading spinner
- Scroll to top button
- Cookie consent banner
```

### 裝飾性元素

```
- Icons（除非有特定功能）
- Dividers / Spacers
- Background images
- Decorative animations
```

### 隱含需求

常見的隱含需求，即使 Spec 沒提也不報告：

```
- 表單驗證錯誤訊息
- Loading 狀態
- Empty state
- 404 頁面
- 基本響應式設計
```

---

## 信心分數

每個匹配結果有信心分數：

| 分數 | 含義 |
|------|------|
| 0.9-1.0 | 精確匹配，高度確定 |
| 0.7-0.9 | 關鍵字匹配，很可能對應 |
| 0.5-0.7 | 語意匹配，需要確認 |
| < 0.5 | 推斷匹配，建議人工檢查 |

```json
{
  "match": {
    "prototype": "remember-checkbox",
    "spec": "AC-1.5",
    "confidence": 0.75,
    "matchReason": "keyword match: '記住' in both"
  }
}
```

---

## 特殊處理

### 多對一匹配

一個 Spec 項目對應多個 Prototype 元素：

```
Spec: "登入功能"
Prototype:
  - login-form
  - email-input
  - password-input
  - login-button
  - forgot-password-link

→ 全部標記為 Aligned
```

### 一對多匹配

一個 Prototype 元素對應多個 Spec 項目：

```
Prototype: "submit-button"
Spec:
  - AC-1.3: 可以提交登入表單
  - AC-2.5: 可以提交註冊表單

→ 選擇上下文最近的匹配
```

### 無法判斷

需要人工確認的情況：

```json
{
  "status": "uncertain",
  "prototype": { "name": "extra-button", "text": "..." },
  "candidates": [
    { "spec": "US-1", "confidence": 0.4 },
    { "spec": "US-2", "confidence": 0.35 }
  ],
  "action": "請人工確認此元素對應哪個 Spec 項目"
}
```

---

## 輸出報告結構

```json
{
  "auditedAt": "2024-01-15T10:30:00Z",
  "summary": {
    "aligned": 12,
    "designExtra": 3,
    "specMissing": 1,
    "uncertain": 2
  },
  "results": {
    "aligned": [...],
    "designExtra": [...],
    "specMissing": [...],
    "uncertain": [...]
  },
  "suggestions": {
    "addToSpec": [...],
    "addToPrototype": [...],
    "needsReview": [...]
  }
}
```
