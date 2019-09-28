CREATE TABLE 辦公室
(
    辦公室編號 CHAR(3)      NOT NULL,
    地點    NVARCHAR(20) NOT NULL,

    CONSTRAINT pk_辦公室 PRIMARY KEY (辦公室編號)
);

CREATE TABLE 教師
(
    教師編號  CHAR(3)      NOT NULL,
    姓名    NVARCHAR(10) NOT NULL,
    辦公室編號 CHAR(3)      NOT NULL,
    職等    CHAR(1)      NOT NULL,

    CONSTRAINT pk_教師 PRIMARY KEY (教師編號),
    CONSTRAINT fk_教師_辦公室_辦公室編號 FOREIGN KEY (辦公室編號) REFERENCES 辦公室 (辦公室編號)
);

CREATE TABLE 課程
(
    課程編號 CHAR(3)     NOT NULL,
    名稱   NVARCHAR(6) NOT NULL,
    教室   CHAR(5)     NOT NULL,
    教師編號 CHAR(3)     NOT NULL,
    時間   TIME        NOT NULL,

    CONSTRAINT pk_課程 PRIMARY KEY (課程編號),
    CONSTRAINT fk_課程_教師編號 FOREIGN KEY (教師編號) REFERENCES 教師 (教師編號)
);

INSERT INTO 辦公室(辦公室編號, 地點)
VALUES ('F12', '承曦707'),
       ('D02', '承曦708');

INSERT INTO 教師(教師編號, 姓名, 辦公室編號, 職等)
VALUES ('P01', '王教授', 'F12', 'A'),
       ('P02', '張教授', 'D02', 'B');

INSERT INTO 課程(課程編號, 名稱, 教室, 教師編號, 時間)
VALUES ('S01', '資料庫', '316-S', 'P01', '09:00'),
       ('S02', '網路', '316-S', 'P02', '13:00'),
       ('S03', '多媒體', '322-D', 'P01', '13:00');

SELECT 教師編號, 時間
FROM 課程
WHERE 教師編號 = 'P01'
  AND 教室 = '322-D';

UPDATE 課程
SET 時間 = '09:00'
WHERE 教師編號 = 'P01'
  AND 教室 = '322-D';

SELECT 教師.教師編號, 教師.姓名, 教師.辦公室編號, 教師.職等
FROM 課程
         INNER JOIN 教師
                    ON 課程.教師編號 = 教師.教師編號
WHERE 課程.教室 = '316-S';

---------------------------------------------------------------------

CREATE TABLE S
(
    學號   CHAR(2)     NOT NULL,
    學生姓名 VARCHAR(20) NOT NULL,
    就讀學系 NCHAR(4)    NOT NULL,
    年級   NCHAR(2)    NOT NULL,

    CONSTRAINT pk_S PRIMARY KEY (學號)
);

INSERT INTO S(學號, 學生姓名, 就讀學系, 年級)
VALUES ('S1', 'Mary', '電機', '一'),
       ('S2', 'Betty', '數學', '二'),
       ('S3', 'John', '物理', '二'),
       ('S4', 'Peter', '電機', '一'),
       ('S5', 'Jack', '化學', '三');

CREATE TABLE C
(
    課程代號   CHAR(2)      NOT NULL,
    課程名稱   NVARCHAR(10) NOT NULL,
    學分數    INT          NOT NULL,
    任課老師代號 CHAR(2)      NOT NULL,

    CONSTRAINT pk_C PRIMARY KEY (課程代號)
);

INSERT INTO C(課程代號, 課程名稱, 學分數, 任課老師代號)
VALUES ('C1', '微積分', 3, 'T1'),
       ('C2', '英文', 2, 'T5'),
       ('C3', '微積分', 3, 'T9'),
       ('C4', '電腦概論', 2, 'T3'),
       ('C5', '應用文', 2, 'T6'),
       ('C6', '電腦概論', 2, 'T7');

CREATE TABLE T
(
    學號   CHAR(2) NOT NULL,
    課程代號 CHAR(2) NOT NULL,
    成績   INT     NOT NULL,

    CONSTRAINT pk_T PRIMARY KEY (學號, 課程代號),
    CONSTRAINT fk_T_S_學號 FOREIGN KEY (學號) REFERENCES S (學號),
    CONSTRAINT fk_T_C_課程代號 FOREIGN KEY (課程代號) REFERENCES C (課程代號)
);

INSERT INTO T(學號, 課程代號, 成績)
VALUES ('S1', 'C1', 80),
       ('S1', 'C2', 85),
       ('S1', 'C4', 90),
       ('S1', 'C5', 85),
       ('S2', 'C1', 50),
       ('S2', 'C4', 80),
       ('S2', 'C5', 92),
       ('S3', 'C1', 80),
       ('S3', 'C4', 86),
       ('S4', 'C6', 58);

SELECT 課程名稱
FROM C
GROUP BY 課程名稱
HAVING count(任課老師代號) > 1;

SELECT S.學號, S.學生姓名, C.課程名稱
FROM T
         INNER JOIN S
                    ON S.學號 = T.學號
         INNER JOIN C
                    ON C.課程代號 = T.課程代號
WHERE T.成績 < 60;