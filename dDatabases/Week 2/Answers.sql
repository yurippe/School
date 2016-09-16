#################################################################################################################
#Which students have received a grade that is 10 or lower?
SELECT DISTINCT name FROM People INNER JOIN Takes ON People.pid = Takes.pid WHERE Takes.grade <= 10;
#################################################################################################################
#Which teachers have taught the same course?
#NB NOT FULL SOLUTION (Duplicate tuples, like (A, B) and (B, A) both gets listed)
SELECT p1.name as Teacher1, p2.name as Teacher2 FROM (SELECT People.pid, cid, People.name FROM Teaches INNER JOIN People ON Teaches.pid = People.pid) as p1 INNER JOIN (SELECT People.pid, cid, People.name FROM Teaches INNER JOIN People ON Teaches.pid = People.pid) as p2 WHERE p1.pid < p2.pid AND p1.cid = p2.cid;
#################################################################################################################
#List each student together with the average grade for the student across all courses the student has taken
#NB NOT FULL SOLUTION (counts duplicates of same course if the person has previously failed the course)
SELECT name, AVG(grade) as average FROM People, Takes WHERE People.pid = Takes.pid GROUP BY People.pid;
#################################################################################################################
#How many distinct average grades are there among students
SELECT COUNT(DISTINCT average) as DistinctAverages FROM (SELECT AVG(grade) as average FROM People, Takes WHERE People.pid = Takes.pid GROUP BY People.pid) as averagegrades;
#################################################################################################################