# 資料庫建立腳本
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   ScholarLink - 建立資料庫" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 加入 MySQL 到 PATH
$env:Path += ";C:\xampp\mysql\bin"

Write-Host "請輸入 MySQL root 密碼（XAMPP 預設為空，直接按 Enter）:" -ForegroundColor Yellow
$password = Read-Host -AsSecureString
$passwordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

Write-Host ""
Write-Host "正在建立資料庫..." -ForegroundColor Yellow

if ($passwordPlain -eq "") {
    # 空密碼
    Get-Content "create_database.sql" | mysql -u root --force 2>&1
} else {
    # 有密碼
    Get-Content "create_database.sql" | mysql -u root -p"$passwordPlain" --force 2>&1
}

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ 資料庫建立成功！" -ForegroundColor Green
    Write-Host ""
    
    # 更新 .env 檔案
    Write-Host "正在更新 .env 檔案..." -ForegroundColor Yellow
    $envContent = @"
# 資料庫設定
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=$passwordPlain
DB_NAME=scholarship_system
DB_PORT=3306

# 伺服器設定
PORT=3000
"@
    $envContent | Out-File -FilePath ".env" -Encoding UTF8 -NoNewline
    Write-Host "✅ .env 檔案已更新" -ForegroundColor Green
    
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host "   設定完成！" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "下一步：執行以下命令啟動伺服器" -ForegroundColor Yellow
    Write-Host "  npm start" -ForegroundColor White
    Write-Host ""
    
    $start = Read-Host "現在要啟動伺服器嗎? (y/n)"
    if ($start -eq "y") {
        Write-Host ""
        Write-Host "正在啟動伺服器..." -ForegroundColor Yellow
        Write-Host "按 Ctrl+C 可停止" -ForegroundColor Gray
        Write-Host ""
        npm start
    }
} else {
    Write-Host ""
    Write-Host "❌ 資料庫建立失敗" -ForegroundColor Red
    Write-Host ""
    Write-Host "請檢查：" -ForegroundColor Yellow
    Write-Host "1. MySQL 服務是否已啟動（開啟 XAMPP Control Panel 並啟動 MySQL）" -ForegroundColor White
    Write-Host "2. 密碼是否正確" -ForegroundColor White
    Write-Host "3. create_database.sql 檔案是否存在" -ForegroundColor White
}

Write-Host ""
pause
