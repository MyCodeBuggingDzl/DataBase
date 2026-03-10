--CREATE DATABASE Movie_Ratings_New; 

--USE Movie_Ratings_New; 

/* Delete the tables if they already exist */ 
drop table if exists Rating; 
drop table if exists Movie; 
drop table if exists Reviewer; 
drop table if exists Director; 

CREATE TABLE Director (
    dID INT PRIMARY KEY, 
    name VARCHAR(40),
    birthYear INT,       
    country VARCHAR(40)  
); 

CREATE TABLE Movie (
    mID INT PRIMARY KEY, 
    title VARCHAR(40), 
    year INT, 
    dID INT,
    FOREIGN KEY (dID) REFERENCES Director
); 

CREATE TABLE Reviewer (
    rID INT PRIMARY KEY, 
    name VARCHAR(40)
); 

CREATE TABLE Rating (
    rID INT FOREIGN KEY REFERENCES Reviewer(rID), 
    mID INT FOREIGN KEY REFERENCES Movie(mID), 
    stars INT, 
    ratingDate DATE,
    PRIMARY KEY (rID, mID)
); 

/* Populate the tables with our data */ 

INSERT INTO Director VALUES (1, 'Victor Fleming', 1883, 'USA');
INSERT INTO Director VALUES (2, 'George Lucas', 1944, 'USA');
INSERT INTO Director VALUES (3, 'Robert Wise', 1914, 'USA');
INSERT INTO Director VALUES (4, 'Steven Spielberg', 1946, 'USA');
INSERT INTO Director VALUES (5, 'James Cameron', 1954, 'Canada');

INSERT INTO Movie VALUES (101, 'Gone with the Wind', 1939, 1); 
INSERT INTO Movie VALUES (102, 'Star Wars', 1977, 2); 
INSERT INTO Movie VALUES (103, 'The Sound of Music', 1965, 3); 
INSERT INTO Movie VALUES (104, 'E.T.', 1982, 4); 
INSERT INTO Movie VALUES (105, 'Titanic', 1997, 5); 
INSERT INTO Movie VALUES (106, 'Snow White', 1937, NULL); 
INSERT INTO Movie VALUES (107, 'Avatar', 2009, 5); 
INSERT INTO Movie VALUES (108, 'Raiders of the Lost Ark', 1981, 4); 
INSERT INTO Movie VALUES (109, 'Raiders of the Lost Ark -2', 1987, NULL); 

INSERT INTO Reviewer VALUES (201, 'Sarah Martinez'); 
INSERT INTO Reviewer VALUES (202, 'Daniel Lewis'); 
INSERT INTO Reviewer VALUES (203, 'Brittany Harris'); 
INSERT INTO Reviewer VALUES (204, 'Mike Anderson'); 
INSERT INTO Reviewer VALUES (205, 'Chris Jackson'); 
INSERT INTO Reviewer VALUES (206, 'Elizabeth Thomas'); 
INSERT INTO Reviewer VALUES (207, 'James Cameron'); 
INSERT INTO Reviewer VALUES (208, 'Ashley White'); 

INSERT INTO Rating VALUES(201, 101, 2, '2021-01-22'); 
INSERT INTO Rating VALUES(201, 106, 4, '2021-01-27'); 
INSERT INTO Rating VALUES(202, 106, 4, NULL); 
INSERT INTO Rating VALUES(203, 103, 2, '2021-01-20'); 
INSERT INTO Rating VALUES(203, 105, 4, '2022-01-12'); 
INSERT INTO Rating VALUES(203, 106, 2, '2023-01-30'); 
INSERT INTO Rating VALUES(204, 101, 3, '2023-01-09'); 
INSERT INTO Rating VALUES(205, 103, 3, '2024-01-27'); 
INSERT INTO Rating VALUES(205, 104, 2, '2024-01-22'); 
INSERT INTO Rating VALUES(205, 108, 4, NULL); 
INSERT INTO Rating VALUES(206, 107, 3, '2024-01-15'); 
INSERT INTO Rating VALUES(206, 106, 5, '2024-01-19'); 
INSERT INTO Rating VALUES(207, 107, 5, '2023-01-20'); 
INSERT INTO Rating VALUES(208, 105, 3, '2024-01-02'); 

SELECT * FROM Movie;
SELECT * FROM Reviewer;
SELECT * FROM Director;
SELECT * FROM Rating;


--1.

SELECT M.TITLE, D.NAME
FROM MOVIE M JOIN DIRECTOR D
ON D.DID =M.DID

--2.

SELECT M.TITLE, R.STARS
FROM MOVIE M JOIN RATING R
ON M.MID = R.MID
JOIN REVIEWER S
ON R.RID = S.RID
WHERE NAME = 'Sarah Martinez'

--3.

SELECT M.TITLE, R.STARS, COUNT(STARS) AS 'NUM OF STARS'
FROM MOVIE M JOIN RATING R
ON M.MID = R.MID
GROUP BY M.TITLE, R.STARS

--4.

SELECT R.NAME, S.STARS
FROM REVIEWER R JOIN RATING S
ON R.rID = S.rID

--5.

SELECT M.TITLE, D.NAME AS 'DIRECTOR', R.NAME AS 'REVIEWER'
FROM MOVIE M JOIN DIRECTOR D 
ON M.dID = D.dID
JOIN RATING L
ON M.mID = L.mID
JOIN Reviewer R
ON L.RID = R.RID

--6.

SELECT COUNT(M.MID) 'NUM OF MOVIE DIRECTED', MAX(M.MID) AS 'TOTAL MOVIE D.', D.NAME AS 'DIRECTOR'
FROM DIRECTOR D JOIN MOVIE M
ON D.dID = M.dID
GROUP BY D.NAME

--7.

SELECT COUNT(R.RID) AS 'NUM OF RATE', S.NAME
FROM RATING R JOIN REVIEWER S
ON R.rID = S.rID
GROUP BY S.NAME
HAVING COUNT(R.RID) >= 3

--8.

SELECT M.TITLE, R.STARS
FROM MOVIE M JOIN RATING R
ON M.mID = R.mID
WHERE R.STARS IS NULL

--9.

SELECT R.*, M.TITLE, S.*
FROM RATING S JOIN MOVIE M
ON S.mID = M.mID
JOIN REVIEWER R
ON S.rID = R.rID
WHERE m.mID = 105