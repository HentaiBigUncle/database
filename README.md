# ScholarLink 獎助學金管理系統

## 📋 系統架構

- **前端**: HTML + CSS + JavaScript
- **後端**: Node.js + Express
- **資料庫**: MySQL

## 🚀 快速開始

### 1. 安裝 MySQL 並建立資料庫

確保您已安裝 MySQL，然後執行：

```bash
mysql -u root -p < create_database.sql
```

這將建立 `scholarship_system` 資料庫及所有必要的表格和範例資料。

### 2. 安裝 Node.js 依賴

在專案目錄下執行：

```bash
npm install
```

### 3. 設定資料庫連線

編輯 `.env` 檔案，設定您的資料庫連線資訊：

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=scholarship_system
DB_PORT=3306

PORT=3000
```

### 4. 啟動伺服器

開發模式（自動重啟）：
```bash
npm run dev
```

或一般模式：
```bash
npm start
```

### 5. 訪問網頁

伺服器啟動後，在瀏覽器中訪問：

- **學生首頁**: http://localhost:3000/student.html
- **學生個人資料**: http://localhost:3000/student_profile.html
- **申請頁面**: http://localhost:3000/student_apply.html
- **查詢結果**: http://localhost:3000/student_results.html

## 📡 API 端點

### 學生相關

#### 取得學生資料
```
GET /api/student/:id
```

回應範例：
```json
{
  "success": true,
  "data": {
    "id": "S001",
    "name": "王小明",
    "email": "student@example.com",
    "identity": "一般生",
    "major": "資訊工程學系",
    "phones": ["0912345678", "02-1234-5678"],
    "additionalInfo": {}
  }
}
```

#### 更新學生資料
```
PUT /api/student/:id
Content-Type: application/json

{
  "name": "王小明",
  "email": "student@example.com",
  "identity": "僑生",
  "major": "資訊工程學系",
  "phones": ["0912345678"],
  "additionalInfo": {
    "overseas_id": "OS001",
    "chinese_certify": "華語文能力證明",
    "immigrate_date": "2020-08-15",
    "passport_number": "P123456789"
  }
}
```

#### 取得學生申請紀錄
```
GET /api/student/:id/applications
```

#### 取得所有獎學金
```
GET /api/scholarships
```

#### 提交獎學金申請
```
POST /api/application
Content-Type: application/json

{
  "student_id": "S001",
  "scholarship_name": "優秀學生獎學金",
  "apply_way": "線上申請",
  "score": 85.5,
  "gpa": 3.8,
  "family_income": 500000
}
```

## 🗄️ 資料庫結構

### 主要表格

- **User** - 使用者基礎表
- **Student** - 學生表
- **Teacher** - 教師表
- **Organization** - 捐贈機構表
- **Scholarship** - 獎學金表
- **Application** - 申請記錄表
- **Recommendation** - 推薦信表
- **Announcement** - 公告表

### 學生類型子表

- **Normal_Student** - 一般生
- **Overseas_Student** - 僑生
- **Aboriginal_Student** - 原住民
- **Low_Income_Student** - 低收入戶
- **Disabled_Student** - 身心障礙

## 🔧 功能說明

### 目前已實作功能

✅ **學生個人資料管理**
- 查看基本資料（姓名、學號、Email、電話、科系）
- 修改基本資料
- 根據學生身分別顯示/編輯額外資訊（如僑生資料）
- 資料即時同步到資料庫

✅ **資料庫整合**
- 完整的 MySQL 資料庫架構
- RESTful API 設計
- 交易處理確保資料一致性
- 錯誤處理機制

### 待實作功能

⏳ 獎學金申請流程
⏳ 申請結果查詢
⏳ 推薦信上傳與管理
⏳ 公告瀏覽
⏳ 教師端功能
⏳ 管理員端功能
⏳ 機構端功能

## 📝 測試資料

系統已預載以下測試資料：

### 學生帳號
- **學號**: S001
- **姓名**: 王小明
- **身分**: 一般生

- **學號**: S002
- **姓名**: 李小華
- **身分**: 僑生

### 獎學金
- 優秀學生獎學金 (NT$ 10,000)
- 清寒獎助學金 (NT$ 15,000)
- 僑生獎學金 (NT$ 12,000)

## 🔒 注意事項

1. 當前系統使用硬編碼的學生ID (`S001`)，實際應用需要實作登入系統
2. 資料庫密碼請勿提交到版本控制系統
3. 生產環境需要額外的安全措施（如身份驗證、授權、HTTPS等）
4. 建議使用環境變數管理敏感資訊

## 🐛 除錯

如果遇到資料庫連接錯誤：
1. 確認 MySQL 服務已啟動
2. 檢查 `.env` 中的連線資訊是否正確
3. 確認資料庫已建立：`scholarship_system`
4. 檢查防火牆設定是否允許連接

如果遇到 CORS 錯誤：
- 確認伺服器已啟動
- 檢查 API URL 是否正確

## 📞 支援

如有問題，請檢查：
1. 伺服器是否正常運行
2. 資料庫連接是否成功
3. 瀏覽器控制台是否有錯誤訊息

---

**ScholarLink** - 讓獎助學金申請更簡單 ✨
