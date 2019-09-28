USE [10646003_hw10];

CREATE TABLE 物品庫存
(
    物品號  NVARCHAR(10),
    品名   NVARCHAR(20),
    庫存數量 INT,
);

INSERT INTO 物品庫存(物品號, 品名, 庫存數量)
VALUES ('TR023', '壓條', 15),
       ('JW056', '蓋板', 28);

SELECT *
FROM 物品庫存;
GO

/* 領料 */
CREATE PROC proc_outbound @item_id NVARCHAR(10),
                          @receive_amount INT
AS

DECLARE @remain_amount INT;
SELECT @remain_amount = 庫存數量 - @receive_amount
FROM 物品庫存
WHERE 物品號 = @item_id
    IF @@ROWCOUNT = 0
        RETURN 1
    ELSE
        BEGIN
            IF @remain_amount < 0
                RAISERROR ('庫存數量不足。', 16, 1);
            ELSE
                UPDATE 物品庫存
                SET 庫存數量=@remain_amount
                WHERE 物品號 = @item_id;

            IF @@ERROR > 0 OR @@ROWCOUNT <> 1
                RETURN 2;
            ELSE
                RETURN 0;
        END
GO

DECLARE
    @return INT, @item_id NVARCHAR(10) = 'TR023', @receive_amount INT = 1;
BEGIN TRANSACTION;
SAVE TRANSACTION temp_tran;

SELECT * FROM 物品庫存;

EXEC @return=proc_outbound @item_id, @receive_amount;

IF @return = 0
    COMMIT TRANSACTION;
ELSE
    IF @return = 1
        PRINT '此物料號不存在:' + @item_id
    ELSE
        BEGIN
            PRINT CONCAT('「物料號:', @item_id, '，領料數:', CONVERT(INT, @receive_amount), '，因庫存數量不足而交易取消」');
            ROLLBACK TRANSACTION temp_tran;
        END

SELECT * FROM 物品庫存;
GO

/* 進料 */
CREATE PROC proc_inbound @item_id NVARCHAR(10),
                         @receive_amount INT
AS

DECLARE @remain_amount INT;
SELECT @remain_amount = 庫存數量 + @receive_amount
FROM 物品庫存
WHERE 物品號 = @item_id
    IF @@ROWCOUNT = 0
        RETURN 1
    ELSE
        BEGIN
            UPDATE 物品庫存
            SET 庫存數量=@remain_amount
            WHERE 物品號 = @item_id;

            IF @@ERROR > 0 OR @@ROWCOUNT <> 1
                RETURN 2;
            ELSE
                RETURN 0;
        END
GO

DECLARE
    @return INT, @item_id NVARCHAR(10) = 'TR023', @receive_amount INT = 50;
BEGIN TRANSACTION;
SAVE TRANSACTION temp_tran;

SELECT * FROM 物品庫存;

EXEC @return=proc_inbound @item_id, @receive_amount;

IF @return = 0
    COMMIT TRANSACTION;
ELSE
    IF @return = 1
        PRINT '此物料號不存在:' + @item_id
    ELSE
        BEGIN
            ROLLBACK TRANSACTION temp_tran;
        END

SELECT * FROM 物品庫存;
GO