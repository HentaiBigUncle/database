-- 創建身分證明檔案表
CREATE TABLE IF NOT EXISTS Identity_Proof (
    id VARCHAR(50) PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL,
    file_path VARCHAR(255) NOT NULL COMMENT '上傳檔案的路徑',
    file_name VARCHAR(255) NOT NULL COMMENT '原始檔案名稱',
    file_size INT COMMENT '檔案大小（位元組）',
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Student(id) ON DELETE CASCADE
);

-- 創建索引便於查詢
CREATE INDEX idx_identity_proof_student ON Identity_Proof(student_id);

-- 驗證表已創建
DESCRIBE Identity_Proof;
