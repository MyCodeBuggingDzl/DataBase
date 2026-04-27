--CREATE DATABASE Assignment_03
CREATE TABLE Department (  
    DeptID INT PRIMARY KEY,  
    DeptName VARCHAR(100) NOT NULL, 
    DeptHeadID INT NULL
);

CREATE TABLE Instructor (  
    InstructorID INT PRIMARY KEY,  
    FullName VARCHAR(100) NOT NULL,  
    DeptID INT,  
    HireDate DATE NOT NULL,   
    Email VARCHAR(100) NOT NULL UNIQUE,   
    Salary DECIMAL(10, 2) CHECK (Salary > 0),
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID) ON DELETE SET NULL
);

CREATE TABLE Course (  
    CourseID CHAR(6) PRIMARY KEY,  
    CourseName VARCHAR(100) NOT NULL,  
    Credits INT CHECK (Credits BETWEEN 1 AND 4),  
    DeptID INT,  
    InstructorID INT,  
    MaxEnrollment INT CHECK (MaxEnrollment > 0),  
    PreReq CHAR(6),  
    FOREIGN KEY (DeptID) REFERENCES Department(DeptID) ON DELETE SET NULL,
    FOREIGN KEY (InstructorID) REFERENCES Instructor(InstructorID) ON DELETE SET NULL,
    FOREIGN KEY (PreReq) REFERENCES Course(CourseID) 
);

CREATE TABLE Student (  
    StudentID INT PRIMARY KEY,  
    Last VARCHAR(15) NOT NULL,
    First VARCHAR(15) NOT NULL,   
    DateOfBirth DATE NOT NULL,  
    ResidencyStatus VARCHAR(15) CHECK (ResidencyStatus IN ('Domestic', 'International')),  
    PhoneNumber CHAR(14)  
);

CREATE TABLE Enrollment (  
    EnrollmentID INT PRIMARY KEY IDENTITY(1,1),  
    StudentID INT,  
    CourseID CHAR(6),  
    EnrollmentDate DATE DEFAULT GETDATE(),  
    Grade CHAR(2) CHECK (Grade IN ('A', 'B', 'C', 'D', 'F') OR Grade IS NULL), 
    EnrollmentStatus VARCHAR(15) CHECK (EnrollmentStatus IN ('Active', 'Completed', 'Withdrawn')),  
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,  
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) ON DELETE CASCADE
);

CREATE TABLE Payment (  
    PaymentID INT PRIMARY KEY IDENTITY(1,1),  
    StudentID INT,  
    Amount DECIMAL(10,2) CHECK (Amount > 0),  
    PaymentDate DATE DEFAULT GETDATE(),  
    Description VARCHAR(255), 
    PaymentMethod VARCHAR(20) CHECK (PaymentMethod IN ('Credit Card', 'Bank Transfer', 'Cash')),  
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE
);

CREATE TABLE EnrollmentLog (  
    LogID INT PRIMARY KEY IDENTITY(1,1),  
    EnrollmentID INT,  
    StudentID INT,  
    CourseID CHAR(6),  
    DateInserted DATETIME DEFAULT GETDATE(),  
    ChangeDescription VARCHAR(255),  
    ActionBy VARCHAR(100), 
	UserId VARCHAR (40),
	FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID) ,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) 
);

CREATE TABLE GradeChangeLog (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    EnrollmentID INT,
    StudentID INT,
    CourseID CHAR(6),
    OldGrade CHAR(2),
    NewGrade CHAR(2),
	UserId VARCHAR (40),
	ChangeDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollment(EnrollmentID) ,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ,
    FOREIGN KEY (CourseID) REFERENCES Course(CourseID) 
);

INSERT INTO Department (DeptID, DeptName, DeptHeadID) VALUES
(1, 'Computer Science', 333),
(2, 'Telecommunications', 222),
(3, 'Accounting', 666),
(4, 'Math and Science', 555),
(5, 'Arts', 444),
(6, 'Mathematics', 111),
(7, 'History', NULL),
(8, 'Physics', NULL);

INSERT INTO Instructor (InstructorID, FullName, DeptID, HireDate, Email, Salary) VALUES
(111, 'Dr. John Smith', 6, '2020-08-15', 'john.smith@university.edu', 75000),
(222, 'Prof. Sarah Johnson', 2, '2018-09-01', 'sarah.johnson@university.edu', 80000),
(333, 'Dr. Michael Brown', 1, '2019-01-10', 'michael.brown@university.edu', 72000),
(444, 'Jones Williams', 5, '2017-01-10', 'jones.williams@university.edu', 8234.20),
(555, 'Mobley Vajpayee', 4, '2017-09-10', 'mobley.vajpayee@university.edu', 55000),
(666, 'Sen Rivera', 3, '2014-01-10', 'sen.rivera@university.edu', 5123.44),
(777, 'Chang Collins', 1, '2023-01-10', 'chang.collins@university.edu', 5436.70),
(888, 'Dr. Alex Smith', 6, '2020-08-15', 'alex.smith@university.edu', 55000),
(999, 'Dr. Emily Rose', 7, '2021-06-01', 'emily.rose@university.edu', 70000);

INSERT INTO Course (CourseID, CourseName, Credits, DeptID, InstructorID, MaxEnrollment, PreReq) VALUES
('CS100', 'Intro to Computer Science', 3, 1, 777, 50, NULL),
('MA150', 'College Algebra', 3, 6, 111, 40, NULL),
('MA202', 'Linear Algebra', 4, 6, 888, 40, 'MA150'),
('EN100', 'Basic English', 2, 5, 444, 35, NULL),
('LA123', 'English Literature', 3, 5, 444, 40, 'EN100'),
('CIS253', 'Database Systems', 3, 1, 777, 40, NULL),
('CIS265', 'Systems Analysis', 3, 1, 333, 45, 'CIS253'),
('AC101', 'Accounting', 3, 3, 666, 30, NULL),
('HI101', 'World History', 3, 7, 999, 30, NULL),
('PH101', 'General Physics', 4, 8, NULL, 30, NULL);

INSERT INTO Student (StudentID, Last, First, DateOfBirth, ResidencyStatus, PhoneNumber) VALUES
(100, 'Green', 'Alice', '2000-05-10', 'Domestic', '(514)555-1111'),
(101, 'White', 'Bob', '1999-11-22', 'International', '(514)555-2222'),
(102, 'Black', 'Charlie', '2001-03-05', 'Domestic', '(514)555-3333'),
(103, 'Diaz', 'Jose', '1983-12-02', 'Domestic', '(973)555-1111'),
(104, 'Tyler', 'Mickey', '1984-03-18', 'Domestic', '(718)555-2222'),
(105, 'Patel', 'Rajesh', '1985-12-12', 'International', '(732)555-3333'),
(106, 'Rickles', 'Deborah', '1970-10-20', 'Domestic', '(732)555-4444'),
(107, 'Lee', 'Brian', '1985-11-28', 'International', '(212)555-5555'),
(108, 'Khan', 'Amir', '1984-07-07', 'International', '(201)555-6666'),
(109, 'Morris', 'Anna', '2002-02-20', 'Domestic', '(647)555-7777'),
(110, 'Nguyen', 'Linh', '2001-10-13', 'International', '(438)555-8888');

INSERT INTO Enrollment (StudentID, CourseID, Grade, EnrollmentStatus) VALUES
(100, 'CS100', 'A', 'Completed'),
(101, 'MA150', 'B', 'Completed'),
(102, 'MA202', NULL, 'Active'),
(103, 'CIS253', 'A', 'Completed'),
(104, 'CS100', NULL, 'Active'),
(105, 'LA123', 'C', 'Completed'),
(106, 'EN100', 'B', 'Completed'),
(107, 'MA202', 'A', 'Completed'),
(108, 'CIS265', NULL, 'Active'),
(109, 'HI101', NULL, 'Active'),
(110, 'PH101', NULL, 'Active');

INSERT INTO Payment (StudentID, Amount, PaymentDate, Description, PaymentMethod) VALUES
(100, 1400.00, '2024-08-10', 'Fall 2024 Tuition Payment', 'Bank Transfer'),
(101, 1450.00, '2024-08-15', 'Fall 2024 Tuition Payment', 'Credit Card'),
(102, 1600.00, '2024-01-12', 'Spring 2024 Tuition Payment', 'Cash'),
(103, 1500.00, '2024-01-20', 'Spring 2024 Tuition Payment', 'Bank Transfer'),
(104, 1550.00, '2023-08-18', 'Fall 2023 Tuition Payment', 'Credit Card'),
(105, 1300.00, '2023-01-10', 'Spring 2023 Tuition Payment', 'Cash'),
(106, 1700.00, '2022-08-25', 'Fall 2022 Tuition Payment', 'Credit Card'),
(107, 1800.00, '2022-01-05', 'Spring 2022 Tuition Payment', 'Bank Transfer'),
(108, 1650.00, '2023-08-14', 'Fall 2023 Tuition Payment', 'Cash'),
(109, 1700.00, '2025-01-15', 'Spring 2025 Tuition Payment', 'Credit Card'),
(110, 1800.00, '2025-01-18', 'Spring 2025 Tuition Payment', 'Bank Transfer');


-- Add DeptHead FK after Instructor table
ALTER TABLE Department
ADD CONSTRAINT FK_Dept_Head FOREIGN KEY (DeptHeadID) REFERENCES Instructor(InstructorID) ON DELETE SET NULL;


SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Payment;

--1. Create a scalar function that calculates and returns a student’s tuition for a course based on: 
--  ? Credit hours (Credits from Course) 
----  ? Residency status:  
--o Domestic = $300 per credit 
--o International = $800 per credit 
--  ? @StudentID, @CourseID will be provided as parameters

Alter Function StudentTuition (@StudentID int, @CourseID char(5))
returns int
as
Begin
    Declare @status varchar(15), @credits int, @totalCreds int

    select @status = ResidencyStatus from Student where StudentID = @StudentID
    select @credits = Credits from Course where CourseID = @CourseID

    begin
        if @status = 'Domestic'
           set @totalCreds = @credits * 300
         
    else
        if @status = 'International'
           set @totalCreds = @credits * 800

    end
        return @totalcreds
end

--test
    select dbo.StudentTuition (100, 'CS100') as 'Student Tuition'



    
SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Payment;

--2. Create a Trigger to Prevent Course Deletion When Students are Enrolled. The trigger must satisfy the following requirements:
--a. Check if there are any students currently enrolled in the course that are being deleted. 
--b. If there are students enrolled, the deletion should be rolled back using ROLLBACK TRANSACTION
--c. Print a message (PRINT 'Cannot delete course...')) to notify that the course cannot be deleted because there are existing enrollments

alter trigger CourseDeletion 
on Course
Instead of Delete
as 
begin
    Declare @CourseID char(5)

    if exists(select 1 from deleted d join Enrollment e on d.CourseID = e.CourseID)

   Begin Transaction
        delete course
        where @CourseID = CourseID
        Print 'Cannot delete Course'
   Rollback Transaction
End

    delete course
    where CourseID = 'PH101'




SELECT * FROM Department;
SELECT * FROM Instructor;
SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Enrollment;
SELECT * FROM Payment;
        
--3. Create a stored procedure that meets the following requirements: 
--a. Accepts a @StudentID as an input parameter.
--b. Checks whether the student exists in the student table.
--        If the student exists but is not enrolled in any courses: 
--        a. Print: "Student exists but is not registered in any courses." 
--c. If the student is enrolled in courses, return the number of courses the student is enrolled in  

alter Procedure PRC_enroll @StudentID int
as
begin   
   Declare @EnrollStats varchar(20)

  select @EnrollStats = enrollmentStatus from Enrollment where StudentID = @StudentID

       
       if not exists (select 1 from student where StudentID = @StudentID)
       Begin
        Print 'This student does not exits'
       End
    
        if not exists (select 1 from Enrollment where StudentID = @StudentID)
    Begin
            Print 'The Student exists but is not registered in any courses'
    End
            
                if @EnrollStats = 'Active'
                select count(*) as 'Number of courses'
                from Enrollment
                where StudentID = @StudentID
            else
                if @EnrollStats = 'Completed'
                 Print 'This student has completed thier course'
End

Exec PRC_enroll 500





SELECT * FROM Student;
SELECT * FROM Enrollment;
Select * From GradeChangeLog

--4. Create a trigger that will insert records into a GradeChangeLog after an enrollment grade update,
--with the condition that the grade must have been changed and both old and new grades are not null

Create Trigger GradeUpdate
On Enrollment
After update
as
begin
       Insert into GradeChangeLog (EnrollmentID, OldGrade, NewGrade, ChangeDate)
                                  Select i.EnrollmentID,d.Grade, i.grade, getDate()
                                  From inserted i join deleted d
                                  on i.EnrollmentID = d.EnrollmentID
                                  where d.Grade is not null and i.Grade is not null
       
      
End

Update Enrollment
set grade = 'D'
where EnrollmentID = 3






SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Enrollment;

--5. Create a scalar function that takes a Course ID as a parameter and returns the maximum number of seats (MaxEnrollment)
--available for that course. If the course is not found, return -1. 


Alter Function MaxEnroll (@CourseID char(5))
returns int
as
begin
    Declare @MaxEnrollment int

    Begin
    If not exists(select @CourseID from Course where CourseID = @CourseID)
       Return -1
    End
Begin
    Select @MaxEnrollment = MaxEnrollment
    From Course
    Where CourseID = @CourseID

    return @MaxEnrollment
 End
End

--test'
    
Select dbo.MaxEnroll ('HI101') as 'Maximum of seats available'





SELECT * FROM Course;
SELECT * FROM Student;
SELECT * FROM Enrollment;

----6. Create a trigger that satisfies the following conditions:
--a. When a student attempts to register for a course (add a course in the Enrollment table), the trigger should:
--i.Check out the prerequisite for that course. 
--ii. If the course has a prerequisite, the trigger will verify whether the student has successfully completed the prerequisite course.
--iii. If the student has not completed the prerequisite course (i.e., no enrollment or a failed grade), 
    --the trigger will prevent the enrollment and report the name of the prerequisite course that must completed first

Alter Trigger registration
On Enrollment
Instead of Insert
As
Begin

    Declare @StudentID int , @CourseID char(5), @PreReqName varchar(20), @PReq varchar(20)

    select @StudentID = StudentID from inserted
    Select @CourseID = courseID from inserted
    select @PReq = PreReq from Course where CourseID = @CourseID


    If @PReq is null
Begin
        Insert into Enrollment(StudentID, CourseID, EnrollmentDate, EnrollmentStatus, Grade) select StudentID, CourseID, EnrollmentDate, EnrollmentStatus, Grade from inserted
End
   
        If exists(select 1 from Enrollment where @CourseID = CourseID
                                               and @StudentID = StudentID
                                                and Grade not like 'F')
    Begin
           Insert into Enrollment(StudentID, CourseID, EnrollmentDate, EnrollmentStatus, Grade) select StudentID, CourseID, EnrollmentDate, EnrollmentStatus, Grade from inserted
    End
      Else
        Begin
            Select @PreReqName
            From Course
            Where @PreReqName = CourseName

            Print 'Must Complete ' + @PreReqName
    End
End

Select* from Enrollment

   Insert into Enrollment(StudentID, CourseID, EnrollmentDate, EnrollmentStatus, Grade) values (101, 'MA150',getdate(), 'Active', null)