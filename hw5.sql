CREATE TABLE 客戶一
(
    編號    INT PRIMARY KEY IDENTITY (1,1),
    姓名    NVARCHAR(10) NOT NULL,
    身分證字號 VARCHAR(10)  NOT NULL,
    稱謂    NVARCHAR(10) DEFAULT '先生',
    電話    VARCHAR(10)  NOT NULL,
);

--CREATE DEFAULT 稱謂_default
--AS '先生';
--EXEC sp_bindefault 稱謂_default, '客戶一.稱謂';

INSERT INTO 客戶一(姓名, 身分證字號, 電話)
VALUES ('客戶1', 'F12345678', '12345678');
-------------------------------------------
CREATE TABLE 客戶二
(
    編號    INT PRIMARY KEY IDENTITY (1,1),
    姓名    NVARCHAR(10) NOT NULL,
    身分證字號 VARCHAR(10)  NOT NULL,
    稱謂    NVARCHAR(10) NOT NULL,
    電話    VARCHAR(10)  NOT NULL,
);

CREATE FUNCTION SetSalutation(@identity_card CHAR(10))
    RETURNS CHAR(10)
BEGIN
    DECLARE
        @gender_number CHAR(1), @salutation CHAR(10);
    SET @gender_number = SUBSTRING(@identity_card, 2, 1);

    IF @gender_number = 1
        SET @salutation = '先生'
    ELSE
        IF @gender_number = 2
            SET @salutation = '小姐'
    RETURN @salutation
END

DECLARE
    @identity_card CHAR(10) = 'F12345678'
INSERT INTO 客戶二(姓名, 身分證字號, 稱謂, 電話)
VALUES ('客戶1', @identity_card, dbo.SetSalutation(@identity_card), '12345678');
-------------------------------------------
CREATE TABLE 客戶三
(
    編號    INT PRIMARY KEY IDENTITY (1,1),
    姓名    NVARCHAR(10) NOT NULL,
    身分證字號 VARCHAR(10)  NOT NULL,
    稱謂    NVARCHAR(10) NOT NULL,
    電話    VARCHAR(10)  NOT NULL,
);

CREATE PROCEDURE procedure_set_salutation @姓名 NVARCHAR(10),
                                          @身分證字號 VARCHAR(10),
                                          @電話 VARCHAR(10)
AS
DECLARE @gender_number CHAR(1) = SUBSTRING(@身分證字號, 2, 1);
    IF ISNUMERIC(@gender_number) = 1
        IF @gender_number = 1
            INSERT INTO 客戶三(姓名, 身分證字號, 稱謂, 電話)
            VALUES (@姓名, @身分證字號, '先生', @電話);
        ELSE
            IF @gender_number = 2
                INSERT INTO 客戶三(姓名, 身分證字號, 稱謂, 電話)
                VALUES (@姓名, @身分證字號, '小姐', @電話);
            ELSE
                PRINT '「身分證字號不正確，無法決定稱謂」'
    ELSE
        PRINT '「身分證字號不正確，無法決定稱謂」';

    EXEC dbo.procedure_set_salutation
         @姓名 = '客戶1',
         @身分證字號 = 'F123456789',
         @電話 = '12345678';