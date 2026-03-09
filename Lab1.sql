--CREATE DATABASE Movie_Ratings; 

--USE Movie_Ratings; 

  

/* Delete the tables if they already exist */ 
drop table if exists Rating; 
drop table if exists Movie; 
drop table if exists Reviewer; 



  
  CREATE TABLE Movie (
    mID INT PRIMARY KEY, 
    title VARCHAR(40), 
    year INT, 
    director VARCHAR(35)
); 

CREATE TABLE Reviewer (
    rID INT PRIMARY KEY, 
    name VARCHAR(40)
); 

CREATE TABLE Rating (
    rID INT FOREIGN KEY REFERENCES Reviewer , 
    mID INT FOREIGN KEY REFERENCES Movie, 
    stars INT, 
    ratingDate DATE
	PRIMARY KEY (rID, mID)
); 

/* Populate the tables with our data */ 

INSERT INTO Movie VALUES (101, 'Gone with the Wind', 1939, 'Victor Fleming'); 
INSERT INTO Movie VALUES (102, 'Star Wars', 1977, 'George Lucas'); 
INSERT INTO Movie VALUES (103, 'The Sound of Music', 1965, 'Robert Wise'); 
INSERT INTO Movie VALUES (104, 'E.T.', 1982, 'Steven Spielberg'); 
INSERT INTO Movie VALUES (105, 'Titanic', 1997, 'James Cameron'); 
INSERT INTO Movie VALUES (106, 'Snow White', 1937, NULL); 
INSERT INTO Movie VALUES (107, 'Avatar', 2009, 'James Cameron'); 
INSERT INTO Movie VALUES (108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg'); 
INSERT INTO Movie VALUES (109, 'Raiders of the Lost Ark -2', 1987, NULL); 


INSERT INTO Reviewer VALUES (201, 'Sarah Martinez'); 
INSERT INTO Reviewer VALUES (202, 'Daniel Lewis'); 
INSERT INTO Reviewer VALUES (203, 'Brittany Harris'); 
INSERT INTO Reviewer VALUES (204, 'Mike Anderson'); 
INSERT INTO Reviewer VALUES (205, 'Chris Jackson'); 
INSERT INTO Reviewer VALUES (206, 'Elizabeth Thomas'); 
INSERT INTO Reviewer VALUES (207, 'James Cameron'); 
INSERT INTO Reviewer VALUES (208, 'Ashley White'); 


insert into Rating values(201, 101, 2, '2021-01-22'); 

insert into Rating values(201, 106, 4, '2021-01-27'); 

insert into Rating values(202, 106, 4, null); 

insert into Rating values(203, 103, 2, '2021-01-20'); 

insert into Rating values(203, 108, 4, '2022-01-12'); 

insert into Rating values(203, 106, 2, '2023-01-30'); 

insert into Rating values(204, 101, 3, '2023-01-09'); 

insert into Rating values(205, 103, 3, '2024-01-27'); 

insert into Rating values(205, 104, 2, '2024-01-22'); 

insert into Rating values(205, 108, 4, null); 

insert into Rating values(206, 107, 3, '2024-01-15'); 

insert into Rating values(206, 106, 5, '2024-01-19'); 

insert into Rating values(207, 107, 5, '2023-01-20'); 

insert into Rating values(208, 104, 3, '2024-01-02'); 

SELECT * FROM Movie;
SELECT * FROM Reviewer;

SELECT * FROM Rating;



--1.

SELECT RID, RATINGDATE, STARS
FROM RATING
WHERE STARS BETWEEN 2 AND 5

--2.

SELECT TITLE, YEAR
FROM MOVIE
order BY title desc

--3.

SELECT TITLE
FROM MOVIE
WHERE  YEAR >1980

--4.

SELECT NAME
FROM REVIEWER
WHERE NAME = '_a%' AND RID > 206 AND RID < 207

--5.

select* 
FROM MOVIE
WHERE DIRECTOR IS NULL

--6.
SELECT* FROM RATING
SELECT DISTINCT RID,  STARS
FROM RATING

--7. 

SELECT*
FROM MOVIE
WHERE DIRECTOR = 'Steven Spielberg' and year >= 1980