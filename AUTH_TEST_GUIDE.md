# 🔐 身分驗證與權限控制測試指南

## ✅ 已實現功能

### 1. 身分驗證系統
- ✅ 未登入用戶訪問受保護頁面 → 自動重定向到登入頁面
- ✅ 登入後根據身分類型跳轉到對應頁面
- ✅ 每個角色只能訪問自己權限的頁面

### 2. 權限控制
- **學生（Student）**：可訪問
  - student_dashboard.html（學生儀表板）
  - student_profile_apache.html（個人資料編輯）
  - scholarship_portal.html（獎學金申請）

- **教師（Teacher）**：可訪問
  - teacher.html（教師端）

- **系統管理員（SystemAdministrator）**：可訪問
  - admin.html（管理員端）

- **獎學金機構（Organization）**：可訪問
  - organization.html（機構端）

### 3. 跨權限保護
- ❌ 學生無法訪問教師/管理員/機構頁面
- ❌ 教師無法訪問學生/管理員/機構頁面
- ❌ 以此類推...

## 🧪 測試步驟

### 測試 1：未登入保護
1. 直接訪問：`http://localhost/scholarship/student_dashboard.html`
2. **預期結果**：自動重定向到 `login.html`

### 測試 2：學生登入
1. 訪問：`http://localhost/scholarship/login.html`
2. 輸入學號：`S001`
3. 點擊登入
4. **預期結果**：
   - 顯示「登入成功！歡迎 王小明」
   - 自動跳轉到學生儀表板
   - 可以看到獎學金列表和申請記錄

### 測試 3：學生訪問個人資料
1. 登入後點擊導航列的「個人資料」
2. **預期結果**：
   - 成功進入個人資料編輯頁面
   - 顯示當前登入學生的資料（王小明/S001）

### 測試 4：學生嘗試訪問教師頁面（權限測試）
1. 以學生身分登入（S001）
2. 在網址列輸入：`http://localhost/scholarship/teacher.html`
3. **預期結果**：
   - 彈出提示「您沒有權限訪問此頁面」
   - 自動重定向回學生儀表板

### 測試 5：教師登入
1. 登出學生帳號
2. 訪問：`http://localhost/scholarship/login.html`
3. 輸入教師編號：`T001`
4. 點擊登入
5. **預期結果**：
   - 跳轉到教師端頁面
   - 顯示「歡迎，張教授教授」

### 測試 6：教師嘗試訪問學生頁面（權限測試）
1. 以教師身分登入（T001）
2. 嘗試訪問：`http://localhost/scholarship/student_dashboard.html`
3. **預期結果**：
   - 彈出「您沒有權限訪問此頁面」
   - 重定向回教師端

### 測試 7：管理員登入
1. 使用管理員ID：`A001`
2. **預期結果**：跳轉到管理員頁面

### 測試 8：登出功能
1. 在任何已登入頁面點擊「登出」
2. **預期結果**：
   - 清除登入狀態
   - 重定向到登入頁面
   - 無法再訪問受保護頁面

## 📋 測試帳號清單

| 身分 | ID | 姓名 | 可訪問頁面 |
|------|-----|------|-----------|
| 學生 | S001 | 王小明 | student_dashboard, student_profile, scholarship_portal |
| 學生 | S002 | 李小華 | student_dashboard, student_profile, scholarship_portal |
| 教師 | T001 | 張教授 | teacher |
| 管理員 | A001 | 系統管理員 | admin |

## 🔧 技術實現

### auth.js（身分驗證核心）
```javascript
function checkAuth(allowedRoles = []) {
  // 檢查 sessionStorage 中的登入狀態
  // 驗證用戶類型是否在允許清單中
  // 不符合則重定向
}
```

### 每個頁面的保護方式
```html
<script src="auth.js"></script>
<script>
  // 頁面載入時立即檢查
  const currentUser = checkAuth(['Student']); // 只允許學生
  if (!currentUser) {
    throw new Error('Unauthorized');
  }
</script>
```

## ✨ 安全特性

1. **客戶端驗證**：頁面載入時立即檢查身分
2. **自動重定向**：未登入或權限不足自動導向
3. **類型限制**：每個頁面指定允許的用戶類型
4. **會話管理**：使用 sessionStorage 儲存登入狀態
5. **登出清除**：登出時清除所有身分資訊

## 🎯 快速開始

```
1. 訪問 http://localhost/scholarship/login.html
2. 使用 S001 登入（學生）
3. 體驗學生端功能
4. 登出後使用 T001 登入（教師）
5. 嘗試訪問學生頁面，驗證權限保護
```

---

**注意**：這是前端身分驗證，實際生產環境還需要後端 API 的權限驗證！
