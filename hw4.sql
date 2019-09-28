CREATE TABLE 物料庫存
(
    物料編號 VARCHAR(10),
    品名   NVARCHAR(10),
    庫存數量 INT,
    單位   NVARCHAR(10),
    單價   MONEY,
);

INSERT INTO 物料庫存(物料編號, 品名, 庫存數量, 單位, 單價)
VALUES ('B002', '壓條', 24, '支', 85),
       ('A001', '活動板手', 33, '支', 250),
       ('B002', '壓條', 26, '支', 82),
       ('A002', '蓋片', 123, '片', 4),
       ('A002', '蓋片', 55, '片', 4),
       ('C001', '焊條', 41, '支', 12);

CREATE PROCEDURE proc_find_num @物料編號 VARCHAR(10),
                               @品名 NVARCHAR(10) OUTPUT,
                               @總庫存量 INT OUTPUT,
                               @單位 NVARCHAR(10) OUTPUT,
                               @庫存總值 INT OUTPUT
AS
SELECT @品名 = 品名,
       @總庫存量 = 庫存數量,
       @單位 = 單位,
       @庫存總值 = 庫存數量 * 單價
FROM 物料庫存
WHERE 物料編號 = @物料編號
    IF @@rowcount > 0
        RETURN 1
    ELSE
        RETURN 0;

DECLARE
    @題目物料編號 VARCHAR(10),
    @result INT,
    @物料編號   VARCHAR(10),
    @品名     NVARCHAR(10),
    @總庫存量   INT,
    @單位     NVARCHAR(10),
    @庫存總值   INT;
    SET @題目物料編號 = '1234';
    EXEC @result = proc_find_num @題目物料編號,
                   @品名 OUTPUT,
                   @總庫存量 OUTPUT,
                   @單位 OUTPUT,
                   @庫存總值 OUTPUT;

    IF @result = 1
        PRINT CONCAT('物料編號: ', @物料編號, ', 品名: ', @品名, ', 總庫存量: ' + CONVERT(CHAR(3), @總庫存量), ', 單位: ', @單位, ', 庫存總值: ',
                     CONVERT(CHAR, @庫存總值))
    ELSE
        PRINT '--- 無此物料 ---';

    IF @result = 1
        PRINT CONCAT('物料編號: ', @物料編號, ', 品名: ', @品名, ', 總庫存量: ' + CONVERT(CHAR(3), @總庫存量), ', 單位: ', @單位, ', 庫存總值: ',
                     CONVERT(CHAR, @庫存總值))
    ELSE
        PRINT '--- 無物料編號為「物料編號」之物料 ---';