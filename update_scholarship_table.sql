-- 更新 Scholarship 表，添加發放狀態欄位

-- 檢查並添加 is_published 欄位（是否已發放）
ALTER TABLE Scholarship 
ADD COLUMN IF NOT EXISTS is_published BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS published_by VARCHAR(50) NULL COMMENT '發放機構ID',
ADD COLUMN IF NOT EXISTS published_at TIMESTAMP NULL COMMENT '發放時間';

-- 將現有的獎學金都設為已發放狀態（向後兼容）
UPDATE Scholarship 
SET is_published = TRUE 
WHERE is_published IS NULL OR is_published = FALSE;

-- 查看更新後的表結構
DESCRIBE Scholarship;
