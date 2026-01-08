-- 將學生身分別的同義詞正規化，避免前後台比對不一致
-- 目前將「低收入戶」正規化為「清寒」

START TRANSACTION;

UPDATE Student
SET identity = '清寒'
WHERE identity = '低收入戶';

-- 驗證：統計各類別人數
SELECT identity, COUNT(*) AS cnt
FROM Student
GROUP BY identity
ORDER BY cnt DESC;

COMMIT;
