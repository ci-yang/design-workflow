---
name: design-system
description: Design system skill for UI/UX workflow integration with spec-kit. Use when the user asks to "create prototype", "design UI", "generate HTML prototype", "audit design", "check design vs spec", "create Figma mapping", "map Figma pages", "verify design integration", "check design in plan", "check design in tasks", or mentions spec-to-implementation design workflow, UI/UX design process, or Figma integration.
---

# Design System Skill

整合 spec-kit 的設計系統工作流程，管理從規格到實作的 UI/UX 設計流程。

## Overview

此 skill 提供完整的設計工作流程，確保：
- Prototype 與 Spec 對齊
- Figma 設計與實作對應
- Plan/Tasks 正確引用設計資源

## Workflow

```
spec.md → /design.prototype → /design.audit → /design.flows → Figma 推送 → /design.mapping → /design.verify
```

| 階段 | 指令 | 輸入 | 輸出 |
|------|------|------|------|
| 1. Prototype | `/design.prototype` | spec.md | design/prototype/*.html |
| 2. Audit | `/design.audit` | prototype/, spec.md | design/audit-report.md |
| 3. Flows | `/design.flows` | prototype/*.html | design/flows.md |
| 4. Mapping | `/design.mapping` | prototype/, Figma URL | design.md |
| 5. Verify | `/design.verify` | design.md, plan.md, tasks.md | 驗證報告 |

## Output Structure

所有設計文件位於 `.specify/specs/{feature}/`：

```
.specify/specs/{feature}/
├── spec.md
├── plan.md
├── tasks.md
├── design.md                    ← Figma 對應表
└── design/
    ├── prototype/               ← HTML prototype（含 data-flow-* 標記）
    │   ├── 01-landing.html
    │   ├── 02-dashboard.html
    │   └── ...
    ├── design-spec.md           ← UI/UX 設計規格
    ├── audit-report.md          ← 審查報告
    ├── flow-spec.md             ← Flow 標記規格
    ├── flows.md                 ← 流程文件（自動產生）
    └── generate-flows.js        ← Flow 產生腳本
```

## Figma Naming Convention

Prototype 檔名與 Figma Page 對應（html.to.design 保留 kebab-case）：

| Prototype 檔案 | Figma Page |
|----------------|------------|
| `01-landing.html` | `01-landing` |
| `02-dashboard.html` | `02-dashboard` |
| `12b-delete-confirm.html` | `12b-delete-confirm` |

規則：去掉 `.html` 副檔名即為 Figma Page 名稱。

## Flow Documentation

Prototype HTML 使用 `data-flow-*` 屬性標記頁面之間的流程關係，補足 Figma 無法表達的互動邏輯。

### data-flow-* 屬性

| 屬性 | 用途 | 範例 |
|------|------|------|
| `data-page` | 頁面識別（放在 body） | `data-page="dashboard"` |
| `data-flow-from` | 來源頁面/元件 | `data-flow-from="login:button-oauth"` |
| `data-flow-action` | 互動動作 | `data-flow-action="navigate"` |
| `data-flow-target` | 目標頁面/狀態 | `data-flow-target="view-bookmark"` |
| `data-flow-condition` | 條件式流程 | `data-flow-condition="ai-status:success"` |
| `data-component` | 元件類型 | `data-component="bookmark-card"` |
| `data-variant` | 元件狀態變體 | `data-variant="ai-processing"` |

### 產生 flows.md

```bash
# 在 design 目錄執行
node generate-flows.js
```

腳本會解析所有 prototype 的 `data-flow-*` 標記，自動產生：
- 頁面清單
- 流程定義（8 個主要流程）
- 頁面轉換矩陣
- 元件狀態變體
- AI 實作指引

### AI 實作時的使用方式

AI 在實作時應參考：
1. **Figma** - 視覺設計（顏色、間距、字型）
2. **flows.md** - 頁面流程、狀態轉換、路由邏輯

## Quick Reference

### 執行 Prototype 產出
```bash
/design.prototype
# 或指定 spec
/design.prototype .specify/specs/001-feature/spec.md
```

### 執行設計審查
```bash
/design.audit
# 自動讀取當前 feature 的 prototype 和 spec
```

### 產生流程文件
```bash
# 在 design 目錄執行
cd .specify/specs/{feature}/design
node generate-flows.js
```

### 建立 Figma 對應
```bash
/design.mapping https://figma.com/file/xxx
```

### 驗證設計整合
```bash
/design.verify              # 驗證全部
/design.verify plan         # 只驗證 plan
/design.verify tasks        # 只驗證 tasks
/design.verify --fix        # 自動修復
```

## Gap Handling

設計審查發現的差異必須處理：

| 差異類型 | 處理方式 |
|----------|----------|
| 新需求 | 加入 spec.md，重新執行 speckit 流程 |
| 延後功能 | 在 design.md 標記為 "Future" |
| 拒絕功能 | 從 prototype 移除 |

## Integration with spec-kit

設計流程與 spec-kit 的整合點：

1. **After `/speckit.specify`** → 執行 `/design.prototype`
2. **After `/design.audit`** → 執行 `node generate-flows.js` 產生 flows.md
3. **After `/design.mapping`** → 執行 `/speckit.plan`
4. **After `/speckit.plan`** → 執行 `/design.verify plan`
5. **After `/speckit.tasks`** → 執行 `/design.verify tasks`

### AI 實作時的參考順序

```
1. 讀取 spec.md        → 理解功能需求
2. 讀取 flows.md       → 理解頁面流程和狀態轉換
3. 參考 design.md      → 取得 Figma Node ID
4. 使用 Figma MCP      → 取得視覺設計細節
5. 實作程式碼
```

## Additional Resources

### Reference Files
- **`references/ui-ux-guidelines.md`** - UI/UX 設計規範與原則
- **`references/prototype-patterns.md`** - Prototype HTML 產出模式
- **`references/audit-rules.md`** - 設計審查規則
- **`references/figma-mapping.md`** - Figma 對應邏輯
- **`references/verification-rules.md`** - 驗證規則與修復邏輯
- **`references/flow-attributes.md`** - Flow 標記屬性規格

### Templates
- **`assets/design.md.template`** - design.md 模板
- **`assets/audit-report.template.md`** - 審查報告模板
- **`assets/flows.md.template`** - flows.md 模板

### Flow Documentation
- **`{feature}/design/flow-spec.md`** - 該功能的 Flow 標記規格
- **`{feature}/design/flows.md`** - 該功能的流程文件（自動產生）
- **`{feature}/design/generate-flows.js`** - Flow 產生腳本