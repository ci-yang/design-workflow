# Prototype Guidelines

HTML Prototype 產出規範，確保能正確轉換到 Figma 並供實作參考。

---

## 基本結構

```html
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{Feature} Prototype</title>
  
  <!-- Tailwind CDN -->
  <script src="https://cdn.tailwindcss.com"></script>
  
  <!-- Tailwind 配置（Design Tokens） -->
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#3B82F6',
            secondary: '#6B7280',
            // 從 design-spec.md 提取
          },
          spacing: {
            // 自定義 spacing
          },
          fontFamily: {
            sans: ['Inter', 'sans-serif'],
          }
        }
      }
    }
  </script>
  
  <!-- 額外樣式 -->
  <style>
    /* 互動狀態、動畫等 */
  </style>
</head>
<body class="bg-gray-50">
  <!-- Content -->
</body>
</html>
```

---

## Component 標註規範

### data-component

標註 component 邊界，會成為 Figma 的 frame/group：

```html
<!-- 頂層 component -->
<header data-component="header">
  <!-- 巢狀 component -->
  <nav data-component="navigation">
    <a data-component="nav-link" href="#">Home</a>
  </nav>
</header>
```

### data-figma-name

指定 Figma layer 名稱（如果要不同於 data-component）：

```html
<button 
  data-component="primary-button"
  data-figma-name="Button/Primary/Default"
>
  Submit
</button>
```

### data-variant

標註狀態變體：

```html
<!-- 預設狀態 -->
<button data-component="button" data-variant="default">
  Submit
</button>

<!-- Hover 狀態 -->
<button data-component="button" data-variant="hover" class="bg-blue-600">
  Submit
</button>

<!-- Disabled 狀態 -->
<button data-component="button" data-variant="disabled" disabled>
  Submit
</button>
```

### data-token

標註使用的 design token（供實作參考）：

```html
<h1 data-token="typography/heading-1" class="text-2xl font-bold">
  Title
</h1>

<div data-token="spacing/section" class="py-8">
  Content
</div>
```

---

## 響應式設計

### 方法 A：多個 viewport 區塊

```html
<body>
  <!-- Desktop (1280px) -->
  <div data-viewport="desktop" class="w-[1280px] mx-auto">
    <div data-component="page-desktop">
      <!-- Desktop layout -->
    </div>
  </div>
  
  <!-- Mobile (375px) -->
  <div data-viewport="mobile" class="w-[375px] mx-auto mt-16">
    <div data-component="page-mobile">
      <!-- Mobile layout -->
    </div>
  </div>
</body>
```

### 方法 B：響應式 classes

```html
<div data-component="card" class="
  w-full p-4
  md:w-1/2 md:p-6
  lg:w-1/3 lg:p-8
">
  <!-- 會根據 viewport 調整 -->
</div>
```

**建議**：用方法 A，這樣 Figma 會有獨立的 desktop/mobile frames。

---

## 互動狀態

### Button States

```html
<div data-component="button-states" class="flex gap-4">
  <!-- Default -->
  <button data-variant="default" class="
    bg-blue-500 text-white px-4 py-2 rounded
  ">
    Button
  </button>
  
  <!-- Hover -->
  <button data-variant="hover" class="
    bg-blue-600 text-white px-4 py-2 rounded
  ">
    Button
  </button>
  
  <!-- Active -->
  <button data-variant="active" class="
    bg-blue-700 text-white px-4 py-2 rounded
  ">
    Button
  </button>
  
  <!-- Disabled -->
  <button data-variant="disabled" class="
    bg-gray-300 text-gray-500 px-4 py-2 rounded cursor-not-allowed
  " disabled>
    Button
  </button>
</div>
```

### Input States

```html
<div data-component="input-states" class="flex flex-col gap-4">
  <!-- Default -->
  <input data-variant="default" 
    class="border border-gray-300 rounded px-3 py-2"
    placeholder="Enter text..."
  />
  
  <!-- Focus -->
  <input data-variant="focus"
    class="border-2 border-blue-500 rounded px-3 py-2 outline-none"
    placeholder="Focused"
  />
  
  <!-- Error -->
  <input data-variant="error"
    class="border-2 border-red-500 rounded px-3 py-2"
    placeholder="Error state"
  />
  
  <!-- Disabled -->
  <input data-variant="disabled"
    class="border border-gray-200 bg-gray-100 rounded px-3 py-2"
    placeholder="Disabled"
    disabled
  />
</div>
```

---

## Design Tokens 定義

在 `<script>` 中定義 Tailwind config：

```javascript
tailwind.config = {
  theme: {
    extend: {
      // 顏色
      colors: {
        primary: {
          50: '#EFF6FF',
          100: '#DBEAFE',
          500: '#3B82F6',
          600: '#2563EB',
          700: '#1D4ED8',
        },
        secondary: '#6B7280',
        success: '#10B981',
        warning: '#F59E0B',
        error: '#EF4444',
      },
      
      // 字型大小
      fontSize: {
        'heading-1': ['2rem', { lineHeight: '2.5rem', fontWeight: '700' }],
        'heading-2': ['1.5rem', { lineHeight: '2rem', fontWeight: '600' }],
        'body': ['1rem', { lineHeight: '1.5rem' }],
        'caption': ['0.875rem', { lineHeight: '1.25rem' }],
      },
      
      // 間距
      spacing: {
        'section': '4rem',
        'component': '1.5rem',
        'element': '0.5rem',
      },
      
      // 圓角
      borderRadius: {
        'button': '0.5rem',
        'card': '1rem',
        'input': '0.375rem',
      },
      
      // 陰影
      boxShadow: {
        'card': '0 4px 6px -1px rgba(0, 0, 0, 0.1)',
        'dropdown': '0 10px 15px -3px rgba(0, 0, 0, 0.1)',
      }
    }
  }
}
```

---

## Assets 處理

### 圖片

```html
<!-- 使用 placeholder -->
<img 
  data-component="hero-image"
  src="https://via.placeholder.com/800x400"
  alt="Hero image"
  class="w-full h-auto"
/>

<!-- 或本地圖片 -->
<img 
  data-component="logo"
  src="./assets/logo.svg"
  alt="Logo"
/>
```

### Icons

```html
<!-- 使用 Heroicons CDN -->
<script src="https://unpkg.com/heroicons@2.0.18/24/outline/index.js"></script>

<!-- 或 inline SVG -->
<svg data-component="icon-check" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
</svg>
```

---

## 完整範例

```html
<!DOCTYPE html>
<html lang="zh-TW">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login Page Prototype</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script>
    tailwind.config = {
      theme: {
        extend: {
          colors: {
            primary: '#3B82F6',
            'primary-hover': '#2563EB',
          }
        }
      }
    }
  </script>
</head>
<body class="bg-gray-50 min-h-screen">

  <!-- Desktop Version -->
  <div data-viewport="desktop" class="w-[1280px] mx-auto py-8">
    <div data-component="login-page" class="flex min-h-screen">
      
      <!-- Left Panel -->
      <div data-component="brand-panel" class="w-1/2 bg-primary p-12 flex flex-col justify-center">
        <h1 data-token="typography/heading-1" class="text-4xl font-bold text-white mb-4">
          Welcome Back
        </h1>
        <p data-token="typography/body" class="text-blue-100">
          Sign in to continue to your account
        </p>
      </div>
      
      <!-- Right Panel -->
      <div data-component="form-panel" class="w-1/2 p-12 flex items-center justify-center">
        <form data-component="login-form" class="w-full max-w-md space-y-6">
          
          <!-- Email Input -->
          <div data-component="form-field">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Email
            </label>
            <input 
              data-component="input"
              data-variant="default"
              type="email"
              class="w-full border border-gray-300 rounded-lg px-4 py-3"
              placeholder="Enter your email"
            />
          </div>
          
          <!-- Password Input -->
          <div data-component="form-field">
            <label class="block text-sm font-medium text-gray-700 mb-2">
              Password
            </label>
            <input 
              data-component="input"
              data-variant="default"
              type="password"
              class="w-full border border-gray-300 rounded-lg px-4 py-3"
              placeholder="Enter your password"
            />
          </div>
          
          <!-- Submit Button -->
          <button 
            data-component="primary-button"
            data-variant="default"
            class="w-full bg-primary text-white font-medium py-3 rounded-lg hover:bg-primary-hover transition"
          >
            Sign In
          </button>
          
        </form>
      </div>
      
    </div>
  </div>

  <!-- Component States Reference -->
  <div data-viewport="states" class="w-[800px] mx-auto py-16 border-t">
    <h2 class="text-xl font-bold mb-8">Component States</h2>
    
    <!-- Button States -->
    <div data-component="button-states" class="mb-8">
      <h3 class="text-sm font-medium text-gray-500 mb-4">Primary Button</h3>
      <div class="flex gap-4">
        <button data-variant="default" class="bg-primary text-white px-6 py-3 rounded-lg">Default</button>
        <button data-variant="hover" class="bg-primary-hover text-white px-6 py-3 rounded-lg">Hover</button>
        <button data-variant="disabled" class="bg-gray-300 text-gray-500 px-6 py-3 rounded-lg">Disabled</button>
      </div>
    </div>
    
    <!-- Input States -->
    <div data-component="input-states">
      <h3 class="text-sm font-medium text-gray-500 mb-4">Text Input</h3>
      <div class="flex gap-4">
        <input data-variant="default" class="border border-gray-300 rounded-lg px-4 py-3" placeholder="Default" />
        <input data-variant="focus" class="border-2 border-primary rounded-lg px-4 py-3" placeholder="Focus" />
        <input data-variant="error" class="border-2 border-red-500 rounded-lg px-4 py-3" placeholder="Error" />
      </div>
    </div>
  </div>

</body>
</html>
```

---

## Checklist

產出 prototype 前確認：

- [ ] 所有 component 都有 `data-component` 標註
- [ ] 關鍵 token 都有 `data-token` 標註
- [ ] 包含所有互動狀態（default, hover, active, disabled, focus, error）
- [ ] 有 desktop 和 mobile viewport
- [ ] Design tokens 定義在 Tailwind config
- [ ] 圖片用 placeholder 或有實際路徑
- [ ] HTML 結構乾淨、語意化
