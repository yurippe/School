/*
    PEOPLE    PEOPLE    PEOPLE    PEOPLE    PEOPLE
    
    Here we insert people into the PEOPLE table. Each is given an
    incrementing ID as stated by the DDL.
*/

INSERT INTO People (name) VALUES ('Kristian Gausel');
INSERT INTO People (name) VALUES ('Adam B. Hansen');
INSERT INTO People (name) VALUES ('Francisco Gluver');
INSERT INTO People (name) VALUES ('Steffan Sølvsten');
/* Regular people */
INSERT INTO People (name) VALUES ('John Doe');
INSERT INTO People (name) VALUES ('Lily Doe');
INSERT INTO People (name) VALUES ('Mary Sue');
INSERT INTO People (name) VALUES ('Gary Sue');

/* TEACHERS */
INSERT INTO People (name) VALUES ('Niels Olof Bouvin');
INSERT INTO People (name) VALUES ('Ira Assent');

/*
    COURSES    COURSES    COURSES   COURSES COURSES
    
    Where the individual courses are inserted into the table.
*/
INSERT INTO Courses (name) VALUES ('Concurrency');
INSERT INTO Courses (name) VALUES ('Database');
INSERT INTO Courses (name) VALUES ('Pervasive Computing');

/*
    GROUPS  GROUPS  GROUPS  GROUPS  GROUPS
    
    This where the individual groups are made and where the members of each group is added.
    We get group id by using @@IDENTITY and setting @currentgroup to that number.
*/
/* CONCURRENCY */

INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'CG1' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Concurrency' AND p.name = 'Gary Sue');  #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');

INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'CG2' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Concurrency' AND p.name = 'Gary Sue');
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'John Doe');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Lily Doe');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Mary Sue');


/* DATABASE */
INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'DG1' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Database' AND p.name = 'Gary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');


INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'DG2' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Database' AND p.name = 'Mary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');


/* PERVASIVE COMPUTING */
INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'PC1' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Pervasive Computing' AND p.name = 'Mary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');

INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'PC2' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Pervasive Computing' AND p.name = 'Mary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');

INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'PC3' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Pervasive Computing' AND p.name = 'Mary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');

INSERT INTO Groups (cid, gname, `supid`) (SELECT c.cid, 'PC4' as gname, p.pid as `supid` FROM Courses c, People p WHERE c.name = 'Pervasive Computing' AND p.name = 'Mary Sue');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');


/*
    TEACHES     TEACHES     TEACHES     TEACHES     TEACHES
    
    Teachers and Supervisors (TA's) are inserted into their respective table and given their respective values for each attribute.
*/
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Niels Olof Bouvin' AND c.name = 'Concurrency');
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Niels Olof Bouvin' AND c.name = 'Pervasive Computing');
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Ira Assent' AND c.name = 'Database');
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Ira Assent' AND c.name = 'Concurrency');

/*
    PROJECTS    HANDINS    PROJECTS    HANDINS    PROJECTS
    
    Note, that 'file' is the handed in .pdf file itself, so while we here write a string, we intend it to be an actual file or a link to it.
*/

INSERT INTO Projects (cid, proname) (SELECT cid, 'Threading-Ahoy!' as proname FROM Courses c WHERE c.name = 'Concurrency'); #Create a new project, where we will along with this, create handins connected to the project.
SET @projectid = @@IDENTITY;
INSERT INTO Handin (gid, proid, points, `file`) (SELECT gid, @projectid as proid, 0 as points, 'main.pdf' as `file` FROM Groups g WHERE g.gname  = 'CG1');
INSERT INTO Handin (gid, proid, points, `file`) (SELECT gid, @projectid as proid, 23 as points, 'final_handin.pdf' as `file` FROM Groups g WHERE g.gname = 'CG2');
INSERT INTO Handin (gid, proid, points, `file`) (SELECT gid, @projectid as proid, 24 as points, 'main2.pdf' as `file` FROM Groups g WHERE g.gname = 'CG1');

INSERT INTO Projects (cid, proname) (SELECT cid, 'Concurrency for Dummies' as proname FROM Courses c WHERE c.name = 'Concurrency');
SET @projectid = @@IDENTITY;
INSERT INTO Handin (gid, proid, points, `file`) (SELECT gid, @projectid as proid, 25 as points, 'dummmies_final.pdf' as `file` FROM Groups g WHERE g.gname = 'CG1');
INSERT INTO Handin (gid, proid, points, `file`) (SELECT gid, @projectid as proid, 24 as points, 'abstractions_of_threading.pdf' as `file` FROM Groups g WHERE g.gname = 'CG2');


/*
    EXAMS    EXAMS    EXAMS    EXAMS    EXAMS
    
    Here is where we create the specific exams for the three different courses.
    We set a specified number of tries, points requirement and the date.
    We retrieve the individual CID by finding a course that corresponds to a specific name.
*/
INSERT INTO Exams (cid,  pointsreq, `date`) (SELECT cid, 70 as pointsreq, '2017-01-07' as `date` FROM Courses c WHERE c.name = 'Concurrency');
INSERT INTO Exams (cid, pointsreq, `date`) (SELECT cid, 24 as pointsreq, '2016-10-21' as `date` FROM Courses c WHERE c.name = 'Database');
INSERT INTO Exams (cid, pointsreq, `date`) (SELECT cid, 1  as pointsreq, '2016-10-18' as `date`  FROM Courses c WHERE c.name = 'Pervasive Computing');
INSERT INTO Exams (cid, pointsreq, `date`) (SELECT cid, 1  as pointsreq, '2017-01-21' as `date` FROM Courses c WHERE c.name = 'Pervasive Computing');


/*
    TAKES    TAKES    TAKES    TAKES    TAKES
    
    Here is where we insert the different exam tries for a given student.
    Their ID, the course ID and the unique exam attempt along with a given grade is added to the table.
*/
#Inserting a person at a time
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2016-10-18' as `date`, 0 as grade FROM People p, Courses c WHERE p.name = 'Steffan Sølvsten' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2016-10-18' as `date`, 10 as grade FROM People p, Courses c WHERE p.name = 'Adam B. Hansen' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2016-10-18' as `date`, 7 as grade FROM People p, Courses c WHERE p.name = 'Francisco Gluver' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2016-10-18' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Kristian Gausel' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-21' as `date`, 4 as grade FROM People p, Courses c WHERE p.name = 'Steffan Sølvsten' AND c.name = 'Pervasive Computing');

INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 7 as grade FROM People p, Courses c WHERE p.name = 'Steffan Sølvsten' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 7 as grade FROM People p, Courses c WHERE p.name = 'Adam B. Hansen' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 7 as grade FROM People p, Courses c WHERE p.name = 'Francisco Gluver' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Kristian Gausel' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'John Doe' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 4 as grade FROM People p, Courses c WHERE p.name = 'Lily Doe' AND c.name = 'Concurrency');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 02 as grade FROM People p, Courses c WHERE p.name = 'Mary Sue' AND c.name = 'Concurrency');

INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Steffan Sølvsten' AND c.name = 'Database');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Adam B. Hansen' AND c.name = 'Database');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Francisco Gluver' AND c.name = 'Database');
INSERT INTO Takes (pid, cid, `date`, grade) (SELECT pid, cid, '2017-01-07' as `date`, 12 as grade FROM People p, Courses c WHERE p.name = 'Kristian Gausel' AND c.name = 'Database');
















