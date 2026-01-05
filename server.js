const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// 中介層設定
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('.')); // 提供靜態HTML檔案

// MySQL 連接池
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'scholarship_system',
  port: process.env.DB_PORT || 3306,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

const promisePool = pool.promise();

// 測試資料庫連接
pool.getConnection((err, connection) => {
  if (err) {
    console.error('❌ 資料庫連接失敗:', err.message);
    return;
  }
  console.log('✅ 資料庫連接成功！');
  connection.release();
});

// ============================================
// 學生 API 路由
// ============================================

// 取得學生基本資料
app.get('/api/student/:id', async (req, res) => {
  try {
    const studentId = req.params.id;
    
    const [rows] = await promisePool.query(`
      SELECT 
        u.id,
        u.name,
        u.email,
        s.identity,
        s.major,
        GROUP_CONCAT(up.phone SEPARATOR ',') as phones
      FROM User u
      JOIN Student s ON u.id = s.id
      LEFT JOIN User_Phone up ON u.id = up.user_id
      WHERE u.id = ?
      GROUP BY u.id, u.name, u.email, s.identity, s.major
    `, [studentId]);

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: '找不到學生資料' });
    }

    const student = rows[0];
    
    // 根據身分別查詢額外資料
    let additionalInfo = {};
    if (student.identity === '僑生') {
      const [overseasInfo] = await promisePool.query(
        'SELECT * FROM Overseas_Student WHERE id = ?',
        [studentId]
      );
      if (overseasInfo.length > 0) {
        additionalInfo = overseasInfo[0];
      }
    } else if (student.identity === '原住民') {
      const [aboriginalInfo] = await promisePool.query(
        'SELECT * FROM Aboriginal_Student WHERE id = ?',
        [studentId]
      );
      if (aboriginalInfo.length > 0) {
        additionalInfo = aboriginalInfo[0];
      }
    } else if (student.identity === '低收入戶') {
      const [lowIncomeInfo] = await promisePool.query(
        'SELECT * FROM Low_Income_Student WHERE id = ?',
        [studentId]
      );
      if (lowIncomeInfo.length > 0) {
        additionalInfo = lowIncomeInfo[0];
      }
    } else if (student.identity === '身心障礙') {
      const [disabledInfo] = await promisePool.query(
        'SELECT * FROM Disabled_Student WHERE id = ?',
        [studentId]
      );
      if (disabledInfo.length > 0) {
        additionalInfo = disabledInfo[0];
      }
    }

    res.json({
      success: true,
      data: {
        ...student,
        phones: student.phones ? student.phones.split(',') : [],
        additionalInfo
      }
    });
  } catch (error) {
    console.error('取得學生資料錯誤:', error);
    res.status(500).json({ success: false, message: '伺服器錯誤', error: error.message });
  }
});

// 更新學生基本資料
app.put('/api/student/:id', async (req, res) => {
  const connection = await promisePool.getConnection();
  
  try {
    await connection.beginTransaction();
    
    const studentId = req.params.id;
    const { name, email, identity, major, phones, additionalInfo } = req.body;

    // 更新 User 表
    await connection.query(
      'UPDATE User SET name = ?, email = ? WHERE id = ?',
      [name, email, studentId]
    );

    // 更新 Student 表
    await connection.query(
      'UPDATE Student SET identity = ?, major = ? WHERE id = ?',
      [identity, major, studentId]
    );

    // 更新電話號碼（先刪除舊的，再插入新的）
    await connection.query('DELETE FROM User_Phone WHERE user_id = ?', [studentId]);
    
    if (phones && phones.length > 0) {
      for (const phone of phones) {
        if (phone.trim()) {
          await connection.query(
            'INSERT INTO User_Phone (user_id, phone) VALUES (?, ?)',
            [studentId, phone.trim()]
          );
        }
      }
    }

    // 根據身分別更新對應表格
    if (identity === '僑生' && additionalInfo) {
      // 先檢查是否存在
      const [existing] = await connection.query(
        'SELECT id FROM Overseas_Student WHERE id = ?',
        [studentId]
      );
      
      if (existing.length > 0) {
        await connection.query(`
          UPDATE Overseas_Student 
          SET overseas_id = ?, chinese_certify = ?, immigrate_date = ?, passport_number = ?
          WHERE id = ?
        `, [
          additionalInfo.overseas_id,
          additionalInfo.chinese_certify,
          additionalInfo.immigrate_date,
          additionalInfo.passport_number,
          studentId
        ]);
      } else {
        await connection.query(`
          INSERT INTO Overseas_Student (id, overseas_id, chinese_certify, immigrate_date, passport_number)
          VALUES (?, ?, ?, ?, ?)
        `, [
          studentId,
          additionalInfo.overseas_id,
          additionalInfo.chinese_certify,
          additionalInfo.immigrate_date,
          additionalInfo.passport_number
        ]);
      }
    }

    await connection.commit();
    
    res.json({
      success: true,
      message: '學生資料更新成功'
    });
  } catch (error) {
    await connection.rollback();
    console.error('更新學生資料錯誤:', error);
    res.status(500).json({ success: false, message: '更新失敗', error: error.message });
  } finally {
    connection.release();
  }
});

// 取得學生申請紀錄
app.get('/api/student/:id/applications', async (req, res) => {
  try {
    const studentId = req.params.id;
    
    const [rows] = await promisePool.query(`
      SELECT 
        a.id,
        a.apply_date,
        a.scholarship_name,
        s.amount,
        a.apply_state,
        a.score,
        a.gpa,
        a.rank
      FROM Application a
      JOIN Scholarship s ON a.scholarship_name = s.name
      WHERE a.student_id = ?
      ORDER BY a.apply_date DESC
    `, [studentId]);

    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('取得申請紀錄錯誤:', error);
    res.status(500).json({ success: false, message: '伺服器錯誤', error: error.message });
  }
});

// 取得所有可申請的獎學金
app.get('/api/scholarships', async (req, res) => {
  try {
    const [rows] = await promisePool.query(`
      SELECT 
        s.name,
        s.amount,
        s.description,
        GROUP_CONCAT(u.name SEPARATOR ', ') as organizations
      FROM Scholarship s
      LEFT JOIN Scholarship_Organization so ON s.name = so.scholarship_name
      LEFT JOIN Organization o ON so.organization_id = o.id
      LEFT JOIN User u ON o.id = u.id
      GROUP BY s.name, s.amount, s.description
    `);

    res.json({
      success: true,
      data: rows
    });
  } catch (error) {
    console.error('取得獎學金列表錯誤:', error);
    res.status(500).json({ success: false, message: '伺服器錯誤', error: error.message });
  }
});

// 新增獎學金申請
app.post('/api/application', async (req, res) => {
  try {
    const { student_id, scholarship_name, apply_way, score, gpa, family_income } = req.body;

    const applicationId = 'APP' + Date.now();
    
    await promisePool.query(`
      INSERT INTO Application 
      (id, student_id, scholarship_name, apply_way, apply_state, score, gpa, family_income)
      VALUES (?, ?, ?, ?, 'Pending', ?, ?, ?)
    `, [applicationId, student_id, scholarship_name, apply_way, score, gpa, family_income]);

    res.json({
      success: true,
      message: '申請提交成功',
      applicationId
    });
  } catch (error) {
    console.error('提交申請錯誤:', error);
    res.status(500).json({ success: false, message: '申請失敗', error: error.message });
  }
});

// ============================================
// 啟動伺服器
// ============================================

app.listen(PORT, () => {
  console.log(`🚀 伺服器運行在 http://localhost:${PORT}`);
  console.log(`📄 學生個人資料頁面: http://localhost:${PORT}/student_profile.html`);
  console.log(`📄 學生首頁: http://localhost:${PORT}/student.html`);
});

// 優雅關閉
process.on('SIGINT', () => {
  console.log('\n⏳ 正在關閉伺服器...');
  pool.end((err) => {
    if (err) {
      console.error('關閉資料庫連接池時發生錯誤:', err);
    } else {
      console.log('✅ 資料庫連接池已關閉');
    }
    process.exit(0);
  });
});
