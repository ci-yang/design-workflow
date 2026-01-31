---
description: 驗證 plan.md 和 tasks.md 是否正確引用設計資源，確保 UI tasks 有 Figma 參考。支援自動修復。
allowed-tools: Read, Write, Glob, Grep
argument-hint: [plan|tasks] [--fix]
---

# /design.verify

驗證設計整合是否完整。

## 用法

```bash
/design.verify              # 驗證全部（plan + tasks）
/design.verify plan         # 只驗證 plan.md
/design.verify tasks        # 只驗證 tasks.md
/design.verify --fix        # 驗證全部 + 自動修復
/design.verify tasks --fix  # 只驗證 tasks + 自動修復
```

## 輸入

```
$ARGUMENTS
```

## 執行流程

### Step 1: Prerequisites Check

確認必要檔案存在：

```
.specify/specs/{feature}/
├── design.md   ← 必須存在
├── plan.md     ← 驗證 plan 時必須
└── tasks.md    ← 驗證 tasks 時必須
```

如果 design.md 不存在，提示先執行 `/design.mapping`。

### Step 2: Plan Verification

檢查 plan.md：

1. **Design Reference Section** - 是否有設計引用區塊
2. **Figma URL** - 是否引用 Figma URL
3. **design.md 引用** - 是否引用 design.md
4. **Page Mapping 引用** - 是否提到頁面對應

### Step 3: Tasks Verification

檢查 tasks.md：

1. **識別 UI Tasks** - 掃描包含 UI 關鍵字的 tasks
2. **檢查 Figma 參考** - 每個 UI task 是否有 Figma 參考
3. **驗證對應正確性** - Figma 參考是否存在於 design.md

## 輸出格式

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

| 檢查項目 | 狀態 | 說明 |
|----------|------|------|
| Design Reference Section | ✅ | 找到 "## Design Reference" |
| Figma URL | ✅ | https://figma.com/... |
| design.md 引用 | ✅ | [design.md](./design.md) |
| Page Mapping 引用 | ⚠️ | 未提到頁面對應 |

**Plan 結果**: ⚠️ WARN

## Tasks Verification

找到 28 個 tasks，其中 12 個是 UI 相關。

| Task ID | 描述 | Figma 參考 | 狀態 |
|---------|------|-----------|------|
| T009 | Dashboard 頁面 | 02-Dashboard | ✅ |
| T010 | 書籤卡片元件 | - | ⚠️ |
| T015 | Settings 頁面 | 13-Settings | ✅ |
| T018 | 標籤篩選 UI | - | ⚠️ |

**Tasks 結果**: ⚠️ WARN - 2 個 UI tasks 缺少 Figma 參考

## Summary

| 項目 | 狀態 |
|------|------|
| Plan 設計引用 | ⚠️ WARN |
| Tasks Figma 參考 | ⚠️ WARN |

**Overall**: ⚠️ WARN - 需要處理
```

## --fix 模式

### Plan 修復

如果缺少 Design Reference，在 plan.md 插入：

```markdown
## Design Reference

詳細設計規格請參考 [design.md](./design.md)

- **Figma**: {figma-url}
- **頁面數**: {count}
```

### Tasks 修復

對於缺少 Figma 參考的 UI tasks：

**修復前**：
```markdown
- **T009 [Story: US5]**: 實作 Dashboard 頁面
```

**修復後**：
```markdown
- **T009 [Story: US5]**: 實作 Dashboard 頁面
  - **Figma**: 02-Dashboard
```

### 修復報告

```
✅ 自動修復完成

修復項目：
- plan.md: 新增 Design Reference section
- tasks.md: 為 2 個 UI tasks 加入 Figma 參考
  - T010: BookmarkCard → Components
  - T018: TagFilter → 11-TagFilter

無法自動修復：
- T022: 找不到匹配的 Figma 頁面，請手動指定
```

## 完成訊息

### 全部通過
```
✅ 設計驗證通過

所有檢查項目都符合要求：
- Plan 正確引用設計資源
- 所有 UI tasks 都有 Figma 參考

可以繼續執行 /speckit.implement
```

### 有警告
```
⚠️ 設計驗證有警告

需要處理的項目：
- T010: 缺少 Figma 參考
- T018: 缺少 Figma 參考

執行 `/design.verify --fix` 自動修復
或手動更新 tasks.md
```

### 失敗
```
❌ 設計驗證失敗

缺少必要檔案：design.md

請先執行：
1. /design.mapping <figma-url>
2. 再執行 /design.verify
```

## 參考資源

使用 design-system skill：
- `references/verification-rules.md` - 驗證規則
