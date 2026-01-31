# Verification Rules

## 驗證流程

### Prerequisites Check
執行驗證前，確認以下檔案存在：

```
.specify/specs/{feature}/
├── design.md      ← 必須存在
├── plan.md        ← 驗證 plan 時必須
└── tasks.md       ← 驗證 tasks 時必須
```

## Plan Verification

### 檢查項目

#### 1. Design Reference Section
檢查 plan.md 是否有設計引用區塊：

```markdown
## Design Reference
<!-- 或 -->
## UI/UX 設計
<!-- 或 -->
## 設計規格
```

**通過條件**：存在任一標題

#### 2. Figma URL
檢查是否引用 Figma URL：

```regex
https?://figma\.com/(file|design)/[a-zA-Z0-9]+
```

**通過條件**：找到 Figma URL

#### 3. design.md 引用
檢查是否引用 design.md：

```regex
design\.md|設計規格|Design Specification
```

**通過條件**：找到引用

#### 4. Page Mapping 引用
檢查是否提到頁面對應：

```regex
Page Mapping|頁面對應|Figma Page
```

**通過條件**：找到相關描述

### Plan 驗證結果

```markdown
## Plan Verification

| 檢查項目 | 狀態 | 說明 |
|----------|------|------|
| Design Reference Section | ✅/⚠️ | {detail} |
| Figma URL | ✅/⚠️ | {detail} |
| design.md 引用 | ✅/⚠️ | {detail} |
| Page Mapping 引用 | ✅/⚠️ | {detail} |

**結果**: {PASS/WARN/FAIL}
```

## Tasks Verification

### 檢查項目

#### 1. 識別 UI Tasks
掃描 tasks.md，識別 UI 相關的 tasks：

**關鍵字**：
- 頁面、Page、UI、介面
- Component、元件、組件
- 表單、Form、Button、按鈕
- 列表、List、Card、卡片
- Modal、Dialog、對話框
- Header、Footer、Sidebar

**範例**：
```markdown
- **T009 [Story: US5]**: 實作 Dashboard 頁面    ← UI Task
- **T010 [Story: US5]**: 建立書籤卡片元件       ← UI Task
- **T011 [Story: US5]**: 實作分頁邏輯          ← 非 UI Task
```

#### 2. 檢查 Figma 參考
對於每個 UI Task，檢查是否有 Figma 參考：

**有效的 Figma 參考格式**：
```markdown
**Figma**: 02-Dashboard
**Figma Page**: 02-Dashboard
**Design Reference**: design.md > 02-Dashboard
Figma: https://figma.com/file/xxx?node-id=16:1
```

#### 3. 驗證對應正確性
檢查 Figma 參考是否存在於 design.md 的對應表中。

### Tasks 驗證結果

```markdown
## Tasks Verification

找到 {total} 個 tasks，其中 {ui_count} 個是 UI 相關。

### UI Tasks 檢查

| Task ID | 描述 | Figma 參考 | 狀態 |
|---------|------|-----------|------|
| T009 | Dashboard 頁面 | 02-Dashboard | ✅ |
| T010 | 書籤卡片 | - | ⚠️ 缺少 |
| T015 | Settings 頁面 | 13-Settings | ✅ |

### 問題清單

⚠️ 以下 UI Tasks 缺少 Figma 參考：
- T010: 建立書籤卡片元件
- T018: 實作標籤篩選 UI

**結果**: {PASS/WARN/FAIL}
```

## 自動修復邏輯

### --fix 模式

當執行 `/design.verify --fix` 時：

#### Plan 修復
如果 plan.md 缺少 Design Reference section，在文件開頭（第一個 ## 之後）插入：

```markdown
## Design Reference

詳細設計規格請參考 [design.md](./design.md)

- **Figma**: {figma-url-from-design.md}
- **頁面數**: {page-count}
- **設計風格**: {design-concept}
```

#### Tasks 修復
對於缺少 Figma 參考的 UI Tasks：

1. 從 task 描述中提取頁面/元件名稱
2. 在 design.md Page Mapping 中查找匹配
3. 插入 Figma 參考

**修復前**：
```markdown
- **T009 [Story: US5]**: 實作 Dashboard 頁面
```

**修復後**：
```markdown
- **T009 [Story: US5]**: 實作 Dashboard 頁面
  - **Figma**: 02-Dashboard
```

### 匹配邏輯

```
Task 描述 → 關鍵字提取 → design.md 查找 → 插入參考

"實作 Dashboard 頁面" 
  → "Dashboard" 
  → Page Mapping: 02-Dashboard 
  → **Figma**: 02-Dashboard
```

**無法匹配時**：
```markdown
⚠️ 無法自動修復的 Tasks：
- T018: 實作標籤篩選 UI
  原因: 找不到匹配的 Figma Page
  建議: 手動指定 Figma 參考
```

## 完整報告格式

```markdown
# Design Verification Report

**Feature**: {feature-name}
**驗證時間**: {timestamp}

## Prerequisites
| 檔案 | 狀態 |
|------|------|
| design.md | ✅ 存在 |
| plan.md | ✅ 存在 |
| tasks.md | ✅ 存在 |

## Plan Verification
{plan-verification-details}

## Tasks Verification
{tasks-verification-details}

## Summary

| 項目 | 狀態 |
|------|------|
| Plan 設計引用 | ✅ PASS |
| Tasks Figma 參考 | ⚠️ 2 issues |

**Overall**: ⚠️ WARN - 2 個問題需要處理

## Recommended Actions

1. 執行 `/design.verify --fix` 自動修復
2. 或手動更新以下 tasks：
   - T010: 加入 `**Figma**: Components > BookmarkCard`
   - T018: 加入 `**Figma**: 11-TagFilter`
```
