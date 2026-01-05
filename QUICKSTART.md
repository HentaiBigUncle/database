# 🚀 快速安裝指南

## 方法一：手動安裝（最可靠）

### 1️⃣ 安裝 Node.js

1. 訪問：https://nodejs.org/
2. 下載 **LTS 版本**（左邊的按鈕）
3. 執行安裝程式，一直按「下一步」
4. **重新開啟 PowerShell**

驗證安裝：
```powershell
node --version
npm --version
```

### 2️⃣ 安裝 MySQL

**選項 A：使用 XAMPP（推薦新手）**
1. 訪問：https://www.apachefriends.org/
2. 下載 XAMPP for Windows
3. 安裝後啟動 XAMPP Control Panel
4. 點擊 MySQL 的「Start」按鈕
5. 預設密碼為空（直接按 Enter）

**選項 B：安裝 MySQL Server**
1. 訪問：https://dev.mysql.com/downloads/mysql/
2. 下載 MySQL Community Server
3. 安裝過程中設定 root 密碼（請記住！）

### 3️⃣ 建立資料庫

開啟 PowerShell 或命令提示字元：

```powershell
# 進入專案目錄
cd "C:\Users\user\Desktop\大三作業\database"

# 登入 MySQL（如果使用 XAMPP，密碼為空，直接按 Enter）
mysql -u root -p

# 執行資料庫腳本（在 MySQL 提示字元中）
source C:/Users/user/Desktop/大三作業/database/create_database.sql
exit

# 或者直接在 PowerShell 執行
mysql -u root -p < "create_database.sql"
```

### 4️⃣ 設定資料庫連線

編輯 `.env` 檔案，填入您的 MySQL 密碼：

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=您的密碼（XAMPP 預設為空）
DB_NAME=scholarship_system
DB_PORT=3306

PORT=3000
```

### 5️⃣ 安裝專案套件

```powershell
npm install
```

### 6️⃣ 啟動伺服器

```powershell
npm start
```

看到以下訊息表示成功：
```
✅ 資料庫連接成功！
🚀 伺服器運行在 http://localhost:3000
```

### 7️⃣ 開啟瀏覽器測試

訪問：http://localhost:3000/student_profile.html

---

## 方法二：使用自動安裝腳本

```powershell
# 執行安裝腳本
.\setup.ps1

# 如果無法執行，先執行此命令允許腳本運行：
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force
.\setup.ps1
```

---

## ⚠️ 常見問題

### 問題 1: "無法辨識 npm"

**解決**：Node.js 安裝後需要重新開啟 PowerShell

### 問題 2: "無法辨識 mysql"

**解決**：
- 如果使用 XAMPP，請啟動 MySQL 服務
- 需要將 MySQL 加入環境變數 PATH

對於 XAMPP：
```powershell
$env:Path += ";C:\xampp\mysql\bin"
```

### 問題 3: 資料庫連接失敗

**檢查**：
1. MySQL 服務是否啟動（XAMPP Control Panel）
2. `.env` 中的密碼是否正確
3. 如果使用 XAMPP，密碼應該為空

### 問題 4: npm install 很慢

**解決**：使用淘寶鏡像
```powershell
npm install --registry=https://registry.npmmirror.com
```

---

## 🎯 驗證安裝

### 檢查清單：

```powershell
# ✅ Node.js 已安裝
node --version  # 應顯示 v20.x.x 或更高

# ✅ npm 已安裝
npm --version   # 應顯示 10.x.x 或更高

# ✅ MySQL 可連接
mysql -u root -p  # 應能登入

# ✅ 資料庫已建立
mysql -u root -p -e "USE scholarship_system; SHOW TABLES;"
# 應顯示多個表格

# ✅ Node 套件已安裝
Test-Path "node_modules"  # 應顯示 True

# ✅ 伺服器可啟動
npm start
# 應顯示 "資料庫連接成功" 和 "伺服器運行在..."
```

---

## 📱 完整測試流程

1. 啟動伺服器：`npm start`
2. 開啟瀏覽器
3. 訪問：http://localhost:3000/student_profile.html
4. 應該看到學生資料（王小明）
5. 修改資料並儲存
6. 重新整理頁面，確認資料已更新
7. 在 MySQL 中查詢驗證：
   ```sql
   USE scholarship_system;
   SELECT * FROM User WHERE id = 'S001';
   ```

---

## 🆘 需要協助？

如果遇到問題：

1. 確認所有軟體都已安裝
2. 確認 MySQL 服務已啟動
3. 檢查 `.env` 設定
4. 查看終端機的錯誤訊息
5. 開啟瀏覽器 F12 查看 Console

---

祝安裝順利！🎉
