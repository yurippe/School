DROP TABLE IF EXISTS Handin;            #Order matters because of foreign key constraints,
DROP TABLE IF EXISTS Grades;            #Handin, Grades, Enrolled, Takes, Teaches, Exams
DROP TABLE IF EXISTS Enrolled;          #and Projects dont have Primary keys themselves,
DROP TABLE IF EXISTS Takes;             #but references foreign keys, and must therefore
DROP TABLE IF EXISTS Teaches;           #be deleted first
DROP TABLE IF EXISTS Exams; 
DROP TABLE IF EXISTS Projects;          #deletion instead of "INSERT IF NOT EXIST" due to
DROP TABLE IF EXISTS Groupmembers;      #testing purposes

DROP TABLE IF EXISTS Groups;            #Groups references both Courses and People, 
                                        #so it must be deleted before those 2 tables
                                        
DROP TABLE IF EXISTS People;            #Finally we drop these
DROP TABLE IF EXISTS Courses;

CREATE TABLE `People`(
    `pid` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(128)
);

CREATE TABLE `Courses`(
    `cid` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(128)
);

CREATE TABLE `Groups`(
    `gid` INT PRIMARY KEY AUTO_INCREMENT,
    `gname` VARCHAR(16) UNIQUE,
    `cid` INT NOT NULL,
    `supid` INT NOT NULL,
    FOREIGN KEY (`cid`) REFERENCES Courses(`cid`),
    FOREIGN KEY (`supid`) REFERENCES People(`pid`)
);

CREATE TABLE `Groupmembers`(
    `gid` INT,
    `pid` INT,
    FOREIGN KEY (`gid`) REFERENCES Groups(`gid`),
    FOREIGN KEY (`pid`) REFERENCES People(`pid`)
);

CREATE TABLE `Projects`(
    `cid` INT NOT NULL,
    `proid` INT PRIMARY KEY AUTO_INCREMENT,
    `proname` VARCHAR(124),
    `mandatory` BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (`cid`) REFERENCES Courses(`cid`)
);

CREATE TABLE `Exams`(
    `cid` INT,
    `pointsreq` INT,
    `date` DATE,
    FOREIGN KEY (`cid`) REFERENCES Courses(`cid`)
);

CREATE TABLE `Teaches`(
    `pid` INT,
    `cid` INT,
    FOREIGN KEY (`pid`) REFERENCES People(`pid`),
    FOREIGN KEY (`cid`) REFERENCES Courses(`cid`)
);

CREATE TABLE `Takes`(
    `pid` INT,
    `cid` INT,
    `date` DATE,
    `grade` INT,
    FOREIGN KEY (`pid`) REFERENCES People(`pid`),
    FOREIGN KEY (`cid`) REFERENCES Courses(`cid`)
);

CREATE TABLE `Handin`(
    `gid` INT,
    `proid` INT,
    `points` INT,
    `file` VARCHAR(128),        #Should be a blob or a link in real application
    FOREIGN KEY (`proid`) REFERENCES Projects(`proid`),
    FOREIGN KEY (`gid`) REFERENCES Groups(`gid`)
);
