# ScholarLink 獎助學金系統 - 資料庫整合完成 ✅

## 🎉 系統已完成設置！

您的 HTML 頁面現在已經與 MySQL 資料庫完全整合。所有操作都會即時與資料庫同步。

## 📁 檔案位置

所有檔案都在 `C:\xampp\htdocs\scholarship\` 目錄下：

```
C:\xampp\htdocs\scholarship\
├── index.html                      # 登入頁面（連接資料庫）
├── student_dashboard.html          # 學生儀表板（顯示獎學金和申請記錄）
├── student_profile_apache.html     # 學生個人資料編輯
├── scholarship_portal.html         # 獎學金申請入口
├── teacher.html                    # 教師端頁面
├── admin.html                      # 管理員頁面
├── organization.html               # 機構頁面
├── api/
│   └── index.php                   # REST API（處理所有資料庫操作）
├── config.php                      # 資料庫連接配置
├── install.html                    # 資料庫安裝頁面
└── install_db.php                  # 資料庫安裝程式

```

## 🚀 如何使用

### 1. 訪問系統

打開瀏覽器，訪問：
```
http://localhost/scholarship/index.html
```

### 2. 使用測試帳號登入

系統提供以下測試帳號：

| 角色 | ID | 姓名 | 說明 |
|------|-------|------|------|
| 學生 | `S001` | 王小明 | 一般生 |
| 學生 | `S002` | 李小華 | 僑生（有額外身分資料）|
| 教師 | `T001` | 張教授 | 教師帳號 |
| 管理員 | `A001` | 系統管理員 | 管理員帳號 |

### 3. 功能測試

#### 學生端功能：
1. **登入**：使用 `S001` 或 `S002` 登入
2. **儀表板**：查看可申請的獎學金和申請記錄
3. **個人資料**：編輯並儲存個人資料（即時更新到資料庫）
4. **申請獎學金**：提交獎學金申請

#### 資料庫即時同步：
- ✅ 修改個人資料 → 立即寫入 `User`、`Student` 表
- ✅ 新增電話號碼 → 即時更新 `User_Phone` 表
- ✅ 僑生資料 → 自動同步 `Overseas_Student` 表
- ✅ 獎學金申請 → 記錄到 `Application` 表

## 📊 API 端點

系統提供以下 API 端點（自動處理資料庫操作）：

### 使用者相關
- `POST /api/login` - 登入驗證

### 學生相關
- `GET /api/student/{id}` - 獲取學生資料
- `PUT /api/student/{id}` - 更新學生資料

### 獎學金相關
- `GET /api/scholarships` - 獲取所有獎學金
- `GET /api/applications/{studentId}` - 獲取學生的申請記錄
- `POST /api/applications` - 提交獎學金申請

### 公告相關
- `GET /api/announcements` - 獲取系統公告

## 🔧 技術架構

```
前端 (HTML + JavaScript)
    ↓ Fetch API
PHP REST API (api/index.php)
    ↓ PDO
MySQL 資料庫 (scholarship_system)
    ↓
15+ 資料表（User, Student, Scholarship, Application 等）
```

## 🎯 核心功能

### 1. 登入系統
- 輸入使用者 ID（學號/教師編號/管理員 ID）
- 系統自動查詢資料庫驗證身分
- 根據使用者類型跳轉對應頁面

### 2. 學生儀表板
- **獎學金列表**：從 `Scholarship` 表讀取所有可申請獎學金
- **申請記錄**：從 `Application` 表讀取學生的申請歷史
- **即時資料**：所有資料都從資料庫即時查詢

### 3. 個人資料編輯
- 載入時：從資料庫讀取完整資料
- 儲存時：使用 Transaction 確保資料一致性
- 支援多值屬性（電話號碼）
- 動態顯示身分別欄位（僑生、原住民等）

### 4. 獎學金申請
- 選擇獎學金
- 輸入成績和 GPA
- 提交後自動記錄到資料庫

## 🗄️ 資料庫結構

### 主要資料表

1. **User（使用者）**
   - 所有使用者的共同資料
   - 包含：id, name, email, type

2. **Student（學生）**
   - 繼承 User
   - 包含：identity（身分別）, major（科系）

3. **Overseas_Student（僑生）**
   - 繼承 Student
   - 僑生專屬資料：僑生證號、中文檢定、入境日期、護照號碼

4. **Scholarship（獎學金）**
   - 獎學金基本資訊
   - 包含：name, amount, description

5. **Application（申請記錄）**
   - 學生的獎學金申請
   - 包含：student_id, scholarship_name, apply_state, score, gpa

6. **User_Phone（使用者電話）**
   - 多值屬性
   - 一個使用者可以有多個電話號碼

### 資料表關係
```
User (父表)
  ├── Student
  │     ├── Normal_Student (一般生)
  │     ├── Overseas_Student (僑生)
  │     ├── Aboriginal_Student (原住民)
  │     ├── Low_Income_Student (低收入戶)
  │     └── Disabled_Student (身心障礙)
  ├── Teacher
  ├── Organization
  └── System_Administrator

Scholarship ←→ Application ←→ Student
```

## 🔒 資料安全

- ✅ 使用 PDO Prepared Statements 防止 SQL Injection
- ✅ Transaction 確保資料一致性
- ✅ 錯誤處理和資料驗證
- ✅ CORS 設定允許跨域請求

## 📝 測試流程

### 測試 1：登入功能
1. 訪問 `http://localhost/scholarship/index.html`
2. 輸入 `S001`
3. 點擊登入
4. 應該跳轉到學生儀表板並顯示「歡迎回來，王小明」

### 測試 2：個人資料編輯
1. 從儀表板點擊「個人資料」
2. 修改電話號碼或其他資料
3. 點擊儲存
4. 重新載入頁面，資料應該已保存

### 測試 3：查看獎學金
1. 在儀表板查看「可申請獎學金」區域
2. 應該顯示資料庫中的獎學金列表（優秀學生獎學金、清寒獎學金等）

### 測試 4：申請記錄
1. 在儀表板查看「我的申請記錄」
2. 應該顯示該學生的所有申請（如果有的話）

## 🎨 頁面說明

### index.html - 登入頁面
- 輸入使用者 ID
- 呼叫 `POST /api/login` 驗證身分
- 根據使用者類型導向不同頁面

### student_dashboard.html - 學生儀表板
- 顯示歡迎訊息和個人資訊
- 獎學金列表（從資料庫讀取）
- 申請記錄表格（從資料庫讀取）
- 快速申請功能

### student_profile_apache.html - 個人資料
- 載入完整的學生資料
- 支援身分別動態欄位
- 即時儲存到資料庫

## 💡 常見問題

### Q: 修改資料後沒有保存？
A: 確認 XAMPP 的 Apache 和 MySQL 服務都在運行（綠色狀態）

### Q: 顯示「無法連接到伺服器」？
A: 
1. 檢查 XAMPP Control Panel，Apache 和 MySQL 是否啟動
2. 確認訪問的 URL 是 `http://localhost` 開頭
3. 查看瀏覽器控制台（F12）的錯誤訊息

### Q: 資料庫連接失敗？
A: 檢查 `C:\xampp\htdocs\scholarship\config.php` 中的密碼設定

### Q: 想要重新安裝資料庫？
A: 訪問 `http://localhost/scholarship/install.html` 重新執行安裝

## 🔍 開發者資訊

### 查看 API 回應
在瀏覽器中直接訪問：
```
http://localhost/scholarship/api/scholarships
http://localhost/scholarship/api/student/S001
```

### 資料庫管理
訪問 phpMyAdmin：
```
http://localhost/phpmyadmin
```
- 資料庫名稱：`scholarship_system`
- 查看表格、修改資料、執行 SQL 查詢

### 修改 API
編輯 `C:\xampp\htdocs\scholarship\api\index.php` 新增或修改 API 端點

## 🎓 總結

您的系統現在已經完全整合：

✅ **前端**：美觀的 HTML 介面
✅ **後端**：PHP REST API
✅ **資料庫**：MySQL 完整資料結構
✅ **功能**：登入、資料查詢、資料修改、申請提交
✅ **即時**：所有操作即時同步到資料庫

開始體驗吧！訪問 `http://localhost/scholarship/index.html` 🚀

---

**需要幫助？** 
- 檢查 XAMPP Control Panel 的服務狀態
- 查看瀏覽器控制台（F12）的錯誤訊息
- 確認 URL 使用 `http://localhost` 而非檔案路徑
