# ScholarLink 完整版安裝腳本
# 此腳本將協助您安裝所有必要的軟體和設定

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   ScholarLink 獎助學金系統 - 自動安裝" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 步驟 1: 檢查並安裝 Node.js
Write-Host "[1/5] 檢查 Node.js..." -ForegroundColor Yellow
$nodeInstalled = Get-Command node -ErrorAction SilentlyContinue

if ($null -eq $nodeInstalled) {
    Write-Host "❌ Node.js 未安裝" -ForegroundColor Red
    Write-Host "正在安裝 Node.js LTS..." -ForegroundColor Yellow
    
    # 使用 winget 安裝
    Write-Host "執行: winget install OpenJS.NodeJS.LTS" -ForegroundColor Gray
    Write-Host ""
    Write-Host "⚠️  請手動執行以下命令安裝 Node.js:" -ForegroundColor Yellow
    Write-Host "   winget install OpenJS.NodeJS.LTS" -ForegroundColor White
    Write-Host ""
    Write-Host "安裝完成後，請關閉此視窗並重新開啟 PowerShell，然後再次執行此腳本。" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit
} else {
    $nodeVersion = node --version
    Write-Host "✅ Node.js 已安裝: $nodeVersion" -ForegroundColor Green
}

# 步驟 2: 檢查並安裝 MySQL
Write-Host ""
Write-Host "[2/5] 檢查 MySQL..." -ForegroundColor Yellow
$mysqlInstalled = Get-Command mysql -ErrorAction SilentlyContinue

if ($null -eq $mysqlInstalled) {
    Write-Host "❌ MySQL 未安裝" -ForegroundColor Red
    Write-Host ""
    Write-Host "請選擇安裝方式:" -ForegroundColor Yellow
    Write-Host "  1. 使用 XAMPP（推薦，包含 MySQL + phpMyAdmin）" -ForegroundColor White
    Write-Host "  2. 安裝獨立的 MySQL Server" -ForegroundColor White
    Write-Host ""
    $choice = Read-Host "請輸入選項 (1 或 2)"
    
    if ($choice -eq "1") {
        Write-Host ""
        Write-Host "請手動執行以下步驟:" -ForegroundColor Yellow
        Write-Host "1. 訪問 https://www.apachefriends.org/" -ForegroundColor White
        Write-Host "2. 下載並安裝 XAMPP" -ForegroundColor White
        Write-Host "3. 啟動 XAMPP Control Panel" -ForegroundColor White
        Write-Host "4. 啟動 MySQL 服務" -ForegroundColor White
        Write-Host "5. 重新執行此腳本" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "請手動執行以下步驟:" -ForegroundColor Yellow
        Write-Host "1. 訪問 https://dev.mysql.com/downloads/mysql/" -ForegroundColor White
        Write-Host "2. 下載並安裝 MySQL Community Server" -ForegroundColor White
        Write-Host "3. 記住您設定的 root 密碼" -ForegroundColor White
        Write-Host "4. 重新執行此腳本" -ForegroundColor White
    }
    Write-Host ""
    pause
    exit
} else {
    Write-Host "✅ MySQL 已安裝" -ForegroundColor Green
}

# 步驟 3: 安裝 Node.js 套件
Write-Host ""
Write-Host "[3/5] 安裝 Node.js 套件..." -ForegroundColor Yellow
Write-Host "執行: npm install" -ForegroundColor Gray

if (Test-Path "package.json") {
    npm install
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Node.js 套件安裝完成" -ForegroundColor Green
    } else {
        Write-Host "❌ 套件安裝失敗" -ForegroundColor Red
        pause
        exit
    }
} else {
    Write-Host "❌ 找不到 package.json 檔案" -ForegroundColor Red
    pause
    exit
}

# 步驟 4: 設定資料庫連線
Write-Host ""
Write-Host "[4/5] 設定資料庫連線..." -ForegroundColor Yellow

if (Test-Path ".env") {
    Write-Host "⚠️  .env 檔案已存在" -ForegroundColor Yellow
    $overwrite = Read-Host "是否要重新設定? (y/n)"
    
    if ($overwrite -ne "y") {
        Write-Host "跳過資料庫設定" -ForegroundColor Gray
    } else {
        Write-Host ""
        $dbPassword = Read-Host "請輸入 MySQL root 密碼" -AsSecureString
        $dbPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($dbPassword))
        
        $envContent = @"
# 資料庫設定
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=$dbPasswordPlain
DB_NAME=scholarship_system
DB_PORT=3306

# 伺服器設定
PORT=3000
"@
        $envContent | Out-File -FilePath ".env" -Encoding UTF8
        Write-Host "✅ .env 檔案已更新" -ForegroundColor Green
    }
} else {
    Write-Host "❌ 找不到 .env 檔案" -ForegroundColor Red
}

# 步驟 5: 建立資料庫
Write-Host ""
Write-Host "[5/5] 建立資料庫..." -ForegroundColor Yellow
Write-Host ""
Write-Host "請選擇:" -ForegroundColor Yellow
Write-Host "  1. 自動建立資料庫（需要輸入 MySQL 密碼）" -ForegroundColor White
Write-Host "  2. 手動建立（稍後自己執行 SQL 腳本）" -ForegroundColor White
Write-Host ""
$dbChoice = Read-Host "請輸入選項 (1 或 2)"

if ($dbChoice -eq "1") {
    Write-Host ""
    Write-Host "執行: mysql -u root -p < create_database.sql" -ForegroundColor Gray
    Write-Host "（請在提示時輸入 MySQL 密碼）" -ForegroundColor Gray
    Write-Host ""
    
    mysql -u root -p < "create_database.sql"
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ 資料庫建立完成" -ForegroundColor Green
    } else {
        Write-Host "❌ 資料庫建立失敗" -ForegroundColor Red
        Write-Host "請手動執行: mysql -u root -p < create_database.sql" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "請稍後手動執行以下命令:" -ForegroundColor Yellow
    Write-Host "  mysql -u root -p < create_database.sql" -ForegroundColor White
}

# 完成
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   安裝完成！" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "  1. 確認 .env 檔案中的資料庫密碼正確" -ForegroundColor White
Write-Host "  2. 執行 'npm start' 啟動伺服器" -ForegroundColor White
Write-Host "  3. 開啟瀏覽器訪問 http://localhost:3000/student_profile.html" -ForegroundColor White
Write-Host ""
Write-Host "立即啟動伺服器嗎? (y/n)" -ForegroundColor Yellow
$startServer = Read-Host

if ($startServer -eq "y") {
    Write-Host ""
    Write-Host "正在啟動伺服器..." -ForegroundColor Yellow
    Write-Host "按 Ctrl+C 可停止伺服器" -ForegroundColor Gray
    Write-Host ""
    npm start
} else {
    Write-Host ""
    Write-Host "您可以稍後執行 'npm start' 來啟動伺服器" -ForegroundColor Gray
}

Write-Host ""
pause
