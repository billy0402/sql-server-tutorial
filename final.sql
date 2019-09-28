/* 第一題 */
/* (3) */
CREATE FUNCTION 訂單_總金額(@order_id CHAR(3))
    RETURNS INT
AS
BEGIN
    DECLARE
        @total_money INT;

    SELECT @total_money = SUM(數量 * 單價)
    FROM 物料項
    WHERE 訂單號 = @order_id
    GROUP BY 訂單號;

    RETURN @total_money;
END

/* (1) */
CREATE TABLE 訂單
(
    訂單號 CHAR(3) NOT NULL,
    日期  DATE    NOT NULL,
    總金額 AS dbo.訂單_總金額(訂單號),
    CONSTRAINT pk_訂單 PRIMARY KEY (訂單號)
);

CREATE TABLE 物料項
(
    訂單號 CHAR(3) NOT NULL,
    物料號 CHAR(3) NOT NULL,
    品名  CHAR(1) NOT NULL,
    數量  INT     NOT NULL,
    單價  INT     NOT NULL,

    CONSTRAINT pk_物料項 PRIMARY KEY (訂單號, 物料號),
    CONSTRAINT fk_物料項_訂單號 FOREIGN KEY (訂單號) REFERENCES 訂單 (訂單號) ON UPDATE CASCADE
);

INSERT INTO 訂單(訂單號, 日期)
VALUES ('S23', '2019-06-01'),
       ('S45', '2018-12-11'),
       ('S50', '2019-03-12');

INSERT INTO 物料項
VALUES ('S23', 'M02', 'A', 23, 15),
       ('S23', 'M13', 'B', 100, 100),
       ('S50', 'M13', 'B', 33, 100),
       ('S50', 'M92', 'C', 48, 50),
       ('S50', 'M02', 'A', 55, 14),
       ('S45', 'M07', 'D', 27, 200);

SELECT *
FROM 訂單;

/* (2) */
CREATE TRIGGER 採購單_insert
    ON 採購單
    INSTEAD OF INSERT
    AS
BEGIN
    BEGIN TRANSACTION
        DECLARE
            @order_id CHAR(3), @create_date DATE, @item_id CHAR(3), @item_name CHAR(1), @count INT, @price INT

        SELECT @order_id = 訂單號, @create_date = 日期
        FROM inserted;

        /* (4) */
        SELECT *
        FROM 訂單
        WHERE 訂單號 = @order_id;

        IF @@ROWCOUNT > 0
            BEGIN
                PRINT '訂單號重複 = ' + @order_id;
                ROLLBACK;
            END
        ELSE
            BEGIN
                Declare rs Cursor For SELECT * FROM inserted;
                OPEN rs;
                FETCH NEXT FROM rs INTO @order_id, @create_date, @item_id, @item_name, @count, @price;
                INSERT INTO 訂單(訂單號, 日期)
                VALUES (@order_id, @create_date);
                While @@FETCH_STATUS = 0
                BEGIN
                    INSERT INTO 物料項
                    VALUES (@order_id, @item_id, @item_name, @count, @price);
                    FETCH NEXT FROM rs INTO @order_id, @create_date, @item_id, @item_name, @count, @price;
                END
                CLOSE rs
                DEALLOCATE rs
                COMMIT;
            END
END

SELECT *
FROM 訂單;
SELECT *
FROM 物料項;
SELECT *
FROM 採購單;

INSERT INTO 採購單
VALUES ('S31', '2019-06-08', 'M02', 'A', 39, 16),
       ('S31', '2019-06-08', 'M13', 'B', 50, 105);

SELECT *
FROM 訂單;
SELECT *
FROM 物料項;
SELECT *
FROM 採購單;

INSERT INTO 採購單
VALUES ('S31', '2019-06-08', 'M02', 'A', 39, 16),
       ('S31', '2019-06-08', 'M13', 'B', 50, 105);