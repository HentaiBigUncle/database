# 🎯 完整版安裝 - 當前狀態

## ✅ 已完成

### 1. Node.js ✅
- **版本**: v25.2.1
- **狀態**: 已安裝並運作正常

### 2. npm 套件 ✅  
- **狀態**: 已安裝（111 個套件）
- **套件**: Express, MySQL2, CORS, dotenv, body-parser

### 3. XAMPP MySQL ✅
- **位置**: C:\xampp\mysql\bin\mysql.exe
- **版本**: MariaDB 10.4.32

---

## ⏳ 待完成

### 4. 啟動 MySQL 服務並建立資料庫

請按照以下步驟操作：

#### 步驟 A: 啟動 XAMPP MySQL

1. 開啟 **XAMPP Control Panel**
   - 位置通常在：`C:\xampp\xampp-control.exe`
   - 或從開始選單搜尋 "XAMPP"

2. 在 XAMPP Control Panel 中：
   - 找到 **MySQL** 那一行
   - 點擊 **Start** 按鈕
   - 狀態應該變成綠色，顯示 "Running"

   ![XAMPP示意圖]
   ```
   Module     | Action | Status
   --------------------------------
   Apache     | ...    | 
   MySQL      | Start  | ✅ Running (綠色)
   ```

#### 步驟 B: 確認 MySQL root 密碼

XAMPP 預設有兩種情況：

**情況 1: 沒有密碼（最常見）**
```powershell
# 測試連接
mysql -u root

# 如果成功，您會看到 MySQL 提示字元：
# MariaDB [(none)]>
```

**情況 2: 有密碼**
```powershell
# 需要輸入密碼
mysql -u root -p
# 然後輸入密碼
```

#### 步驟 C: 建立資料庫

**方法 1: 使用 PowerShell 腳本（推薦）**

在 PowerShell 中執行：
```powershell
# 進入專案目錄
cd "C:\Users\user\Desktop\大三作業\database"

# 執行建立腳本
.\create_db.ps1
```

腳本會詢問您的 MySQL 密碼：
- 如果沒有密碼，直接按 **Enter**
- 如果有密碼，輸入密碼後按 **Enter**

**方法 2: 手動執行 SQL（如果腳本失敗）**

```powershell
# 如果沒有密碼
mysql -u root < "create_database.sql"

# 如果有密碼
mysql -u root -p < "create_database.sql"
# 然後輸入密碼
```

**方法 3: 使用 phpMyAdmin（最簡單的圖形介面）**

1. 確保 XAMPP 的 MySQL 和 Apache 都已啟動
2. 開啟瀏覽器，訪問：http://localhost/phpmyadmin
3. 點擊上方的 **SQL** 標籤
4. 開啟 `create_database.sql` 檔案，複製所有內容
5. 貼到 SQL 輸入框中
6. 點擊 **執行**（Go）

#### 步驟 D: 更新 .env 檔案

編輯 `.env` 檔案，確保密碼正確：

**如果沒有密碼：**
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=
DB_NAME=scholarship_system
DB_PORT=3306

PORT=3000
```

**如果有密碼：**
```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=你的密碼
DB_NAME=scholarship_system
DB_PORT=3306

PORT=3000
```

#### 步驟 E: 驗證資料庫建立成功

```powershell
# 連接到 MySQL
mysql -u root -p

# 在 MySQL 提示字元中執行：
USE scholarship_system;
SHOW TABLES;

# 應該看到多個表格，如：
# +--------------------------------+
# | Tables_in_scholarship_system   |
# +--------------------------------+
# | Aboriginal_Student             |
# | Announcement                   |
# | Application                    |
# | ...                            |
# +--------------------------------+

# 查看範例資料
SELECT * FROM User;

# 退出
exit
```

---

## 🚀 啟動系統

完成以上步驟後：

```powershell
# 1. 確保在專案目錄
cd "C:\Users\user\Desktop\大三作業\database"

# 2. 啟動伺服器
npm start

# 應該看到：
# ✅ 資料庫連接成功！
# 🚀 伺服器運行在 http://localhost:3000
# 📄 學生個人資料頁面: http://localhost:3000/student_profile.html
```

## 🌐 測試系統

1. 開啟瀏覽器
2. 訪問：http://localhost:3000/student_profile.html
3. 應該看到學生資料（王小明）自動載入
4. 嘗試修改資料並儲存
5. 重新整理頁面確認資料已更新

---

## 🐛 疑難排解

### 問題：無法連接 MySQL

**症狀**：
```
ERROR 1045 (28000): Access denied for user 'root'@'localhost'
```

**解決方案**：

1. **確認 MySQL 已啟動**
   - 開啟 XAMPP Control Panel
   - MySQL 狀態應該是綠色 "Running"

2. **重設 MySQL root 密碼（如果忘記）**
   ```powershell
   # 停止 MySQL（在 XAMPP Control Panel）
   # 然後執行：
   cd C:\xampp\mysql\bin
   mysqld --skip-grant-tables
   
   # 在另一個 PowerShell 視窗：
   mysql -u root
   USE mysql;
   UPDATE user SET password=PASSWORD("") WHERE user='root';
   FLUSH PRIVILEGES;
   exit
   
   # 重新啟動 MySQL（在 XAMPP Control Panel）
   ```

3. **使用 phpMyAdmin**
   - 訪問 http://localhost/phpmyadmin
   - 如果能進入，說明連接正常
   - 可以直接在裡面執行 SQL

### 問題：伺服器啟動失敗

**檢查清單**：
- [ ] MySQL 服務已啟動
- [ ] `.env` 檔案存在且密碼正確
- [ ] 資料庫 `scholarship_system` 已建立
- [ ] 防火牆沒有封鎖 3000 和 3306 埠

### 問題：頁面無法載入資料

**檢查步驟**：
1. 開啟瀏覽器 F12 開發者工具
2. 查看 Console 是否有錯誤
3. 查看 Network 標籤，檢查 API 請求狀態
4. 確認使用 `http://localhost:3000` 而非直接開啟檔案

---

## 📞 需要協助？

### 快速測試命令

```powershell
# 1. 測試 Node.js
node --version

# 2. 測試 npm
npm --version

# 3. 測試 MySQL 連接
mysql -u root -e "SELECT 'OK' AS Status;"

# 4. 測試資料庫
mysql -u root -e "USE scholarship_system; SELECT COUNT(*) FROM User;"

# 5. 測試伺服器
npm start
```

### 完整重裝流程

如果遇到太多問題，可以完全重來：

```powershell
# 1. 刪除資料庫
mysql -u root -e "DROP DATABASE IF EXISTS scholarship_system;"

# 2. 刪除 node_modules
Remove-Item -Recurse -Force node_modules

# 3. 重新安裝套件
npm install

# 4. 重新建立資料庫
.\create_db.ps1

# 5. 啟動
npm start
```

---

## ✨ 下一步

完成安裝後，您可以：

1. 📝 修改學生資料並儲存到資料庫
2. 🔍 在 MySQL 中查詢驗證資料
3. 🎨 開始開發其他功能（申請、查詢結果等）
4. 📚 參考 README.md 了解 API 用法

---

**當前進度：85% 完成** 🎯

只需要啟動 MySQL 服務並建立資料庫，就大功告成了！
