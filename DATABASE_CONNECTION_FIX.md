# 🔴 資料庫連接失敗解決方案

## 問題：無法連線，因為目標電腦拒絕連線

這個錯誤表示 **MySQL 服務沒有運行**。

## ✅ 解決步驟

### 方法 1：使用 XAMPP Control Panel（推薦）

1. **打開 XAMPP Control Panel**
   - 檔案位置：`C:\xampp\xampp-control.exe`
   - 或從開始功能表搜尋 "XAMPP"

2. **啟動 MySQL**
   - 找到 MySQL 那一行
   - 點擊 **Start** 按鈕
   - 等待狀態變成綠色

3. **同時確認 Apache 也在運行**
   - Apache 也應該是綠色（正在運行）
   - 如果沒有，也點擊 Start 按鈕

4. **驗證服務狀態**
   - MySQL 顯示 **綠色** = 正常
   - Apache 顯示 **綠色** = 正常

### 方法 2：使用命令行（快速）

在 PowerShell 中執行：

```powershell
# 啟動 MySQL
C:\xampp\mysql_start.bat

# 啟動 Apache（如果也停止了）
C:\xampp\apache_start.bat
```

### 方法 3：一鍵啟動腳本

執行以下 PowerShell 命令：

```powershell
cd C:\xampp
.\xampp_start.exe
```

## 🔍 驗證 MySQL 是否啟動

### 方法 1：PowerShell 測試
```powershell
Test-NetConnection -ComputerName localhost -Port 3306
```
如果看到 `TcpTestSucceeded : True` 表示 MySQL 已啟動。

### 方法 2：瀏覽器測試
訪問：
```
http://localhost/phpmyadmin
```
如果可以打開 phpMyAdmin，表示 MySQL 正常運行。

### 方法 3：API 測試
訪問：
```
http://localhost/scholarship/api/index.php/scholarships
```
如果看到 JSON 資料（獎學金列表），表示資料庫連接成功。

## 🚨 常見問題

### Q1: 點擊 Start 後 MySQL 又自動停止？

**可能原因：**
1. 端口 3306 被其他程式佔用
2. MySQL 配置檔案錯誤

**解決方法：**
```powershell
# 檢查哪個程式佔用了 3306 端口
netstat -ano | findstr :3306

# 如果有結果，記下最後的數字（PID），然後：
tasklist | findstr <PID>
```

### Q2: XAMPP Control Panel 找不到？

**位置：**
```
C:\xampp\xampp-control.exe
```

可以在這個位置建立桌面快捷方式。

### Q3: 系統重啟後 MySQL 又停止了？

這是正常的，XAMPP 預設不會自動啟動。

**解決方法：**
在 XAMPP Control Panel 中，點擊 MySQL 旁的 **Config** → 勾選 **Install as Service**

## ✨ 啟動後要做什麼

1. **重新整理登入頁面**
   ```
   http://localhost/scholarship/login.html
   ```

2. **使用測試帳號登入**
   - 學生：S001（王小明）
   - 教師：T001（張教授）

3. **確認資料可以正常載入**
   - 學生儀表板應該顯示獎學金列表
   - 個人資料頁面應該顯示學生資料

## 📋 快速檢查清單

- [ ] XAMPP Control Panel 中 MySQL 是綠色
- [ ] XAMPP Control Panel 中 Apache 是綠色
- [ ] `http://localhost/phpmyadmin` 可以打開
- [ ] `http://localhost/scholarship/login.html` 可以登入
- [ ] 登入後可以看到資料

## 💡 預防措施

1. **每次使用前確認服務狀態**
   - 打開 XAMPP Control Panel 檢查

2. **關機前正確停止服務**
   - 在 XAMPP Control Panel 點擊 Stop
   - 不要直接關機

3. **設定開機自動啟動（可選）**
   - Config → Install MySQL as Service
   - Config → Install Apache as Service

---

**快速解決：** 打開 XAMPP Control Panel → 點擊 MySQL 的 Start 按鈕 → 等待變綠色 → 重新整理網頁 ✅
