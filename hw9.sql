INSERT INTO dbo.成績一(學號, 學生姓名, 科目, 成績)
VALUES ('B0023', '李立行', '資料庫', 89);

TRUNCATE TABLE dbo.成績二;
SELECT *
FROM dbo.成績二;

DECLARE cursor_score CURSOR
    FOR
    SELECT 學號, MAX(成績)
    FROM dbo.成績一
    GROUP BY 學號;

OPEN cursor_score;
DECLARE
    @id NCHAR(6), @score INT;
FETCH NEXT FROM cursor_score
    INTO @id, @score;
WHILE (@@FETCH_STATUS = 0)
BEGIN
    DECLARE
        @all_subject VARCHAR(50)='';
    SELECT @all_subject = @all_subject + 科目
    FROM dbo.成績一
    WHERE 學號 = @id
      AND 成績 = @score;
    SELECT @all_subject;

    INSERT INTO dbo.成績二
    SELECT TOP 1 學號, 學生姓名, 成績, @all_subject
    FROM dbo.成績一
    WHERE 學號 = @id
      AND 成績 = @score;

    FETCH NEXT FROM cursor_score
        INTO @id, @score;
END
CLOSE cursor_score;
DEALLOCATE cursor_score;

SELECT *
FROM dbo.成績二;