-- 添加身份限制欄位到獎學金表
-- 可選值：NULL (一般獎學金), '原住民', '清寒', '僑生', '身心障礙'

ALTER TABLE Scholarship 
ADD COLUMN identity_restriction VARCHAR(20) NULL 
COMMENT '身份限制：NULL表示一般獎學金，特定值表示僅該身份可見';

-- 查看更新後的表結構
DESCRIBE Scholarship;
