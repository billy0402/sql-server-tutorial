CREATE DATABASE [10646003_mid];
GO
USE [10646003_mid];
GO

/* 第一題(1) */
CREATE TYPE type_score
    FROM INT NOT NULL;
GO

CREATE RULE rule_score
    AS @score >= 0 AND @score <= 100;
GO

CREATE DEFAULT default_score
    AS 0;
GO

EXEC sp_bindrule 'rule_score', 'type_score';
EXEC sp_bindefault 'default_score', 'type_score';
GO

/* 第一題(2) */
CREATE FUNCTION GetAverageScore(@studnet_id CHAR(5))
    RETURNS FLOAT

BEGIN

    DECLARE
        @average_score FLOAT;

    SELECT @average_score = CAST(ROUND(CAST(SUM(學分數 * 成績) AS FLOAT) / CAST(SUM(學分數) AS FLOAT), 1) AS DECIMAL(10, 1))
    FROM dbo.成績
    WHERE 學號 = @studnet_id

    RETURN @average_score

END
GO

CREATE TABLE 成績
(
    學號   CHAR(5)      NOT NULL,
    學生姓名 NVARCHAR(10) NOT NULL,
    科目   NVARCHAR(10) NOT NULL,
    學分數  INT          NOT NULL,
    成績   type_score   NOT NULL,
    平均成績 AS dbo.GetAverageScore(學號),
);

INSERT INTO 成績(學號, 學生姓名, 科目, 學分數, 成績)
VALUES ('B0023', '李立行', '微積分', 4, 85),
       ('N0008', '陳美', '微積分', 4, 50),
       ('B0023', '李立行', '統計', 2, 66),
       ('N0008', '陳美', '計算機概論', 3, 91),
       ('N0008', '陳美', '統計', 4, 76),
       ('B0045', '錢奇', '統計', 2, 69),
       ('B0045', '錢奇', '微積分', 4, 72);

SELECT *
FROM dbo.成績;
GO

/* 第一題(3) */
CREATE TABLE 成績三
(
    學號   CHAR(5)      NOT NULL,
    學生姓名 NVARCHAR(10) NOT NULL,
    科目   NVARCHAR(10) NOT NULL,
    學分數  INT          NOT NULL,
    成績   type_score   NOT NULL,
    平均成績 DECIMAL(4, 1),
);

INSERT INTO 成績三(學號, 學生姓名, 科目, 學分數, 成績, 平均成績)
VALUES ('B0023', '李立行', '微積分', 4, 85, 78.6),
       ('N0008', '陳美', '微積分', 4, 50, 70.6),
       ('B0023', '李立行', '統計', 2, 66, 78.6),
       ('N0008', '陳美', '計算機概論', 3, 91, 70.6),
       ('N0008', '陳美', '統計', 4, 76, 70.6),
       ('B0045', '錢奇', '統計', 2, 69, 71),
       ('B0045', '錢奇', '微積分', 4, 72, 71);

SELECT *
FROM dbo.成績三;
GO

CREATE PROC score_average @id CHAR(5),
                          @name NVARCHAR(10),
                          @subject NVARCHAR(10),
                          @unit INT,
                          @score type_score
AS

SELECT *
FROM dbo.成績三
WHERE 學號 = @id
  AND 科目 = @subject
  AND 成績 < 60
    IF @@ROWCOUNT > 0
        BEGIN
            UPDATE dbo.成績三
            SET 學分數=0
            WHERE 學號 = @id
              AND 科目 = @subject
              AND 成績 < 60

            INSERT dbo.成績三
            VALUES (@id, @name, @subject, @unit, @score, NULL)

            IF @@ROWCOUNT > 0
                BEGIN
                    DECLARE
                        @check_id CHAR(5), @new_average_score DECIMAL(4, 1)
                    SELECT @check_id = 學號, @new_average_score = CAST(SUM(學分數 * 成績) AS FLOAT) / SUM(學分數)
                    FROM dbo.成績三
                    WHERE 學號 = @id
                    GROUP BY 學號

                    UPDATE dbo.成績三
                    SET 平均成績=@new_average_score
                    WHERE 學號 = @id
                END
        END
GO

EXEC score_average 'N0008', '陳美', '微積分', 4, 70;

SELECT *
FROM dbo.成績三;

/* 第二題(1) */
CREATE TABLE 客戶
(
    客戶編號 INT PRIMARY KEY,
    客戶名稱 NVARCHAR(10) NOT NULL,
    地區   NVARCHAR(10) NOT NULL
);

CREATE TABLE 商品
(
    商品編號 CHAR(2),
    商品名稱 NVARCHAR(10) NOT NULL,
    單價   INT          NOT NULL,
    數量   INT          NOT NULL,
    客戶編號 INT,
    FOREIGN KEY (客戶編號) REFERENCES 客戶 (客戶編號)
);

INSERT INTO 客戶(客戶編號, 客戶名稱, 地區)
VALUES (950, '大發', '苗栗縣'),
       (940, '成功', '台北市'),
       (941, '大立', '新北市'),
       (931, '大統', '台北市');

INSERT INTO 商品(商品編號, 商品名稱, 單價, 數量, 客戶編號)
VALUES ('C6', '長褲', 890, 12, 940),
       ('B0', '皮帶', 400, 10, 940),
       ('F4', '手錶', 2300, 21, 931),
       ('F4', '手錶', 3500, 8, 950),
       ('A0', '外套', 1250, 10, 950),
       ('A2', '毛衣', 1200, 8, 940),
       ('C0', '運動褲', 560, 10, 931);

SELECT *
FROM dbo.客戶;

SELECT *
FROM dbo.商品;
GO

/* 第二題(2) */
SELECT 客戶編號, SUM(單價 * 數量) AS 總交易金額
FROM 商品
GROUP BY 客戶編號
ORDER BY 客戶編號 DESC;
GO