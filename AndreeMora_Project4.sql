-- Name: Andree Mora
-- Class: IS443
-- Project 4 Script File




DROP TABLE ENROLLMENT CASCADE CONSTRAINTS;
DROP TABLE OFFERING CASCADE CONSTRAINTS;
DROP TABLE STUDENT CASCADE CONSTRAINTS;
DROP TABLE FACULTY CASCADE CONSTRAINTS;
DROP TABLE COURSE CASCADE CONSTRAINTS;

-- Creating Tables 

Create Table STUDENT (
StdID number(5) PRIMARY KEY,
StdFN VARCHAR2(20),
StdLN Varchar2(20),
StdCity varchar2(30),
StdState char(2),
StdZip varchar2(10),
StdMajor varchar2(10),
StdClass varchar2(5),
StdGPA number(3,1),
StdBalance number(10,2)
);

Create Table COURSE (
CourseNo varchar2(10) PRIMARY KEY,
CrsDesc varchar2(50),
CrsCredits number(2)
);

Create table FACULTY (
FacSSN number(5) PRIMARY KEY,
FacFN varchar2(20),
FacLN varchar2(20),
FacDept Varchar2(10),
FacRank VARCHAR2(10),
facHireDate DATE,
FacSalary number(10,2),
FacSupervisor number(5),
Constraint fk_fac_supervisor 
    FOREIGN KEY (facSupervisor)
    REFERENCES FACULTY(FacSSN)
);

Create Table OFFERING (
OfferNo number(5) PRIMARY KEY,
CourseNo varchar2(10),
OffTerm Varchar2(10),
OffYear number(4),
OffLoca Varchar2(20),
OffTime Varchar2(20),
OffDay Varchar2(10),
FacSSN number(5),
CONSTRAINT fk_off_course 
    FOREIGN KEY (CourseNo)
    REFERENCES COURSE(CourseNo),
CONSTRAINT fk_off_fac  
    FOREIGN KEY (FacSSN)
    REFERENCES FACULTY(FacSSN)
);

Create Table ENROLLMENT (
StdID number(5),
OfferNo number(5),
EnrGrade char(1),
CONSTRAINT pk_enrollment PRIMARY KEY (StdID, offerNo),
CONSTRAINT fk_enr_student FOREIGN KEY (StdID)
    REFERENCES STUDENT(StdID),
CONSTRAINT fk_enr_offering FOREIGN KEY (OfferNo)
    REFERENCES OFFERING(OfferNo)
);

-- Inserting Values into Tables 

insert into STUDENT 
Values
(101,'Joe','Smith','Eau Claire', 'WI', '18121','IS','FR',3.8,0),
(102,'Rob','King', 'Melrose','MN','56352','IS','JR',3.2,500),
(103,'Dan','Robinson','Sartell','MN','98042','IS','JR',3.6,350),
(104,'Sue','Williams','St. Cloud','MN','56301','ACCT','SR',3.2,0),
(105,'Don','Robinson','St. Paul','MN','55103','MKTG','SR',3.4,1560)
);

Insert into COURSE 
values
('CSCI 200', 'Elements of Computing',3),
('IS 250', 'Apllication Program Dev. I',3),
('IS 345', 'Application Program Dev. II',3),
('IS 454', 'Data Mining for Desicion Supoort',3),
('IS 356','Systems Analysis and Design I',3),
('IS 460', 'Project Management',3),
('ACCT 291', 'Accounting Principles II',3),
('IS 443', 'Database Design',3)
);

Insert into FACULTY
Values 
(9001, 'Leonard', 'Vince', 'IS', 'ASST', DATE '1997-04-12', 67000, 9003),
(9002, 'Victor', 'Strong', 'CSCI', 'ASSO', DATE '1999-08-08', 70000, 9003),
(9003, 'Nicki', 'Colan', 'IS', 'PROF', DATE '1981-08-20', 75000, 9010),
(9004, 'Fred', 'Wells', 'ACCT', 'ASST', DATE '1996-08-28', 60000, 9010),
(9010, 'Chris', 'Macon', 'ACCT', 'ASST', DATE '1980-08-04', 75000, NULL)
);

Insert into OFFERING 
Values 
(2201,'CSCI 200','Spring',2020,'ECC135','10:30am','MWF',9002),
(2202,'CSCI 200','Spring',2020,'ECC135','8:00am','TTH',9002),
(2203,'IS 356','Fall',2020,'CH494','3:30pm','TTH',9001),
(1102, 'ACCT 291', 'Spring', 2020, 'CH142', '2:00pm', 'MWF', 9004),
(2204, 'IS 345', 'Fall', 2020, 'CH494', '12:30pm', 'TTH', 9003),
(1101, 'ACCT 291', 'Fall', 2020, 'CH350', '12:30pm', 'MWF', 9010),
(2205, 'IS 443', 'Fall', 2020, 'CH494', '9:30am', 'MWF', 9003),
(1015, 'IS 443', 'Fall', 2019, 'CH14A', '11:00am', 'TTH', 9003),
(1016, 'IS 345', 'Spring', 2019, 'CH494', '12:30pm', 'MWF', 9001)
);

insert into ENROLLMENT
values 
(101, 2201, 'A'),
(102, 2202, 'B'),
(102, 2203, 'C'),
(103, 2203, 'B'),
(103, 2201, 'C'),
(103, 1101, 'B'),
(104, 2202, 'A'),
(101, 2203, 'A'),
(101, 1101, 'B'),
(101, 2205, 'C'),
(102, 2205, 'B'),
(104, 2205, 'B')
);

-- Queries 

--Q1 (DONE)
select s.StdID,s.StdFN,s.StdLN from STUDENT s 
JOIN ENROLLMENT e on s.StdID = e.StdID 
JOIN OFFERING o on e.OfferNo = o.OfferNo
where O.CourseNo = 'CSCI 200' 
and O.OffTerm = 'Spring'
and O.OffYear = 2020
order by s.StdID;

--Q2 (DONE)
select distinct s.StdFN || ' ' || s.StdLN as FullName, 
s.StdMajor from STUDENT s 
join ENROLLMENT e on s.StdID = e.StdID 
join OFFERING o on e.OfferNo = o.OfferNo
where e.EnrGrade = 'A'
and o.OffTerm = 'Spring'
and o.OffYear = 2020;

--Q3 (DONE)
Select s.StdFN || ' ' || s.StdLN as FullName,
s.StdState,s.StdMajor 
from STUDENT s  
where s.StdMajor = 'IS' and s.StdState = 'MN';

--Q4 (DONE)
Select c.CourseNo, c.CrsCredits, f.FacLN from STUDENT s
join ENROLLMENT e on s.StdID = e.StdID 
join OFFERING o on e.OfferNo = o.OfferNo
join COURSE c on o.CourseNo = c.CourseNo
join FACULTY f on o.FacSSN = f.FacSSN
where s.StdFN = 'Rob'
and s.StdLN = 'King'
order by c.CourseNo;

--Q5 (DONE)
select f.FacLN || ' ' || f.FacFN as ProfessorName,
count(o.OfferNo) as NumClasses 
from FACULTY 
left join OFFERING on f.FacSSN = o.FacSSN 
and o.OffYear = 2020
where f.FacSalary > (select AVG(FacSalary) from FACULTY)
group by f.FacLN, f.FacFN
Having count(o.OfferNo) < 2 
order by NumClasses;

--Q6 (DONE)
select f.FacFN || ' ' || f.FacLN as FullName, 
ROUND( (SYSDATE - f.FacHireDate)/365,1) as YearsEmployed 
from FACULTY 
order by YearsEmployed; 

--Q7 (DONE)
Select StdMajor, ROUND(AVG(StdGPA), 2) as AvgGPA 
from STUDENT
group by StdMajor
order by AVG(StdGPA);

--Q8 (DONE)
select f.FacFN || ' ' || f.FacLN as FullName, 
COUNT(o.OfferNo) as NumClasses 
from FACULTY 
LEFT JOIN 
OFFERING on f.FacSSN = o.FacSSN
group by f.FacFN, f.FacLN
order by NumClasses;

-- Q9 (done)
select s.StdFN || ' ' ||  s.StdLN as FullName, 
sum(CrsCredits) as TotalCredits 
from STUDENT s 
join ENROLLMENT e on s.StdID = e.StdID 
join OFFERING o on e.OfferNo = o.OfferNo
join COURSE c on o.CourseNo = c.CourseNo
where s.StdFN = 'Joe'
and s.StdLN = 'Smith'
group by s.StdFN, s.StdLN;

-- Q10
select c.CourseNo,c.CrsDesc,
COUNT(e.StdID) as NumEnrollments, 
COUNT(e.StdID) * c.CrsCredits as TotalStudentCredits
from COURSE c
join OFFERING o on c.CourseNo = o.CourseNo
left join ENROLLMENT e on o.OfferNo = e.OfferNo
where o.OffYear = 2020
group by c.CourseNo, c.CrsDesc, c.CrsCredits
order by c.CourseNo;








