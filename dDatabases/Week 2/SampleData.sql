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
INSERT INTO Groups (cid, gname) (SELECT cid, 'CG1' as gname FROM Courses WHERE name = 'Concurrency');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');


INSERT INTO Groups (cid, gname) (SELECT cid, 'CG2' as gname FROM Courses WHERE name = 'Concurrency');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'John Doe');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Lily Doe');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Mary Sue');


/* DATABASE */
INSERT INTO Groups (cid, gname) (SELECT cid, 'DG1' as gname FROM Courses WHERE name = 'Database');         #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');


INSERT INTO Groups (cid, gname) (SELECT cid, 'DG2' as gname  FROM Courses WHERE name = 'Database');         #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');


/* PERVASIVE COMPUTING */
INSERT INTO Groups (cid, gname) (SELECT cid, 'PC1' as gname FROM Courses WHERE name = 'Pervasive Computing');      #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Kristian Gausel');

INSERT INTO Groups (cid, gname) (SELECT cid, 'PC2' as gname FROM Courses WHERE name = 'Pervasive Computing');        #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Adam B. Hansen');

INSERT INTO Groups (cid, gname) (SELECT cid, 'PC3' as gname FROM Courses WHERE name = 'Pervasive Computing');        #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Francisco Gluver');

INSERT INTO Groups (cid, gname) (SELECT cid, 'PC4' as gname FROM Courses WHERE name = 'Pervasive Computing');        #Make group
SET @currentgroup = @@IDENTITY;           #Store Primary Key value from recently inserted group
#Insert some people into the newly created group:
INSERT INTO Groupmembers(gid, pid) (SELECT @currentgroup as gid, pid FROM People WHERE name = 'Steffan Sølvsten');


/*
    TEACHES     SUPERVISORS     TEACHES     SUPERVISORS     TEACHES
    
    Teachers and Supervisors (TA's) are inserted into their respective table and given their respective values for each attribute.
*/
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Niels Olof Bouvin' AND c.name = 'Concurrency');
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Niels Olof Bouvin' AND c.name = 'Pervasive Computing');
INSERT INTO Teaches (pid, cid) (SELECT pid, cid FROM People p, Courses c WHERE p.name = 'Ira Assent' AND c.name = 'Database');

#Assign a TA to all groups in Concurrency
INSERT INTO Grades (pid, cid, gid) (SELECT pid, cid, gid FROM People p, Courses c NATURAL JOIN Groups g WHERE p.name = 'Gary Sue' AND c.name = 'Concurrency');
#TODO: Rename groups for DA1 and DA4, such that two groups can be chosen on prefix and assigned
INSERT INTO Grades (pid, cid, gid) (SELECT pid, cid, gid FROM People p, Courses c NATURAL JOIN Groups g WHERE p.name = 'Mary Sue' AND c.name = 'Pervasive Computing');
#Assign a TA to a specific group
INSERT INTO Grades (pid, cid, gid) (SELECT pid, cid, gid FROM People p, Groups g WHERE p.name = 'Gary Sue' AND g.gname = 'DG1');
INSERT INTO Grades (pid, cid, gid) (SELECT pid, cid, gid FROM People p, Groups g WHERE p.name = 'Mary Sue' AND g.gname = 'DG2');

/*
    PROJECTS    HANDINS    PROJECTS    HANDINS    PROJECTS
    
    Note, that 'file' is the handed in .pdf file itself, so while we here write a string, we intend it to be an actual file or a link to it.
*/

INSERT INTO Projects (cid, proname) (SELECT cid, 'Threading-Ahoy!' as proname FROM Courses c WHERE c.name = 'Concurrency'); #Create a new project, where we will along with this, create handins connected to the project.
SET @projectid = @@IDENTITY;
INSERT INTO Handin (gid, pronumber, points, `file`) (SELECT gid, @projectid as pronumber, 0 as points, 'main.pdf' as `file` FROM Groups g WHERE g.gname  = 'CG1');
INSERT INTO Handin (gid, pronumber, points, `file`) (SELECT gid, @projectid as pronumber, 23 as points, 'final_handin.pdf' as `file` FROM Groups g WHERE g.gname = 'CG2');
INSERT INTO Handin (gid, pronumber, points, `file`) (SELECT gid, @projectid as pronumber, 24 as points, 'main2.pdf' as `file` FROM Groups g WHERE g.gname = 'CG1');

INSERT INTO Projects (cid, proname) (SELECT cid, 'Concurrency for Dummies' as proname FROM Courses c WHERE c.name = 'Concurrency');
SET @projectid = @@IDENTITY;
INSERT INTO Handin (gid, pronumber, points, `file`) (SELECT gid, @projectid as pronumber, 25 as points, 'dummmies_final.pdf' as `file` FROM Groups g WHERE g.gname = 'CG1');
INSERT INTO Handin (gid, pronumber, points, `file`) (SELECT gid, @projectid as pronumber, 24 as points, 'abstractions_of_threading.pdf' as `file` FROM Groups g WHERE g.gname = 'CG2');


/*
    EXAMS    EXAMS    EXAMS    EXAMS    EXAMS
    
    Here is where we create the specific exams for the three different courses.
    We set a specified number of tries, points requirement and the date.
    We retrieve the individual CID by finding a course that corresponds to a specific name.
*/
INSERT INTO Exams (cid, `number`, pointsreq, `date`) (SELECT cid, 1 as `number`, 70 as pointsreq, '2017-01-07' as `date` FROM Courses c WHERE c.name = 'Concurrency');
INSERT INTO Exams (cid, `number`, pointsreq, `date`) (SELECT cid, 1 as `number`, 24 as pointsreq, '2016-10-21' as `date` FROM Courses c WHERE c.name = 'Database');
INSERT INTO Exams (cid, `number`, pointsreq, `date`) (SELECT cid, 1 as `number`, 1  as pointsreq, '2016-10-18' as `date`  FROM Courses c WHERE c.name = 'Pervasive Computing');
INSERT INTO Exams (cid, `number`, pointsreq, `date`) (SELECT cid, 2 as `number`, 1  as pointsreq, '2017-01-21' as `date` FROM Courses c WHERE c.name = 'Pervasive Computing');


/*
    TAKES    TAKES    TAKES    TAKES    TAKES
    
    Here is where we insert the different exam tries for a given student.
    Their ID, the course ID and the unique exam attempt along with a given grade is added to the table.
*/
#Inserting a person at a time
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, 0 as grade FROM People p, Courses c WHERE pid = 'Steffan Sølvsten' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, 10 as grade FROM People p, Courses c WHERE pid = 'Adam B. Hansen' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, 7 as grade FROM People p, Courses c WHERE pid = 'Francisco Gluver' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, 12 as grade FROM People p, Courses c WHERE pid = 'Kristian Gausel' AND c.name = 'Pervasive Computing');
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 2 as `number`, 4 as grade FROM People p, Courses c WHERE pid = 'Steffan Sølvsten' AND c.name = 'Pervasive Computing');

#Inserting everyone in the course - Something like this would be used in a proper implementation when registereing people
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, NULL as grade FROM
                                               (SELECT * FROM Groupmembers NATURAL JOIN                                                                        #Find all groupmembers in the eligible groups
                                                    (SELECT * FROM (SELECT cid, gid FROM Groups g JOIN Courses c WHERE g.cid = c.cid AND c.name = 'Database') #Find all groups to the course
                                                        NATURAL JOIN (SELECT cid, gid, SUM(points) FROM Groups NATURAL JOIN Handin GROUP BY cid, gid)          #Determine the sum of the points given
                                                        WHERE points > (SELECT pointsreq FROM Exams e, Courses c WHERE e.cid = c.cid AND c.name = 'Database' AND `number` = 1) #Points enough?
                                                        )));

#Insert everyone in the last course
INSERT INTO Takes (pid, cid, `number`, grade) (SELECT pid, cid, 1 as `number`, 12 as grade FROM Groupmembers g, Courses c WHERE g.cid = c.cid AND c.name = 'Concurrency');





