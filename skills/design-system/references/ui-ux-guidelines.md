# UI/UX Guidelines

## 設計原則

### 1. 一致性優先
- 相同功能使用相同的 UI 模式
- 術語和標籤統一
- 間距、顏色、字體遵循 Design Token

### 2. 漸進式揭露
- 核心功能優先展示
- 進階功能在需要時顯現
- 避免一次顯示過多選項

### 3. 即時回饋
- 每個操作都有視覺回應
- 載入狀態超過 200ms 顯示 skeleton
- 錯誤訊息清晰可操作

### 4. 無障礙設計
- WCAG 2.1 AA 標準
- 鍵盤完全可操作
- 對比度符合要求
- 螢幕閱讀器友善

## Prototype 設計規範

### 頁面結構
```html
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{頁面標題} - {專案名稱}</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 dark:bg-gray-900">
  <!-- Header -->
  <header data-component="header">...</header>
  
  <!-- Main Content -->
  <main data-component="main">...</main>
  
  <!-- Footer -->
  <footer data-component="footer">...</footer>
</body>
</html>
```

### Component 標記
使用 `data-component` 屬性標記可識別的元件：

```html
<form data-component="login-form">
  <input data-component="email-input" type="email" />
  <input data-component="password-input" type="password" />
  <button data-component="submit-button" type="submit">登入</button>
</form>
```

### 狀態變體
同一頁面的不同狀態應分開檔案或用 section 標記：

```
06-add-input.html      # 初始狀態
07-add-processing.html # 處理中
08-add-result.html     # 結果
09-add-success.html    # 成功
```

## 響應式設計

### Breakpoints
| 名稱 | 寬度 | 用途 |
|------|------|------|
| mobile | < 640px | 手機 |
| tablet | 640px - 1024px | 平板 |
| desktop | > 1024px | 桌面 |

### 優先順序
1. Mobile First 設計
2. 關鍵互動在所有裝置可用
3. 複雜功能可在小螢幕簡化

## 深色模式

### 實作方式
```html
<body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
```

### 顏色對應
| Light | Dark |
|-------|------|
| white | gray-900 |
| gray-50 | gray-800 |
| gray-100 | gray-700 |
| gray-900 | gray-100 |

## 元件命名規範

### 頁面級
```
{nn}-{page-name}.html
01-landing.html
02-dashboard.html
```

### 元件級
```
{page}-{component}-{variant}
login-form
login-form-error
login-form-loading
```

### 狀態後綴
```
-default
-hover
-active
-disabled
-loading
-error
-success
```
