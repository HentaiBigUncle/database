# 🎓 ScholarLink 獎助學金管理系統 - 整合說明

## 📁 檔案結構

```
database/
├── create_database.sql          # MySQL 資料庫建構腳本
├── server.js                    # Node.js 後端伺服器
├── package.json                 # Node.js 專案設定檔
├── .env                         # 環境變數設定（資料庫連線）
│
├── student_profile.html         # 學生個人資料（完整版 - 需 Node.js）
├── student_profile_test.html    # 學生個人資料（測試版 - 無需資料庫）
├── student.html                 # 學生首頁
├── student_apply.html           # 獎學金申請頁面
├── student_results.html         # 申請結果查詢
│
├── teacher.html                 # 教師端頁面
├── organization.html            # 機構端頁面
├── admin.html                   # 管理員端頁面
├── index.html                   # 登入頁面
│
├── README.md                    # 系統功能說明
├── INSTALL.md                   # 詳細安裝指南
└── INTEGRATION.md               # 本檔案
```

## 🚀 快速開始

### 方案一：測試版（無需安裝任何軟體）

**立即可用！**

1. 直接用瀏覽器打開 `student_profile_test.html`
2. 這個版本使用 LocalStorage 儲存資料
3. 可以測試所有基本功能

**優點**：
- ✅ 無需安裝 Node.js 或 MySQL
- ✅ 立即可用
- ✅ 適合快速測試和展示

**限制**：
- ❌ 資料只儲存在瀏覽器
- ❌ 無法多人共用資料
- ❌ 清除瀏覽器資料會遺失

### 方案二：完整版（需要安裝軟體）

**完整功能版本**

#### 需要安裝：
1. **Node.js** (下載：https://nodejs.org/)
2. **MySQL** (下載：https://dev.mysql.com/downloads/mysql/ 或使用 XAMPP)

#### 安裝步驟：

```powershell
# 1. 建立 MySQL 資料庫
mysql -u root -p < create_database.sql

# 2. 設定 .env 檔案
# 編輯 .env，填入您的 MySQL 密碼

# 3. 安裝 Node.js 套件
npm install

# 4. 啟動伺服器
npm start

# 5. 開啟瀏覽器
# 訪問 http://localhost:3000/student_profile.html
```

詳細步驟請參考 [INSTALL.md](INSTALL.md)

## 🎯 目前已實作的功能

### ✅ 學生個人資料管理

#### 完整版功能（student_profile.html）：
- 從資料庫載入學生資料
- 編輯基本資料（姓名、Email、電話、科系）
- 根據身分別顯示不同欄位
  - 一般生：基本資料
  - 僑生：額外需要僑生編號、華語證明、入境日期、護照號碼
  - 原住民：原住民證明
  - 低收入戶：低收證明
  - 身心障礙：身障手冊、等級
- 儲存資料到 MySQL 資料庫
- 即時顯示成功/錯誤訊息

#### 測試版功能（student_profile_test.html）：
- 相同的使用者介面
- 使用 LocalStorage 儲存
- 即時預覽儲存的資料
- 清除資料功能

## 📡 API 設計

### 已實作的 API 端點：

```javascript
// 取得學生資料
GET /api/student/:id

// 更新學生資料
PUT /api/student/:id

// 取得學生的申請紀錄
GET /api/student/:id/applications

// 取得所有獎學金
GET /api/scholarships

// 提交獎學金申請
POST /api/application
```

### API 使用範例：

```javascript
// 取得學生資料
fetch('http://localhost:3000/api/student/S001')
  .then(res => res.json())
  .then(data => console.log(data));

// 更新學生資料
fetch('http://localhost:3000/api/student/S001', {
  method: 'PUT',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    name: '王小明',
    email: 'new@example.com',
    identity: '僑生',
    major: '資訊工程學系',
    phones: ['0912345678'],
    additionalInfo: {
      overseas_id: 'OS001',
      chinese_certify: '證明文件',
      immigrate_date: '2020-08-15',
      passport_number: 'P123456789'
    }
  })
})
.then(res => res.json())
.then(data => console.log(data));
```

## 🗄️ 資料庫設計

### 核心表格結構：

```sql
-- 使用者主表（支援繼承）
User (id, name, email, type)
  └── User_Phone (user_id, phone)  -- 多值屬性
  
  ├── Student (id, identity, major)
  │    ├── Normal_Student (id)
  │    ├── Overseas_Student (id, overseas_id, chinese_certify, ...)
  │    ├── Aboriginal_Student (id, aboriginal_certify)
  │    ├── Low_Income_Student (id, low_income_certify)
  │    └── Disabled_Student (id, disabled_certify, disabled_level)
  │
  ├── Teacher (id, faculty)
  ├── Organization (id, contact_person, receiving_way)
  └── System_Administrator (id)

-- 獎學金
Scholarship (name, amount, description)
  └── Scholarship_Organization (scholarship_name, organization_id)

-- 申請
Application (id, student_id, scholarship_name, apply_state, score, gpa, ...)
  └── Recommendation (id, content, teacher_id)

-- 公告
Announcement (announce_id, type, admin_id)
  ├── Apply_Announcement (announce_id, apply_date, apply_deadline, ...)
  └── Result_Announcement (announce_id, result, announce_date, ...)
```

## 🔄 資料流程

### 學生修改基本資料流程：

```
1. 學生開啟 student_profile.html
   ↓
2. JavaScript 發送 GET 請求到 /api/student/S001
   ↓
3. Node.js 伺服器查詢 MySQL 資料庫
   ↓
4. 回傳 JSON 資料到前端
   ↓
5. JavaScript 填充表單欄位
   ↓
6. 學生修改資料後按下「儲存變更」
   ↓
7. JavaScript 發送 PUT 請求到 /api/student/S001
   ↓
8. Node.js 伺服器更新 MySQL 資料庫（使用 Transaction）
   ↓
9. 回傳成功訊息
   ↓
10. JavaScript 顯示成功訊息並跳轉
```

## 🔐 安全性考量

### 目前實作：
- ✅ SQL Injection 防護（使用 Prepared Statements）
- ✅ Transaction 確保資料一致性
- ✅ CORS 設定
- ✅ 錯誤處理機制

### 建議加強（生產環境）：
- ⚠️ 實作使用者登入認證
- ⚠️ 加入 JWT Token 驗證
- ⚠️ 實作 HTTPS
- ⚠️ 密碼加密（bcrypt）
- ⚠️ Rate Limiting（防止 API 濫用）
- ⚠️ Input Validation（更嚴格的輸入驗證）

## 📝 測試清單

### 測試學生資料修改（完整版）

```
□ 啟動 MySQL 服務
□ 執行 create_database.sql 建立資料庫
□ 設定 .env 檔案
□ 執行 npm install
□ 執行 npm start
□ 訪問 http://localhost:3000/student_profile.html
□ 確認資料正確載入（王小明）
□ 修改姓名為「張三」
□ 修改 Email
□ 新增第二個電話號碼
□ 點擊儲存
□ 確認顯示成功訊息
□ 重新整理頁面
□ 確認資料已更新
□ 在 MySQL 中查詢確認資料已儲存
```

### 測試學生資料修改（測試版）

```
□ 直接開啟 student_profile_test.html
□ 確認預設資料載入（王小明）
□ 修改資料
□ 點擊儲存
□ 確認右側預覽區顯示更新的資料
□ 重新整理頁面
□ 確認資料保留
□ 點擊「清除所有資料」
□ 確認資料重置為預設值
```

### 測試身分別切換

```
□ 選擇「境外學生（僑生/外籍生）」
□ 確認顯示僑生額外欄位
□ 填寫僑生資料
□ 儲存
□ 重新載入，確認僑生資料保留
□ 改回「一般生」
□ 確認僑生欄位隱藏
```

## 🐛 除錯指南

### 問題：資料庫連接失敗

**症狀**：
```
❌ 資料庫連接失敗: connect ECONNREFUSED
```

**解決方法**：
1. 確認 MySQL 服務已啟動
2. 檢查 `.env` 中的帳號密碼
3. 測試連線：`mysql -u root -p`
4. 檢查防火牆設定

### 問題：頁面無法載入資料

**症狀**：頁面顯示「載入中...」不會消失

**解決方法**：
1. 開啟瀏覽器開發者工具（F12）
2. 查看 Console 標籤的錯誤訊息
3. 查看 Network 標籤，檢查 API 請求狀態
4. 確認使用 `http://localhost:3000` 而非直接開啟檔案
5. 確認伺服器已啟動

### 問題：儲存後資料沒更新

**檢查項目**：
```sql
-- 在 MySQL 中執行
USE scholarship_system;
SELECT * FROM User WHERE id = 'S001';
SELECT * FROM Student WHERE id = 'S001';
SELECT * FROM User_Phone WHERE user_id = 'S001';
```

如果資料庫沒更新，檢查：
1. 伺服器 Console 是否有錯誤
2. Transaction 是否成功
3. 欄位名稱是否正確

## 📈 後續開發建議

### 短期（1-2週）

1. **完善學生申請功能**
   - 串接 `student_apply.html`
   - 實作申請表單提交
   - 檔案上傳功能

2. **查詢結果功能**
   - 串接 `student_results.html`
   - 顯示申請狀態
   - 查看審核結果

3. **基本認證系統**
   - 登入功能
   - Session 管理
   - 權限控制

### 中期（3-4週）

4. **教師端功能**
   - 推薦信撰寫
   - 學生列表查看
   - 推薦信歷史紀錄

5. **機構端功能**
   - 獎學金管理
   - 申請審核
   - 結果公告

6. **管理員功能**
   - 使用者管理
   - 系統公告
   - 統計報表

### 長期（1-2個月）

7. **進階功能**
   - Email 通知系統
   - PDF 文件生成
   - 資料匯出功能
   - Dashboard 儀表板

8. **效能優化**
   - 資料庫索引優化
   - API 快取機制
   - 分頁功能

9. **使用者體驗**
   - 更豐富的錯誤提示
   - 載入動畫
   - 表單驗證改進

## 📚 相關文件

- [README.md](README.md) - 系統概述和 API 說明
- [INSTALL.md](INSTALL.md) - 詳細安裝步驟
- [create_database.sql](create_database.sql) - 資料庫建構腳本
- [server.js](server.js) - 後端程式碼

## 💡 提示

### 開發時的最佳實踐：

1. **使用版本控制**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   ```

2. **備份資料庫**
   ```bash
   mysqldump -u root -p scholarship_system > backup.sql
   ```

3. **使用開發工具**
   - VS Code + MySQL 擴充
   - Postman 測試 API
   - Chrome DevTools 除錯前端

4. **寫註解**
   - API 端點用途
   - 複雜邏輯說明
   - TODO 標記待辦事項

## ✨ 總結

您現在有兩個版本可以使用：

1. **測試版** (`student_profile_test.html`)
   - 立即可用，無需安裝
   - 適合快速展示和測試

2. **完整版** (`student_profile.html` + `server.js` + MySQL)
   - 完整資料庫整合
   - 多人共用資料
   - 適合實際部署

選擇適合您需求的版本開始使用吧！🚀

---

需要協助？請參考：
- 📖 [INSTALL.md](INSTALL.md) - 安裝問題
- 📡 [README.md](README.md) - API 使用
- 💾 [create_database.sql](create_database.sql) - 資料庫結構

祝開發順利！✨
