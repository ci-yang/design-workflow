# Design Phase 工作流程

## 概述

Design Phase 是 SDD 流程中連接「規格」與「實作」的關鍵橋樑。透過 HTML Prototype 和 Figma 設計稿，將抽象的 User Stories 轉化為具體可見的介面設計，並確保設計資源正確整合到開發任務中。

### 在 SDD 中的位置

```
Phase 1: Specification → spec.md
    ↓
Phase 2: Planning     → plan.md, data-model.md, api.yaml
    ↓
Phase 2.5: Design     → prototype/, design.md, flows.md  ← 本文件
    ↓
Phase 3: Review       → 多模型審查
    ↓
Phase 4: Tasks        → tasks.md（含 Figma 參考）
```

---

## 設計流程總覽

```
┌─────────────────────────────────────────────────────────────────┐
│                        Design Phase                              │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Step 1: Prototype      Step 2: Audit       Step 3: Figma       │
│  ┌──────────────┐      ┌─────────────┐     ┌─────────────────┐  │
│  │ HTML Proto-  │  →   │ Compare vs  │  →  │ Push to Figma   │  │
│  │ type 製作    │      │ spec.md     │     │ via MCP         │  │
│  └──────────────┘      └─────────────┘     └─────────────────┘  │
│         ↓                    ↓                     ↓             │
│  prototype/*.html    audit-report.md         Figma File         │
│                                                    ↓             │
│  Step 4: Mapping       Step 5: Verify                           │
│  ┌──────────────────┐  ┌─────────────────────────────────────┐  │
│  │ Figma ↔ Proto-   │  │ plan.md / tasks.md 引用 Figma      │  │
│  │ type 對應表      │  │                                     │  │
│  └──────────────────┘  └─────────────────────────────────────┘  │
│         ↓                           ↓                            │
│     design.md              驗證通過 / 自動修復                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Prototype 製作

### 目的
將 spec.md 中的 User Stories 轉化為可互動的 HTML 原型。

### 執行指令
```
/design.prototype
```

### 產出
```
specs/<feature-id>/design/
├── prototype/
│   ├── 01-landing.html
│   ├── 02-dashboard.html
│   ├── 05-login.html
│   ├── ...
│   └── shared.css（可選）
├── design-spec.md      # 色彩、字體、元件規範
└── flow-spec.md        # data-flow-* 屬性規範
```

### Prototype 規範

#### 檔案命名
```
<序號>-<頁面名稱>.html
例：06-add-bookmark-input.html
```

#### 必要屬性
每個 HTML 檔案必須包含：
```html
<body data-page="<頁面ID>" data-flow-from="<來源頁面>:<觸發元素>">
```

#### 互動元素標記
```html
<button
  data-component="button-primary"
  data-flow-action="open-modal"
  data-flow-target="add-bookmark-input">
  新增書籤
</button>
```

### data-flow-* 屬性說明

| 屬性 | 說明 | 範例 |
|------|------|------|
| `data-page` | 頁面唯一識別碼 | `dashboard`, `login` |
| `data-flow-from` | 來源頁面和觸發元素 | `landing:button-cta` |
| `data-flow-action` | 動作類型 | `navigate`, `open-modal`, `submit` |
| `data-flow-target` | 目標頁面 ID | `add-bookmark-input` |
| `data-flow-condition` | 條件觸發 | `ai-status:success` |
| `data-component` | 元件類型 | `button-primary`, `bookmark-card` |
| `data-variant` | 元件變體 | `default`, `ai-processing`, `ai-failed` |

### 最佳實踐
- 使用 Tailwind CSS CDN 快速建立樣式
- 為所有互動元素加上 `data-flow-*` 屬性
- 響應式設計至少涵蓋 Desktop (1920px)、Tablet (768px)、Mobile (390px)

---

## Step 2: Design Audit

### 目的
比對 Prototype 與 spec.md，確保設計涵蓋所有需求，並識別設計中有但規格沒有的額外功能。

### 執行指令
```
/design.audit
```

### 檢查項目
1. **規格涵蓋**：每個 User Story 是否有對應的 Prototype 頁面
2. **功能完整**：所有 Functional Requirements 是否有對應的 UI
3. **額外功能**：Prototype 中有但 spec.md 沒有的功能
4. **遺漏項目**：spec.md 中有但 Prototype 沒有的功能

### 產出
```
specs/<feature-id>/design/
└── audit-report.md
```

### Audit Report 結構
```markdown
# 設計審查報告

## 審查摘要
| 項目 | 數量 |
|------|------|
| 總規格項目 | 15 |
| 設計涵蓋 | 14 |
| 設計額外 | 3 |
| 規格遺漏 | 1 |

## 設計額外項目（需決策）
| 項目 | 說明 | 建議 |
|------|------|------|
| Landing Page | 產品首頁 | 保留 - 加入 spec |
| 演示按鈕 | Demo 功能 | 移除 - MVP 不需要 |

## 規格遺漏項目
| User Story | 缺少設計 |
|------------|----------|
| US6 搜尋 | 無結果狀態頁面 |

## 決策記錄
- [保留] Landing Page → 新增 FR-034
- [移除] 演示按鈕
```

### 後續行動
根據 Audit 結果：
1. 更新 spec.md 加入決定保留的額外功能
2. 補充缺少的 Prototype 頁面
3. 移除決定不要的設計

---

## Step 3: Figma 整合

### 目的
將 HTML Prototype 推送到 Figma，建立可編輯的設計稿供團隊協作。

### 前置條件
1. Figma MCP Server 已連接
2. 具有 Figma 檔案編輯權限

### 使用工具
- **html.to.design** — 將 HTML 轉換為 Figma 設計
- **Figma MCP** — 透過 API 操作 Figma

### 推送流程
```bash
# 1. 在 Figma 建立新檔案
# 2. 對每個 Prototype HTML 執行 html.to.design
# 3. 在 Figma 中組織 Pages 結構
```

### Figma 結構建議
```
Figma File: <專案名稱>
├── 01-landing          # Page
│   ├── 1920w default   # Frame
│   ├── 768w default
│   └── 390w default
├── 02-Auth
│   └── 05-login / 1920w light
├── 03-Dashboard
│   ├── 02-dashboard / 1920w light
│   ├── 02-dashboard / 768w light
│   └── 14-empty-state / 1920w light
...
```

### 命名規範
- **Page 名稱**：`<序號>-<功能區>`（如 `03-Dashboard`）
- **Frame 名稱**：`<prototype檔名> / <寬度> <主題>`（如 `02-dashboard / 1920w light`）

---

## Step 4: Design Mapping

### 目的
建立 Figma 設計與 Prototype 的對應關係，產生開發參考文件。

### 執行指令
```
/design.mapping <figma-url>
```

### 輸入
Figma 檔案 URL：
```
https://www.figma.com/design/<fileKey>/<fileName>
```

### 產出
```
specs/<feature-id>/
└── design.md
```

### design.md 結構
```markdown
# 設計對應表

## Figma 檔案資訊
| 項目 | 值 |
|------|-----|
| File Key | `wLnoR6WYzmWwuCjcLBgCDl` |
| File URL | https://... |

## 頁面對應表
| Prototype | Figma Page | Frame Name | Node ID | User Story |
|-----------|------------|------------|---------|------------|
| `01-landing.html` | 01-landing | 1920w default | `27:2` | FR-034 |
| `05-login.html` | 02-Auth | 1920w light | `44:6` | US2 |

## Node ID 快速索引
| Frame | Node ID | 說明 |
|-------|---------|------|
| Dashboard Desktop | `48:1184` | 書籤列表 (1920w) |
| Dashboard Mobile | `48:1570` | 書籤列表 (390w) |

## 使用指南
// 使用 Figma MCP 取得設計資訊
const designContext = await figma.getDesignContext({
  fileKey: 'wLnoR6WYzmWwuCjcLBgCDl',
  nodeId: '48:1184'
});
```

---

## Step 5: Design Verify

### 目的
確保 plan.md 和 tasks.md 正確引用設計資源，使開發者能直接從任務連結到 Figma 設計。

### 執行指令

#### 驗證 plan.md
```
/design.verify plan
```

檢查項目：
- [ ] plan.md 包含 Design Reference 區段
- [ ] 包含 Figma URL
- [ ] 引用 design.md
- [ ] 引用 flows.md
- [ ] 主要頁面有 Node ID 對應

#### 驗證 tasks.md
```
/design.verify tasks
```

檢查項目：
- [ ] UI 相關任務包含 Figma 參考
- [ ] 參考格式：`📐 Figma: <nodeId> | <prototype>`

### 自動修復
```
/design.verify plan --fix
/design.verify tasks --fix
```

### 修復後格式範例

#### plan.md
```markdown
## Design Reference

詳細設計規格請參考 [design.md](./design.md)

| 項目 | 值 |
|------|-----|
| **Figma** | [連結](https://...) |
| **Prototype 頁面數** | 18 |
| **Figma Frames 數** | 21 |

### 主要頁面對應
| User Story | Prototype | Figma Node ID |
|------------|-----------|---------------|
| US2 認證 | `05-login.html` | `44:6` |
```

#### tasks.md
```markdown
- [ ] T045 [US1] 建立 bookmark-card.tsx 📐 Figma: `48:1184` | `02-dashboard.html`
```

---

## Flow 文件自動產生

### 目的
從 Prototype 的 `data-flow-*` 屬性自動產生流程文件。

### 執行
```bash
node generate-flows.js
```

### 產出
```
specs/<feature-id>/design/
└── flows.md
```

### flows.md 內容
- 頁面清單
- 流程定義（ASCII 流程圖）
- 頁面轉換矩陣
- 元件狀態變體
- AI 實作指引

---

## 完整設計工作流程

```bash
# Step 1: 製作 Prototype
/design.prototype
# → 產出 prototype/*.html, design-spec.md

# Step 2: 審查設計
/design.audit
# → 產出 audit-report.md
# → 根據結果更新 spec.md 或 prototype

# Step 3: 推送到 Figma
# → 使用 html.to.design 或手動上傳
# → 組織 Figma Pages 結構

# Step 4: 建立對應表
/design.mapping <figma-url>
# → 產出 design.md

# Step 5: 產生流程文件
node generate-flows.js
# → 產出 flows.md

# Step 6: 驗證整合
/design.verify plan
/design.verify tasks --fix
# → 確保 plan.md 和 tasks.md 引用設計資源
```

---

## 設計文件總覽

| 文件 | 產生方式 | 說明 |
|------|----------|------|
| `prototype/*.html` | `/design.prototype` | HTML 原型檔案 |
| `design-spec.md` | `/design.prototype` | 色彩、字體、元件規範 |
| `flow-spec.md` | 手動建立 | data-flow-* 屬性定義 |
| `audit-report.md` | `/design.audit` | 設計與規格對齊檢查 |
| `design.md` | `/design.mapping` | Figma 頁面對應表 |
| `flows.md` | `generate-flows.js` | 頁面流程（自動產生） |

---

## 與其他 Phase 的整合

### 與 Phase 2 (Planning) 的關係
- Design Phase 在 plan.md 完成後執行
- plan.md 需要更新加入 Design Reference 區段

### 與 Phase 3 (Review) 的關係
- 設計完成後進行審查
- 審查包含設計合理性檢查

### 與 Phase 4 (Tasks) 的關係
- tasks.md 產生後需要執行 `/design.verify tasks`
- UI 任務需要有 Figma 參考

---

## 常見問題

### Q: 什麼時候該執行 Design Phase？
在 plan.md 完成後、tasks.md 產生前。設計需要在任務產生前完成，以便任務能引用 Figma 資源。

### Q: 沒有 Figma 可以跳過嗎？
可以只做 Prototype 和 Audit，但建議至少產出 flows.md 記錄頁面流程。

### Q: Prototype 要做到多細緻？
MVP 階段建議：
- 每個 User Story 至少一個代表頁面
- 包含主要狀態變體（loading, success, error）
- 響應式至少涵蓋 Desktop

### Q: 如何處理設計變更？
1. 更新 Prototype
2. 重新執行 `/design.audit`
3. 更新 Figma
4. 重新執行 `/design.mapping`
5. 執行 `/design.verify` 確保參考正確

---

## 版本歷史

| 版本 | 日期 | 說明 |
|------|------|------|
| 1.0.0 | 2026-01-16 | 初始版本 |

---

*此工作流程基於 Clipwise MVP 設計經驗整理*
