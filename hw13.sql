/* 方法一 Rule (不可以) */
Rule 主要是確認新增的資料是否不合規則設定，無法帶動其他欄位資料修改

/* 方法二 Function (可以) */
CREATE FUNCTION get_age_by_birthday(@birthday DATE)
    RETURNS INT
AS
BEGIN
    RETURN FLOOR(DATEDIFF(DY, @birthday, GETDATE()) / 365.25);
END
GO

CREATE TABLE dbo.採購員二
(
    採購員代號 char(5)      NOT NULL,
    採購員姓名 nvarchar(30) NOT NULL,
    出生年月日 date         NOT NULL,
    年齡    AS dbo.get_age_by_birthday(出生年月日)
)
GO

SELECT *
FROM dbo.採購員二;
INSERT INTO dbo.採購員二
VALUES ('A001', 'Test1', '1998/04/02');
SELECT *
FROM dbo.採購員二;
GO

/* 方法三 Trigger (可以) */
CREATE TABLE dbo.採購員三
(
    採購員代號 char(5)      NOT NULL,
    採購員姓名 nvarchar(30) NOT NULL,
    出生年月日 date         NOT NULL,
    年齡    int
)
GO

CREATE TRIGGER trigger_get_age_by_birthday
    ON dbo.採購員三
    FOR INSERT
    AS
    DECLARE
        @id CHAR(5), @name NVARCHAR(30), @birthday DATE;
SELECT @id = 採購員代號, @name = 採購員姓名, @birthday = 出生年月日
FROM inserted;
UPDATE dbo.採購員三
SET 年齡 = FLOOR(DATEDIFF(DY, @birthday, GETDATE()) / 365.25)
WHERE 採購員代號 = @id
  AND 採購員姓名 = @name
  AND 出生年月日 = @birthday;
GO

SELECT *
FROM dbo.採購員三;
INSERT INTO dbo.採購員三(採購員代號, 採購員姓名, 出生年月日)
VALUES ('A001', 'Test1', '1998/04/02');
SELECT *
FROM dbo.採購員三;
GO
 
/* 方法四 Stored Procedure (可以) */
CREATE TABLE dbo.採購員四
(
    採購員代號 char(5)      NOT NULL,
    採購員姓名 nvarchar(30) NOT NULL,
    出生年月日 date         NOT NULL,
    年齡    int          NOT NULL
)
GO

CREATE PROC proc_get_age_by_birthday @id CHAR(5),
                                     @name NVARCHAR(30),
                                     @birthday DATE
AS
INSERT INTO dbo.採購員四
VALUES (@id, @name, @birthday, FLOOR(DATEDIFF(DY, @birthday, GETDATE()) / 365.25));
GO

SELECT *
FROM dbo.採購員四;
EXEC dbo.proc_get_age_by_birthday 'A001', 'Test1', '1998/04/02';
SELECT *
FROM dbo.採購員四;
GO