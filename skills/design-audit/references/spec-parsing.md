# Spec Parsing Rules

從 spec.md 提取可比對項目的規則。

---

## 解析目標

### 1. User Stories

**格式識別**：

```markdown
## User Stories

### US-1: 用戶登入
作為一個用戶，我可以使用帳號密碼登入系統

### US-2: 用戶註冊
作為一個訪客，我可以註冊新帳號
```

或

```markdown
## User Stories

- **US-1**: 作為用戶，我可以登入系統
- **US-2**: 作為訪客，我可以註冊新帳號
```

**提取結果**：

```json
{
  "id": "US-1",
  "title": "用戶登入",
  "actor": "用戶",
  "action": "使用帳號密碼登入系統",
  "keywords": ["登入", "帳號", "密碼"]
}
```

### 2. Features / Requirements

```markdown
## Features

### F-1: 登入功能
- 支援帳號密碼登入
- 支援記住我選項
- 錯誤訊息提示

### F-2: 註冊功能
- 收集基本資料
- Email 驗證
- 密碼強度檢查
```

**提取結果**：

```json
{
  "id": "F-1",
  "name": "登入功能",
  "items": [
    "支援帳號密碼登入",
    "支援記住我選項",
    "錯誤訊息提示"
  ],
  "keywords": ["登入", "帳號", "密碼", "記住我", "錯誤"]
}
```

### 3. Acceptance Criteria

```markdown
### US-1 Acceptance Criteria

- [ ] 可以輸入帳號（email 格式）
- [ ] 可以輸入密碼（隱藏顯示）
- [ ] 點擊登入按鈕可以送出表單
- [ ] 登入失敗顯示錯誤訊息
- [ ] 登入成功跳轉到首頁
```

**提取結果**：

```json
{
  "parent": "US-1",
  "criteria": [
    {
      "id": "AC-1.1",
      "description": "可以輸入帳號（email 格式）",
      "keywords": ["輸入", "帳號", "email"],
      "uiImplication": "email input field"
    },
    {
      "id": "AC-1.2",
      "description": "可以輸入密碼（隱藏顯示）",
      "keywords": ["輸入", "密碼", "隱藏"],
      "uiImplication": "password input field"
    }
  ]
}
```

### 4. UI Requirements（如果有）

```markdown
## UI 需求

### 登入頁面
- 登入表單（帳號、密碼欄位）
- 登入按鈕
- 忘記密碼連結
- 註冊連結

### 註冊頁面
- 註冊表單
- 服務條款勾選
- 註冊按鈕
```

### 5. Data Models（推斷 UI 欄位）

```markdown
## Data Models

### User
| Field | Type | Required |
|-------|------|----------|
| email | string | yes |
| password | string | yes |
| name | string | yes |
| phone | string | no |
```

**推斷**：註冊表單應該有 email, password, name, phone 欄位

---

## 關鍵字提取

從每個 spec 項目提取關鍵字，用於模糊匹配：

```javascript
function extractKeywords(text) {
  // 動詞
  const verbs = ['登入', '註冊', '提交', '搜尋', '刪除', '編輯', '新增'];
  
  // 名詞
  const nouns = ['帳號', '密碼', '表單', '按鈕', '連結', '列表', '表格'];
  
  // UI 元素
  const uiElements = ['input', 'button', 'link', 'form', 'modal', 'dropdown'];
  
  return extractMatches(text, [...verbs, ...nouns, ...uiElements]);
}
```

---

## Spec 結構識別

支援多種 spec 格式：

### 格式 A：spec-kit 標準格式

```markdown
# Feature: User Authentication

## Overview
...

## User Stories
...

## Requirements
...

## Acceptance Criteria
...
```

### 格式 B：PRD 格式

```markdown
# Product Requirements Document

## Problem Statement
...

## User Personas
...

## Functional Requirements
...

## Non-Functional Requirements
...
```

### 格式 C：簡易格式

```markdown
# Auth Feature

## What
- 登入功能
- 註冊功能

## Details
- 登入需要帳號密碼
- 註冊需要 email 驗證
```

---

## 輸出格式

```json
{
  "parsedAt": "2024-01-15T10:30:00Z",
  "specPath": "specs/auth/spec.md",
  "summary": {
    "userStories": 5,
    "features": 3,
    "acceptanceCriteria": 15,
    "uiRequirements": 8
  },
  "userStories": [...],
  "features": [...],
  "acceptanceCriteria": [...],
  "uiRequirements": [...],
  "inferredUIElements": [...],
  "allKeywords": [...]
}
```
