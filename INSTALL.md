# 🚀 ScholarLink 系統安裝指南

## 📦 必要軟體安裝

### 1. 安裝 Node.js

#### 方法一：從官網下載（推薦）
1. 前往 https://nodejs.org/
2. 下載 LTS 版本（長期支援版）
3. 執行安裝程式，使用預設設定即可
4. 安裝完成後，重新開啟 PowerShell 或命令提示字元

#### 方法二：使用 Chocolatey（Windows 套件管理器）
```powershell
# 如果已安裝 Chocolatey
choco install nodejs-lts
```

#### 驗證安裝
```powershell
node --version
npm --version
```

應該顯示版本號，例如：
```
v20.11.0
10.2.4
```

### 2. 安裝 MySQL

#### 方法一：從官網下載
1. 前往 https://dev.mysql.com/downloads/mysql/
2. 下載 Windows 版本的 MySQL Community Server
3. 執行安裝程式
4. 安裝過程中記住您設定的 root 密碼

#### 方法二：使用 XAMPP（包含 MySQL）
1. 前往 https://www.apachefriends.org/
2. 下載並安裝 XAMPP
3. 啟動 XAMPP 控制面板
4. 啟動 MySQL 服務

#### 驗證 MySQL 安裝
```powershell
mysql --version
```

---

## 🔧 系統設定步驟

### 步驟 1: 建立資料庫

開啟 MySQL 命令列：

```bash
# 登入 MySQL
mysql -u root -p

# 輸入您的密碼後，執行資料庫建立腳本
source C:/Users/user/Desktop/大三作業/database/create_database.sql

# 或直接在 PowerShell 執行
mysql -u root -p < "C:\Users\user\Desktop\大三作業\database\create_database.sql"
```

### 步驟 2: 設定環境變數

編輯 `.env` 檔案，填入您的 MySQL 密碼：

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=您的MySQL密碼
DB_NAME=scholarship_system
DB_PORT=3306

PORT=3000
```

### 步驟 3: 安裝 Node.js 套件

在專案目錄開啟 PowerShell：

```powershell
cd "C:\Users\user\Desktop\大三作業\database"
npm install
```

這將安裝以下套件：
- express (Web 框架)
- mysql2 (MySQL 驅動)
- cors (跨域資源共享)
- dotenv (環境變數管理)
- body-parser (請求解析)

### 步驟 4: 啟動伺服器

```powershell
npm start
```

或開發模式（自動重啟）：
```powershell
npm run dev
```

看到以下訊息表示成功：
```
✅ 資料庫連接成功！
🚀 伺服器運行在 http://localhost:3000
📄 學生個人資料頁面: http://localhost:3000/student_profile.html
📄 學生首頁: http://localhost:3000/student.html
```

### 步驟 5: 開啟瀏覽器測試

在瀏覽器中訪問：
- http://localhost:3000/student_profile.html

---

## ✅ 功能測試清單

### 測試學生資料修改功能

1. ✅ 打開 http://localhost:3000/student_profile.html
2. ✅ 頁面應該自動載入學生資料（王小明）
3. ✅ 修改姓名、Email、電話號碼
4. ✅ 點擊「儲存變更」
5. ✅ 應該顯示成功訊息並跳轉回首頁
6. ✅ 再次進入個人資料頁面，確認資料已更新

### 測試身分別切換

1. ✅ 將身分別改為「境外學生（僑生/外籍生）」
2. ✅ 應該自動顯示僑生額外資訊欄位
3. ✅ 填寫僑生資料（僑生編號、華語證明等）
4. ✅ 儲存後資料應正確保存到資料庫

### 驗證資料庫更新

在 MySQL 中執行查詢：

```sql
USE scholarship_system;

-- 查看學生資料
SELECT * FROM User WHERE id = 'S001';
SELECT * FROM Student WHERE id = 'S001';

-- 查看電話號碼
SELECT * FROM User_Phone WHERE user_id = 'S001';

-- 查看僑生資料（如果改為僑生）
SELECT * FROM Overseas_Student WHERE id = 'S001';
```

---

## 🐛 常見問題排除

### 問題 1: npm 不是內部或外部命令

**解決方法**：
- 確認已安裝 Node.js
- 重新開啟 PowerShell
- 檢查環境變數 PATH 是否包含 Node.js 路徑

### 問題 2: 資料庫連接失敗

**檢查項目**：
1. MySQL 服務是否啟動
2. `.env` 中的密碼是否正確
3. 資料庫 `scholarship_system` 是否已建立
4. 防火牆是否阻擋 3306 連接埠

**測試連接**：
```powershell
mysql -u root -p -h localhost -P 3306
```

### 問題 3: 頁面無法載入資料

**檢查項目**：
1. 伺服器是否運行中（應顯示「伺服器運行在...」）
2. 開啟瀏覽器開發者工具（F12）查看 Console 是否有錯誤
3. 檢查 Network 標籤，確認 API 請求是否成功
4. 確認使用 `http://localhost:3000` 而非直接開啟 HTML 檔案

### 問題 4: CORS 錯誤

**解決方法**：
- 確保透過 `http://localhost:3000` 訪問，而不是直接開啟檔案（file://）
- 檢查伺服器是否已啟動 CORS 中介層

### 問題 5: 修改資料後沒有更新

**檢查項目**：
1. 開啟瀏覽器 Console 查看錯誤訊息
2. 檢查伺服器 Console 是否有錯誤
3. 確認表單欄位的 name 屬性是否正確
4. 檢查資料庫是否有更新（執行 SQL 查詢）

---

## 📊 系統架構圖

```
┌─────────────────┐
│  瀏覽器 (前端)   │
│  student_profile │
│     .html        │
└────────┬────────┘
         │ HTTP Request (GET/PUT)
         │ http://localhost:3000/api/student/:id
         ↓
┌─────────────────┐
│  Node.js 伺服器  │
│  (server.js)    │
│  Express + API  │
└────────┬────────┘
         │ SQL Query
         ↓
┌─────────────────┐
│  MySQL 資料庫    │
│  scholarship_   │
│    system       │
└─────────────────┘
```

---

## 📱 下一步

完成學生個人資料功能後，您可以繼續開發：

1. 📝 **申請功能** - 學生申請獎學金
2. 📊 **查詢結果** - 查看申請狀態
3. 👨‍🏫 **教師端** - 推薦信管理
4. 🏢 **機構端** - 獎學金管理
5. ⚙️ **管理員端** - 系統設定與公告

---

## 💡 開發建議

### 使用 VS Code

推薦安裝以下擴充功能：
- **MySQL** - MySQL 管理工具
- **REST Client** - 測試 API
- **Live Server** - 即時預覽（但最好透過 Node.js 伺服器）
- **ESLint** - JavaScript 語法檢查

### API 測試工具

- **Postman** - https://www.postman.com/
- **Insomnia** - https://insomnia.rest/
- **Thunder Client** (VS Code 擴充)

### 資料庫管理工具

- **MySQL Workbench** - 官方工具
- **HeidiSQL** - 輕量級工具
- **DBeaver** - 跨平台工具

---

需要協助？檢查以下項目：
✅ Node.js 是否已安裝
✅ MySQL 是否正在運行
✅ 資料庫是否已建立
✅ .env 設定是否正確
✅ 伺服器是否已啟動
✅ 是否透過 localhost:3000 訪問

祝開發順利！🎉
