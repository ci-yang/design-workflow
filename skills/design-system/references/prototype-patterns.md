# Prototype Patterns

## 產出流程

### Step 1: 分析 Spec
從 spec.md 提取：
- User Stories → 對應頁面
- Acceptance Criteria → 對應元件/功能
- Data Model → 對應表單欄位

### Step 2: 規劃頁面
根據 User Story 規劃頁面清單：

```markdown
## 頁面規劃

### 主要頁面
| 編號 | 頁面 | User Story | 說明 |
|------|------|------------|------|
| 01 | Landing | - | 首頁、功能介紹 |
| 02 | Dashboard | US5 | 書籤列表 |
| 05 | Login | US2 | OAuth 登入 |

### 流程頁面
| 編號 | 頁面 | User Story | 說明 |
|------|------|------------|------|
| 06 | AddBookmark-Input | US1,3,4 | 輸入 URL |
| 07 | AddBookmark-Processing | US1,3,4 | AI 處理中 |
| 08 | AddBookmark-Result | US1,3,4 | 顯示結果 |

### 狀態頁面
| 編號 | 頁面 | 說明 |
|------|------|------|
| 14 | EmptyState | 無書籤 |
| 15 | ErrorState | 錯誤狀態 |
```

### Step 3: 設計概念
使用 ui-ux-pro-max skill 產出多個設計概念，讓使用者選擇。

### Step 4: 產出 HTML
選定概念後，產出完整 HTML prototype。

## HTML 模板

### 基礎頁面模板
```html
<!DOCTYPE html>
<html lang="zh-TW" class="scroll-smooth">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{PageTitle} - {ProjectName}</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      darkMode: 'class',
      theme: {
        extend: {
          colors: {
            primary: { /* 自訂主色 */ },
            accent: { /* 自訂強調色 */ }
          }
        }
      }
    }
  </script>
</head>
<body class="min-h-screen bg-gray-50 dark:bg-gray-900 text-gray-900 dark:text-gray-100">
  {content}
</body>
</html>
```

### 常用元件模板

#### Header
```html
<header data-component="header" class="sticky top-0 z-50 bg-white/80 dark:bg-gray-900/80 backdrop-blur border-b border-gray-200 dark:border-gray-800">
  <nav class="container mx-auto px-4 h-16 flex items-center justify-between">
    <a href="/" data-component="logo" class="text-xl font-bold">{Logo}</a>
    <div data-component="nav-links" class="hidden md:flex items-center gap-6">
      <a href="#features">功能</a>
      <a href="#pricing">方案</a>
    </div>
    <button data-component="cta-button" class="px-4 py-2 bg-primary-600 text-white rounded-lg">
      開始使用
    </button>
  </nav>
</header>
```

#### Form
```html
<form data-component="{form-name}" class="space-y-4">
  <div>
    <label for="{field}" class="block text-sm font-medium mb-1">{Label}</label>
    <input 
      data-component="{field}-input"
      type="{type}" 
      id="{field}" 
      name="{field}"
      class="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg focus:ring-2 focus:ring-primary-500"
      placeholder="{placeholder}"
    />
  </div>
  <button 
    data-component="submit-button"
    type="submit" 
    class="w-full py-2 bg-primary-600 text-white rounded-lg hover:bg-primary-700"
  >
    {SubmitText}
  </button>
</form>
```

#### Card
```html
<article data-component="{card-name}" class="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 p-6">
  <h3 class="text-lg font-semibold mb-2">{Title}</h3>
  <p class="text-gray-600 dark:text-gray-400">{Description}</p>
</article>
```

#### Loading State
```html
<div data-component="loading-state" class="animate-pulse space-y-4">
  <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-3/4"></div>
  <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-1/2"></div>
  <div class="h-32 bg-gray-200 dark:bg-gray-700 rounded"></div>
</div>
```

#### Empty State
```html
<div data-component="empty-state" class="text-center py-12">
  <div class="w-16 h-16 mx-auto mb-4 text-gray-400">
    {Icon}
  </div>
  <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-2">
    {Title}
  </h3>
  <p class="text-gray-500 dark:text-gray-400 mb-4">
    {Description}
  </p>
  <button class="px-4 py-2 bg-primary-600 text-white rounded-lg">
    {ActionText}
  </button>
</div>
```

#### Error State
```html
<div data-component="error-state" class="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
  <div class="flex items-start gap-3">
    <span class="text-red-500">⚠️</span>
    <div>
      <h4 class="font-medium text-red-800 dark:text-red-200">{ErrorTitle}</h4>
      <p class="text-sm text-red-600 dark:text-red-300 mt-1">{ErrorMessage}</p>
      <button class="mt-2 text-sm text-red-700 dark:text-red-300 underline">
        {RetryText}
      </button>
    </div>
  </div>
</div>
```

## 檔案組織

### 目錄結構
```
design/
└── prototype/
    ├── index.html           # 頁面索引（可選）
    ├── 01-landing.html
    ├── 02-dashboard.html
    ├── 05-login.html
    ├── 06-add-input.html
    ├── 07-add-processing.html
    ├── 08-add-result.html
    ├── 09-add-success.html
    ├── 10-search-results.html
    ├── 11-tag-filter.html
    ├── 12-edit-bookmark.html
    ├── 12b-delete-confirm.html
    ├── 13-settings.html
    ├── 14-empty-state.html
    ├── 15-error-state.html
    └── 16-no-results.html
```

### 命名規則
- 編號：兩位數，01-99
- 名稱：kebab-case
- 狀態後綴：用字母 (a, b, c) 表示同頁面的變體
