# Element Extraction Rules

從 HTML Prototype 提取可審查元素的規則。

---

## 提取目標

### 1. Pages（頁面）

```javascript
// 每個 .html 檔案
const pages = glob('prototype/**/*.html').map(file => ({
  name: getTitle(file) || basename(file),
  path: file,
  sections: extractSections(file)
}));
```

### 2. Components（元件）

**優先順序**：

```html
<!-- 1. 有 data-component 標註的（最明確） -->
<div data-component="login-form">...</div>

<!-- 2. 有語意化 id 的 -->
<section id="hero-section">...</section>

<!-- 3. 有特定 class 的 -->
<div class="card product-card">...</div>

<!-- 4. 語意化 HTML 標籤 -->
<header>...</header>
<nav>...</nav>
<main>...</main>
<aside>...</aside>
<footer>...</footer>
```

**提取結果**：

```json
{
  "name": "login-form",
  "type": "component",
  "source": "data-component",
  "location": {
    "file": "index.html",
    "line": 45
  },
  "children": [...],
  "variants": ["default", "loading", "error"]
}
```

### 3. Interactive Elements（互動元素）

```html
<!-- 按鈕 -->
<button>Submit</button>
<button type="submit">登入</button>
<input type="submit" value="送出">

<!-- 連結 -->
<a href="/register">註冊</a>
<a href="#forgot-password">忘記密碼</a>

<!-- 表單控制 -->
<input type="text" name="email" placeholder="Email">
<select name="country">...</select>
<textarea name="message">...</textarea>
<input type="checkbox" name="remember">
<input type="radio" name="plan">
```

**提取結果**：

```json
{
  "name": "登入按鈕",
  "type": "button",
  "action": "submit",
  "text": "登入",
  "location": {...}
}
```

### 4. Data Display（資料呈現）

```html
<!-- 列表 -->
<ul class="product-list">
  <li data-component="product-item">...</li>
</ul>

<!-- 表格 -->
<table data-component="user-table">
  <thead>...</thead>
  <tbody>...</tbody>
</table>

<!-- 卡片 -->
<div class="card-grid">
  <div data-component="feature-card">...</div>
</div>
```

### 5. Form Fields（表單欄位）

```html
<form data-component="registration-form">
  <input name="username" required>
  <input name="email" type="email" required>
  <input name="password" type="password" required>
  <input name="confirm_password" type="password">
  <select name="country">...</select>
  <input name="terms" type="checkbox">
</form>
```

**提取欄位清單**：

```json
{
  "form": "registration-form",
  "fields": [
    { "name": "username", "type": "text", "required": true },
    { "name": "email", "type": "email", "required": true },
    { "name": "password", "type": "password", "required": true },
    { "name": "confirm_password", "type": "password", "required": false },
    { "name": "country", "type": "select", "required": false },
    { "name": "terms", "type": "checkbox", "required": false }
  ]
}
```

---

## 排除規則

以下元素不納入比對：

```html
<!-- 純裝飾性 -->
<div class="spacer"></div>
<hr>
<span class="icon">...</span>

<!-- 通用 UI（除非 spec 有特別要求） -->
<header>Logo + Nav</header>  <!-- 通常不需要在 spec 中 -->
<footer>Copyright</footer>

<!-- 隱藏元素 -->
<div style="display: none">...</div>
<template>...</template>

<!-- 開發用 -->
<div data-dev-only>...</div>
<!-- comment -->
```

---

## 提取腳本

```bash
# 使用 Node.js 提取
node extract-elements.js prototype/ > elements.json

# 或用 bash + grep（簡易版）
grep -rn 'data-component=' prototype/*.html
grep -rn '<button' prototype/*.html
grep -rn '<a href' prototype/*.html
grep -rn '<input' prototype/*.html
```

---

## 輸出格式

```json
{
  "extractedAt": "2024-01-15T10:30:00Z",
  "prototype": "designs/auth/prototype",
  "summary": {
    "pages": 3,
    "components": 12,
    "interactions": 8,
    "forms": 2,
    "formFields": 15
  },
  "pages": [...],
  "components": [...],
  "interactions": [...],
  "forms": [...],
  "dataDisplays": [...]
}
```
