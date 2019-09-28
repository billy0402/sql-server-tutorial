USE master;
DROP DATABASE [10646003_hw7];
CREATE DATABASE [10646003_hw7];
USE [10646003_hw7];
GO

CREATE TABLE 學籍
(
    學號   INT PRIMARY KEY,
    姓名   NVARCHAR(10) NOT NULL,
    性別   CHAR(2)      NOT NULL CHECK (性別 = '男' OR 性別 = '女'),
    服役否  CHAR(1)      NOT NULL CHECK (服役否 = 'Y' OR 服役否 = 'N'),
    在學狀況 CHAR(4)      NOT NULL DEFAULT '在學'
);

CREATE TABLE 緩徵資料
(
    學號 INT PRIMARY KEY,
    姓名 NVARCHAR(10) NOT NULL,
    FOREIGN KEY (學號) REFERENCES 學籍 (學號)
);
GO
--CREATE RULE rule_性別 AS @gender='男' OR @gender='女';
--GO
--CREATE RULE rule_服役否 AS @service='Y' OR @service='N';
--GO
--CREATE DEFAULT default_在學狀況 AS '在學';
--GO
--EXEC sp_bindrule 'rule_性別', '學籍.性別';
--EXEC sp_bindrule 'rule_服役否', '學籍.服役否';
--EXEC sp_bindefault 'default_在學狀況', '學籍.在學狀況';
--GO

/* 第一題(1) */
CREATE TRIGGER trigger_insert
    ON 學籍
    AFTER INSERT
    AS
    --IF (SELECT 性別 FROM INSERTED) = '男' AND (SELECT 服役否 FROM INSERTED) = 'N' AND (SELECT 在學狀況 FROM INSERTED) = '在學'
--	BEGIN
--		INSERT INTO 緩徵資料
--		VALUES((SELECT 學號 FROM INSERTED), (SELECT 姓名 FROM INSERTED));
--	END
    INSERT INTO 緩徵資料
    SELECT 學號, 姓名
    FROM INSERTED
    WHERE INSERTED.性別 = '男'
      AND INSERTED.服役否 = 'N'
      AND INSERTED.在學狀況 = '在學'
      AND INSERTED.學號 NOT IN (SELECT 學號 FROM 緩徵資料);
GO

INSERT INTO 學籍
VALUES (1, '小明', '男', 'N', '在學');

INSERT INTO 學籍
VALUES (2, '小明', '男', 'Y', '在學');

SELECT *
FROM 學籍;
SELECT *
FROM 緩徵資料;
GO

/* 第一題(2) */
CREATE TRIGGER trigger_update
    ON 學籍
    AFTER UPDATE
    AS
    --IF NOT((SELECT 性別 FROM INSERTED) = '男' AND (SELECT 服役否 FROM INSERTED) = 'N'  AND (SELECT 在學狀況 FROM INSERTED) = '在學')
--	BEGIN
--		DELETE FROM 緩徵資料
--		WHERE 學號=(SELECT 學號 FROM INSERTED);
--	END
--ELSE
--	BEGIN
--		INSERT INTO 緩徵資料
--		VALUES((SELECT 學號 FROM INSERTED), (SELECT 姓名 FROM INSERTED));
--	END
    DELETE
    FROM 緩徵資料
SELECT 學號, 姓名
FROM INSERTED
WHERE NOT (INSERTED.性別 = '男' AND INSERTED.服役否 = 'N' AND INSERTED.在學狀況 = '在學')
  AND INSERTED.學號 IN (SELECT 學號 FROM 緩徵資料);

IF @@ROWCOUNT = 0
    INSERT INTO 緩徵資料
    SELECT 學號, 姓名
    FROM INSERTED
    WHERE INSERTED.性別 = '男'
      AND INSERTED.服役否 = 'N'
      AND INSERTED.在學狀況 = '在學'
      AND INSERTED.學號 NOT IN (SELECT 學號 FROM 緩徵資料);
GO

UPDATE 學籍
SET 服役否='Y'
WHERE 學號 = 1;

UPDATE 學籍
SET 服役否='N'
WHERE 學號 = 2;

SELECT *
FROM 學籍;
SELECT *
FROM 緩徵資料;
GO

/* 第二題 */
CREATE VIEW view_緩徵資料 AS
SELECT 學號, 姓名
FROM 學籍
WHERE 性別 = '男'
  AND 服役否 = 'N';
GO

INSERT INTO 學籍
VALUES (1, '小明', '男', 'N', '在學');

INSERT INTO 學籍
VALUES (2, '小明', '男', 'Y', '在學');

SELECT *
FROM view_緩徵資料;

UPDATE 學籍
SET 服役否='Y'
WHERE 學號 = 1;

UPDATE 學籍
SET 服役否='N'
WHERE 學號 = 2;

SELECT *
FROM view_緩徵資料;
GO