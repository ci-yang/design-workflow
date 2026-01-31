# Audit Rules

## 審查流程

### Step 1: 提取 Prototype 元素
掃描所有 HTML 檔案，提取：

```
1. 頁面：檔名和 <title>
2. Components：所有 data-component 屬性
3. 按鈕：所有 <button> 元素（文字內容）
4. 連結：所有 <a> 元素（href 和文字）
5. 表單欄位：所有 <input>, <select>, <textarea>（name, type）
6. 表單：所有 <form> 元素
7. 區塊：有 id 的主要區塊
```

### Step 2: 提取 Spec 項目
讀取 spec.md，提取：

```
1. User Stories：## User Stories 區塊下的所有項目
2. Features：## Features 或 ## Requirements 區塊
3. Acceptance Criteria：### AC 或 ### Acceptance Criteria
4. Data Model：## Data Model 或 ### Key Entities
5. UI 元素描述：任何提到 UI 的描述
```

### Step 3: 比對規則

#### 匹配邏輯（優先順序）
1. **精確匹配**：元素名稱 = Spec 項目 ID
2. **關鍵字匹配**：元素名稱包含 Spec 關鍵字
3. **文字匹配**：按鈕/連結文字出現在 Spec 中
4. **欄位匹配**：表單欄位名稱在 Data Model 中

#### 排除規則（不報告）
以下元素視為通用元素，不需要 Spec 對應：
- `header`, `footer`, `nav`, `sidebar`
- `logo`, `brand`
- `icon`, `spacer`, `divider`
- `container`, `wrapper`, `layout`
- `copyright`, `social-links`

#### 分類結果
| 分類 | 條件 |
|------|------|
| ✅ 對齊 | Prototype 元素有對應 Spec 項目 |
| ⚠️ 設計額外 | Prototype 有，Spec 沒有 |
| ❌ 規格遺漏 | Spec 有，Prototype 沒有 |

## 審查報告格式

```markdown
# Design Audit Report

**Prototype**: .specify/specs/{feature}/design/prototype/
**Spec**: .specify/specs/{feature}/spec.md
**審查時間**: {timestamp}

## 摘要

| 分類 | 數量 |
|------|------|
| ✅ 對齊 | {count} |
| ⚠️ 設計額外 | {count} |
| ❌ 規格遺漏 | {count} |

---

## ⚠️ 設計額外（Prototype 有，Spec 沒有）

### 1. {element-name}

**位置**: `{file}`
**類型**: {button/link/component/field}
**內容**:
```html
{html-snippet}
```

**建議處理**:
- [ ] 加入 Spec（新需求）
- [ ] 標記為 Future（延後）
- [ ] 從 Prototype 移除（拒絕）

**若加入 Spec，建議內容**:
```markdown
- US-X: 作為用戶，我可以{action}
  - AC: {acceptance-criteria}
```

---

## ❌ 規格遺漏（Spec 有，Prototype 沒有）

### 1. {spec-item}

**來源**: {spec-id}
**描述**: {description}
**建議**: 在 Prototype 中加入此功能

---

## ✅ 對齊項目

| Prototype 元素 | 對應 Spec | 匹配方式 |
|----------------|----------|----------|
| {element} | {spec-id} | {method} |
```

## 差異處理流程

### 設計額外的處理選項

#### A: 加入 Spec
```
1. 確認這是有價值的新需求
2. 更新 spec.md，加入新的 User Story 或 AC
3. 重新執行 /speckit.analyze 確認一致性
```

#### F: 標記為 Future
```
1. 確認這是未來版本的功能
2. 在 design.md 的 "Future Features" 區塊記錄
3. 可選：從 prototype 移除或保留（標記為 future）
```

#### R: 從 Prototype 移除
```
1. 確認這不是需要的功能
2. 從 HTML 中移除相關元素
3. 記錄移除原因
```

### 規格遺漏的處理

```
1. 檢查是否真的遺漏，還是用不同名稱實作
2. 如果遺漏，評估優先級：
   - 高優先：立即加入 prototype
   - 低優先：標記為 TODO
3. 更新 prototype 後重新執行 audit
```

## 互動模式

審查完成後，提供互動式處理：

```
報告已產出。

發現 {N} 個設計額外項目：
1. {item-1}
2. {item-2}
...

請問要怎麼處理？
- 輸入 "1A" 把第 1 項加入 Spec
- 輸入 "2F" 把第 2 項標記為 Future
- 輸入 "3R" 把第 3 項從 Prototype 移除建議
- 輸入 "all:A" 全部加入 Spec
- 輸入 "all:F" 全部標記為 Future
- 輸入 "done" 結束
```
