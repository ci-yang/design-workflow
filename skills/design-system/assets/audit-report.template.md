# Design Audit Report

**Prototype**: .specify/specs/{FEATURE}/design/prototype/
**Spec**: .specify/specs/{FEATURE}/spec.md
**審查時間**: {TIMESTAMP}

---

## 摘要

| 分類 | 數量 |
|------|------|
| ✅ 對齊 | {ALIGNED_COUNT} |
| ⚠️ 設計額外 | {EXTRA_COUNT} |
| ❌ 規格遺漏 | {MISSING_COUNT} |

---

## ⚠️ 設計額外（Prototype 有，Spec 沒有）

以下元素在 Prototype 中存在，但 Spec 沒有明確提到：

### 1. {ELEMENT_NAME}

**位置**: `{FILE_PATH}`
**類型**: {TYPE: button/link/component/field}
**內容**:
```html
{HTML_SNIPPET}
```

**建議處理**:
- [ ] 加入 Spec（新需求）
- [ ] 標記為 Future（延後）
- [ ] 從 Prototype 移除（拒絕）

**若加入 Spec，建議內容**:
```markdown
- US-{N}: 作為用戶，我可以{ACTION}
  - AC: {ACCEPTANCE_CRITERIA}
```

---

<!-- 重複上述格式，列出所有設計額外項目 -->

---

## ❌ 規格遺漏（Spec 有，Prototype 沒有）

以下 Spec 項目在 Prototype 中找不到對應實作：

### 1. {SPEC_ITEM}

**來源**: {SPEC_ID}
**描述**: {DESCRIPTION}
**建議**: 在 Prototype 中加入此功能

---

<!-- 重複上述格式，列出所有規格遺漏項目 -->

---

## ✅ 對齊項目

| Prototype 元素 | 對應 Spec | 匹配方式 |
|----------------|----------|----------|
| {ELEMENT} | {SPEC_ID}: {BRIEF} | {METHOD: 精確/關鍵字/文字} |

---

## 處理決策記錄

| 項目 | 決策 | 處理人 | 日期 |
|------|------|--------|------|
<!-- 填入處理結果 -->

---

## 下一步

- [ ] 處理所有設計額外項目
- [ ] 補齊規格遺漏項目
- [ ] 重新執行審查確認
- [ ] 推送 Figma
- [ ] 執行 `/design.mapping`
