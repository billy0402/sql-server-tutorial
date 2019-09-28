CREATE TRIGGER 新增採購明細
    ON 採購明細
    INSTEAD OF INSERT
    AS
    BEGIN TRANSACTION
DECLARE
    @supplier_id AS INT, @supplier_address AS NCHAR(10);

-- 供應商名稱相同 但地址不同
SELECT 供應商.地址
FROM 供應商
         INNER JOIN inserted
                    ON 供應商.供應商名稱 = inserted.供應商
WHERE 供應商.地址 <> inserted.供應商地址

IF @@ROWCOUNT > 0
    BEGIN
        PRINT '供應商名稱與地址不一致'
    END
ELSE
    BEGIN
        -- 確認有沒有這個供應商
        SELECT @supplier_id = 供應商.編號
        FROM 供應商
                 INNER JOIN inserted
                            ON 供應商.供應商名稱 = inserted.供應商 AND 供應商.地址 = inserted.供應商地址;

        -- 沒有就新增一筆
        IF @@ROWCOUNT = 0
            BEGIN
                INSERT INTO 供應商(供應商名稱, 地址)
                SELECT 供應商, 供應商地址
                FROM inserted
                SET @supplier_id = @@IDENTITY
            END

        -- 零件編號相同 品名不同
        SELECT *
        FROM 零件
                 INNER JOIN inserted
                            ON 編號 = inserted.零件編號
        WHERE 零件.品名 = inserted.品名

        IF @@ROWCOUNT <> 1
            BEGIN
                PRINT '零件品名與編號不一致'
                ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
                -- 確認有沒有這個零件
                SELECT *
                FROM 零件
                         INNER JOIN inserted
                                    ON 編號 = inserted.零件編號
                -- 沒有就新增一筆
                IF @@ROWCOUNT = 0
                    BEGIN
                        INSERT INTO 零件
                        SELECT 零件編號, 品名
                        FROM inserted;
                    END
                -- 採購單重複輸入
                SELECT *
                FROM 採購單
                         INNER JOIN inserted
                                    ON 採購單.編號 = inserted.採購單編號
                WHERE 採購單.供應商編號 = @supplier_id
                  AND 採購單.零件編號 = inserted.零件編號
                  AND 採購單.數量 = inserted.數量
                  AND 採購單.交貨日期 = inserted.交貨日期

                IF @@ROWCOUNT <> 0
                    BEGIN
                        PRINT '採購單重複'
                    END
                ELSE
                    BEGIN
                        -- 沒有重複就新增一筆
                        INSERT INTO 採購單
                        SELECT 採購單編號, @supplier_id, 零件編號, 數量, 交貨日期
                        FROM inserted;
                        COMMIT TRANSACTION
                    END
            END
    END
GO

SELECT *
FROM 供應商;
SELECT *
FROM 採購單;
SELECT *
FROM 零件;
SELECT *
FROM 採購明細;

INSERT INTO 採購明細(採購單編號, 供應商, 供應商地址, 零件編號, 品名, 數量, 交貨日期)
VALUES ('T0076', '上上', 'abc', 'A06', '桌', 3, '05/07/2011');

INSERT INTO 採購明細(採購單編號, 供應商, 供應商地址, 零件編號, 品名, 數量, 交貨日期)
VALUES ('T0077', '嚇嚇', 'abc', 'D331', '物品1', 3, '05/07/2011');