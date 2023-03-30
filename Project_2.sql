# Answer 1
CREATE DATABASE alumni;

# Answer 3
USE alumni;
DESC college_a_hs;
DESC college_a_se;
DESC college_a_sj;
DESC college_b_hs;
DESC college_b_se;
DESC college_b_sj;

# Answer 6
CREATE VIEW college_a_hs_v AS (SELECT * FROM college_a_hs WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  HSDegree IS NOT NULL AND EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL) ;
SELECT * FROM college_a_hs_v;

# Answer 7

CREATE VIEW college_a_se_v AS (SELECT * FROM college_a_se WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  Organization IS NOT NULL AND  Location IS NOT NULL);
SELECT * FROM college_a_se_v;

# Answer 8
CREATE VIEW college_a_sJ_v AS (SELECT * FROM college_a_sJ WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM college_a_sj_V;

# Answer 9
CREATE VIEW college_b_hs_v AS (SELECT * FROM college_b_hs WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL AND Branch IS NOT NULL
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  HSDegree IS NOT NULL AND EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM college_b_hs_v;

# Answer 10
CREATE VIEW college_b_se_v AS (SELECT * FROM college_b_se WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL AND Branch IS NOT NULL
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  Organization IS NOT NULL AND  Location IS NOT NULL);

SELECT * FROM college_b_se_v;

# Answer 11
CREATE VIEW college_b_sj_v AS (SELECT * FROM college_b_sj WHERE RollNo IS NOT NULL AND  LastUpdate IS NOT NULL
AND  Name IS NOT NULL AND  FatherName IS NOT NULL AND  MotherName IS NOT NULL AND Branch IS NOT NULL 
AND  Batch IS NOT NULL AND  Degree IS NOT NULL AND  PresentStatus IS NOT NULL
AND  Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);

SELECT * FROM college_b_sj_v;

# Answer 12
DELIMITER |
CREATE PROCEDURE stringfunc()
BEGIN

SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM college_a_hs_v;
SELECT 
    LOWER(Name), LOWER(FatherName), LOWER(MotherName)
FROM
    college_a_se_v;
SELECT 
    LOWER(Name), LOWER(FatherName), LOWER(MotherName)
FROM
    college_a_sj_v;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM college_b_hs_v;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM college_b_se_v;
SELECT LOWER(Name),LOWER(FatherName),LOWER(MotherName) FROM college_b_sj_v;
END|
DELIMITER ;

CALL stringfunc()

# Answer 14

DELIMITER $$
CREATE PROCEDURE get_name_collegeA
(
INOUT alumniname TEXT
)
BEGIN
DECLARE finished INTEGER DEFAULT 0;
DECLARE namelist VARCHAR(4000) DEFAULT "";

DECLARE namedetail
CURSOR FOR 
SELECT Name FROM college_a_hs_v UNION SELECT Name FROM college_a_se_v UNION SELECT Name FROM college_a_sj_v;


DECLARE CONTINUE HANDLER
FOR NOT FOUND SET finished=1;
OPEN namedetail;

-- STARTING LABEL DEFINITION
getname:

-- LOOP STATEMENT
 LOOP
FETCH namedetail INTO namelist;
IF finished=1
THEN
LEAVE getname;
END IF;

SET alumniname=CONCAT(namelist," ; ",alumniname);

END LOOP getname;

CLOSE namedetail;
END $$
DELIMITER ;

SET @name="";
CALL get_name_collegeA(@name);
SELECT @name;


# Answer 15
DELIMITER $$
CREATE PROCEDURE get_name_collegeB
(
INOUT alumniname TEXT
)
BEGIN
DECLARE finished INTEGER DEFAULT 0;
DECLARE namelist VARCHAR(4000) DEFAULT "";

DECLARE namedetail
CURSOR FOR 
SELECT Name FROM college_b_hs_v UNION SELECT Name FROM college_b_se_v UNION SELECT Name FROM college_b_sj_v;


DECLARE CONTINUE HANDLER
FOR NOT FOUND SET finished=1;
OPEN namedetail;

-- STARTING LABEL DEFINITION
getname:

-- LOOP STATEMENT
 LOOP
FETCH namedetail INTO namelist;
IF finished=1
THEN
LEAVE getname;
END IF;

SET alumniname=CONCAT(namelist," ; ",alumniname);

END LOOP getname;

CLOSE namedetail;
END $$
DELIMITER ;

SET @name="";
CALL get_name_collegeB(@name);
SELECT @name;

# Answer 16
with temptable as( 
select a.* ,'a'  as college from
(select presentstatus from college_a_hs_v union all
select presentstatus from college_a_se_v union all 
select presentstatus from college_a_sj_v) as a
union all
select b.* , 'b' as college from
(select presentstatus from college_b_hs_v union all
select presentstatus from college_b_se_v union all 
select presentstatus from college_b_sj_v) as b) 

select "HigherStudies" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Higher Studies')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Higher Studies')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage'

union all

select "Self Employed" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Self Employed')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Self Employed')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage'

union all

select "Service Job" PresentStatus,
(select count(*) from temptable where temptable.college='a' and temptable.presentstatus='Service/Job')/
(select count(*) from temptable where temptable.college='a' )*100 as 'College A Percentage',
(select count(*) from temptable where temptable.college='b' and temptable.presentstatus='Service/Job')/
(select count(*) from temptable where temptable.college='b' )*100 as 'College B Percentage';