# Figma Structure Guidelines

Figma 設計稿結構建議，確保實作階段能有效使用 Figma MCP。

---

## 建議的 Figma 結構

```
📁 {Project Name}
├── 📄 Cover
├── 📄 Design System
│   ├── 🎨 Colors
│   ├── 🔤 Typography
│   ├── 📐 Spacing
│   └── 🧩 Components
├── 📄 {Feature} - Desktop
│   ├── Frame: Page Layout
│   │   ├── Component: Header
│   │   ├── Component: Main Content
│   │   └── Component: Footer
│   └── Frame: Component States
│       ├── Button States
│       ├── Input States
│       └── ...
└── 📄 {Feature} - Mobile
    └── ...
```

---

## 命名規範

### Layer 命名

使用 `/` 分隔層級，便於程式碼對應：

```
✅ 好的命名
Button/Primary/Default
Button/Primary/Hover
Input/Text/Default
Input/Text/Focus
Card/Product/Large

❌ 不好的命名
button 1
Frame 23
Group 5
```

### Frame 命名

```
✅ 好的命名
Login Page - Desktop
Login Page - Mobile
Dashboard - Overview
Dashboard - Settings

❌ 不好的命名
Frame 1
Untitled
Desktop version
```

---

## Component 建立指南

### 何時建立 Component

| 情況 | 是否建立 Component |
|------|-------------------|
| 重複使用 2 次以上 | ✅ 是 |
| 有多個狀態 | ✅ 是 |
| 跨頁面使用 | ✅ 是 |
| 只出現一次 | ❌ 否，用 Frame |

### Component Variants

為不同狀態建立 variants：

```
Button
├── Variant: State
│   ├── Default
│   ├── Hover
│   ├── Active
│   ├── Disabled
│   └── Loading
├── Variant: Size
│   ├── Small
│   ├── Medium
│   └── Large
└── Variant: Type
    ├── Primary
    ├── Secondary
    └── Ghost
```

### Auto Layout

所有 component 都應使用 Auto Layout：

```
✅ 使用 Auto Layout
- 間距一致
- 響應內容變化
- 對應 Flexbox/Grid

❌ 固定位置
- 難以維護
- 無法響應
- 實作困難
```

---

## Design Tokens（Figma Variables）

### 顏色

```
📁 Colors
├── Primary
│   ├── primary-50: #EFF6FF
│   ├── primary-100: #DBEAFE
│   ├── primary-500: #3B82F6
│   ├── primary-600: #2563EB
│   └── primary-700: #1D4ED8
├── Neutral
│   ├── gray-50: #F9FAFB
│   ├── gray-100: #F3F4F6
│   ├── gray-500: #6B7280
│   └── gray-900: #111827
├── Semantic
│   ├── success: #10B981
│   ├── warning: #F59E0B
│   ├── error: #EF4444
│   └── info: #3B82F6
```

### 間距

```
📁 Spacing
├── spacing-1: 4px
├── spacing-2: 8px
├── spacing-3: 12px
├── spacing-4: 16px
├── spacing-6: 24px
├── spacing-8: 32px
└── spacing-12: 48px
```

### 字型

```
📁 Typography
├── heading-1
│   ├── Font: Inter
│   ├── Size: 32px
│   ├── Weight: Bold
│   └── Line Height: 40px
├── heading-2
│   ├── Font: Inter
│   ├── Size: 24px
│   ├── Weight: Semibold
│   └── Line Height: 32px
├── body
│   ├── Font: Inter
│   ├── Size: 16px
│   ├── Weight: Regular
│   └── Line Height: 24px
└── caption
    ├── Font: Inter
    ├── Size: 14px
    ├── Weight: Regular
    └── Line Height: 20px
```

---

## Figma MCP 相容性

### 確保 MCP 可讀取

1. **使用 Variables**：不要硬編碼顏色和數值
2. **命名清楚**：MCP 會回傳 layer 名稱
3. **結構扁平**：避免過度巢狀（建議最多 3-4 層）
4. **使用 Component**：MCP 可以識別 component instances

### MCP 會回傳的資訊

```json
{
  "name": "Button/Primary/Default",
  "type": "COMPONENT",
  "absoluteBoundingBox": {
    "x": 100,
    "y": 100,
    "width": 120,
    "height": 48
  },
  "fills": [
    {
      "type": "SOLID",
      "color": { "r": 0.23, "g": 0.51, "b": 0.96 }
    }
  ],
  "children": [
    {
      "name": "Label",
      "type": "TEXT",
      "characters": "Button",
      "style": {
        "fontFamily": "Inter",
        "fontSize": 16,
        "fontWeight": 500
      }
    }
  ]
}
```

### 實作時使用

```bash
# 在 Claude Code 中
"實作這個 component，使用 Figma MCP 讀取設計規格"

# AI 會呼叫 Figma MCP
figma.get_node({
  file_key: "xxx",
  node_id: "123:456"
})

# 取得精確的設計資訊來實作
```

---

## 從 Prototype 到 Figma 的調整

html.to.design 推送後，建議在 Figma 中：

### 1. 轉換為 Component

```
選取重複的元素 → Create Component (Ctrl/Cmd + Alt + K)
```

### 2. 建立 Variants

```
選取多個狀態 → Combine as Variants
```

### 3. 套用 Variables

```
選取 layer → 右鍵 → Apply Variable
```

### 4. 設定 Auto Layout

```
選取 frame → Add Auto Layout (Shift + A)
```

### 5. 整理命名

```
雙擊 layer 名稱 → 改為規範命名
```

---

## Checklist

推送到 Figma 後確認：

- [ ] 所有重複元素轉為 Component
- [ ] 狀態變體建立為 Variants
- [ ] 顏色使用 Variables
- [ ] 間距使用 Variables
- [ ] 所有 layer 正確命名
- [ ] 使用 Auto Layout
- [ ] 結構不超過 4 層巢狀
- [ ] Desktop 和 Mobile 分開的 Page
