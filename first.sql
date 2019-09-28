CREATE DATABASE final10646003;

/* 第一題 */
CREATE TABLE 供應商
(
    供應商編號 VARCHAR(10) PRIMARY KEY,
    公司名稱  VARCHAR(50),
    電話    VARCHAR(20),
    地址    VARCHAR(255),
    郵遞區號  INT,
);

CREATE TABLE 物品
(
    序號   INT IDENTITY (5,5) PRIMARY KEY,
    物料名稱 VARCHAR(50),
    規格   VARCHAR(255),
    數量   INT,
    單價   INT,
    供應者  VARCHAR(10),
    FOREIGN KEY (供應者) REFERENCES 供應商 (供應商編號) ON UPDATE CASCADE,
);

INSERT INTO 供應商
VALUES ('AB_53', '大發', 1111, 'A', 220),
       ('B_112', '有利', 2222, 'B', 126),
       ('AAA359', '昌盛', 3333, 'C', 220),
       ('BB_5', '順發', 4444, 'D', 410);

INSERT INTO 物品
VALUES ('圓桌', '3尺 直徑66cm', 20, 1000, 'AB_53'),
       ('椅子', '方 有背', 12, 340, 'BB_5'),
       ('辦公桌', '90cm寬', 6, 2200, 'BB_5'),
       ('茶几', NULL, 10, 500, 'AB_53'),
       ('圓桌', '3尺 直徑66cm', 10, 950, 'B_112'),
       ('椅子', '圓', 16, 200, 'AB_53'),
       ('椅子', '方', 6, 200, 'AAA359'),
       ('茶几', '圓', 15, 550, 'B_112');

SELECT *
FROM 供應商;
SELECT *
FROM 物品;

/* 第二題 */
SELECT 物料名稱, SUM(數量 * 單價) AS 目前庫存總值
FROM 物品
GROUP BY 物料名稱;

/* 第三題 */
SELECT 供應商編號
FROM 供應商
WHERE 供應商編號 LIKE '_B%';

/* 第四題 */
SELECT *
FROM 物品;

UPDATE 物品
SET 規格 = '圓椅'
WHERE 規格 = '圓';

SELECT *
FROM 物品;

/* 第五題 */
CREATE TYPE 稱謂 FROM VARCHAR(2);

CREATE DEFAULT 稱謂預設 AS '先生';

CREATE RULE 稱謂規則 AS @稱謂 IN ('先生', '女士', '小姐');