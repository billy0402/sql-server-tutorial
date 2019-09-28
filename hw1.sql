CREATE RULE 學號第一碼_rule
    AS @student_id LIKE 'D%' OR @student_id LIKE 'M%' OR @student_id LIKE 'B%';

EXEC sp_bindrule 學號第一碼_rule, '學生.學號';


CREATE RULE 學分數_rule
    AS @unit >= 0 AND @unit <= 6;

EXEC sp_bindrule 學分數_rule, '課程.學分數';

CREATE DEFAULT 學分數_df
    AS 0;

EXEC sp_bindefault 學分數_df, '課程.學分數';


CREATE RULE 性別_rule
    AS @gender IN ('男', '女');

EXEC sp_bindrule 性別_rule, '學生.性別';


CREATE RULE 服役_rule
    AS @serve IN ('已服役', '未服役', '免', '未輸入')

EXEC sp_bindrule 服役_rule, '學生.服役否';


CREATE DEFAULT 服役_df
    AS '未輸入';

EXEC sp_bindefault 服役_df, '學生.服役否';


INSERT INTO 學生(學號, 姓名, 性別, 服役否)
VALUES ('B004', '張三', '男', '未輸入'),
       ('M005', '李四', '女', '免'),
       ('D031', '王武', '男', '未輸入'),
       ('B201', '陳美', '女', '免');

INSERT INTO 課程(課程編號, 課程名稱, 學分數)
VALUES ('CAL', '微積分', 3),
       ('STA', '統計', 2),
       ('DM', '離散數學', 3),
       ('DB', '資料庫', 3),
       ('CC', '通訊網路', 3);

INSERT INTO 修課(學號, 課程編號, 成績)
VALUES ('B004', 'CAL', 75),
       ('B004', 'STA', 81),
       ('B201', 'CAL', 80),
       ('B201', 'STA', 82),
       ('D031', 'DM', 77),
       ('M005', 'DB', 82),
       ('M005', 'CC', 66);


SELECT dbo.學生.學號, dbo.學生.姓名, SUM(dbo.修課.成績 * dbo.課程.學分數) / SUM(dbo.課程.學分數) AS 平均成績
FROM dbo.修課
         INNER JOIN
     dbo.課程 ON dbo.修課.課程編號 = dbo.課程.課程編號
         INNER JOIN
     dbo.學生 ON dbo.修課.學號 = dbo.學生.學號
GROUP BY dbo.學生.學號, dbo.學生.姓名;