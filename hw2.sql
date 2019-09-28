CREATE TABLE 成績
(
    學號   CHAR(5)      NOT NULL,
    學生姓名 NVARCHAR(10) NOT NULL,
    科目   NVARCHAR(10) NOT NULL,
    學分數  INT          NOT NULL,
    成績   INT          NOT NULL,

    --CONSTRAINT pk_成績 PRIMARY KEY(學號, 科目)
);

INSERT INTO 成績(學號, 學生姓名, 科目, 學分數, 成績)
VALUES ('B0023', '李立行', '微積分', 4, 85),
       ('N0056', '梅麟', '微積分', 4, 78),
       ('N0008', '陳美', '微積分', 4, 50),
       ('B0023', '李立行', '統計', 2, 66),
       ('N0009', '陳大勤', '計算機概論', 3, 91),
       ('N0008', '陳美', '微積分', 4, 76),
       ('B0045', '錢奇', '統計', 2, 69),
       ('B0045', '錢奇', '微積分', 4, 70);

-- 1
SELECT 學號, 學生姓名, SUM(學分數 * 成績) / SUM(學分數) AS 平均成績
FROM dbo.成績
GROUP BY 學號, 學生姓名
HAVING (SUM(學分數 * 成績) / SUM(學分數) >= 75);

-- 2
SELECT 學號,
       學生姓名,
       CAST(ROUND(CAST(SUM(學分數 * 成績) AS FLOAT) / CAST(SUM(學分數) AS FLOAT), 2)
           AS DECIMAL(10, 2)) AS 平均成績
FROM dbo.成績
GROUP BY 學號, 學生姓名
HAVING (SUM(學分數 * 成績) / SUM(學分數) >= 75);

-- 3
SELECT 學號,
       學生姓名,
       CAST(ROUND(CAST(SUM(學分數 * 成績) AS FLOAT) / CAST(SUM(學分數) AS FLOAT), 2)
           AS DECIMAL(10, 2)) AS 平均成績
FROM dbo.成績
WHERE (成績 >= 60)
GROUP BY 學號, 學生姓名
HAVING (SUM(學分數 * 成績) / SUM(學分數) >= 75);