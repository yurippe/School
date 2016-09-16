#################################################################################################################
#Which students have received a grade that is 10 or lower?
SELECT DISTINCT name FROM People INNER JOIN Takes ON People.pid = Takes.pid WHERE Takes.grade <= 10;
#################################################################################################################
#Which teachers have taught the same course?
SELECT p1.name as Teacher1, p2.name as Teacher2 FROM (SELECT People.pid, cid, People.name FROM Teaches INNER JOIN People ON Teaches.pid = People.pid) as p1 INNER JOIN (SELECT People.pid, cid, People.name FROM Teaches INNER JOIN People ON Teaches.pid = People.pid) as p2 WHERE p1.pid < p2.pid AND p1.cid = p2.cid;
#################################################################################################################
#List each student together with the average grade for the student across all courses the student has taken
SELECT name, AVG(grade) as average FROM 
	(SELECT name, People.pid, cid, max(`date`) as date FROM People, Takes WHERE People.pid = Takes.pid GROUP BY cid, pid) as p1 
    INNER JOIN 
	(SELECT People.pid, cid, `date`, grade FROM People, Takes WHERE People.pid = Takes.pid) as p2 
    ON 
    p1.pid = p2.pid AND p1.cid = p2.cid AND p1.date = p2.date GROUP BY p1.pid;
#################################################################################################################
#How many distinct average grades are there among students
SELECT COUNT(DISTINCT average) as DistinctAverages FROM (
SELECT name, AVG(grade) as average FROM 
	(SELECT name, People.pid, cid, max(`date`) as date FROM People, Takes WHERE People.pid = Takes.pid GROUP BY cid, pid) as p1 
    INNER JOIN 
	(SELECT People.pid, cid, `date`, grade FROM People, Takes WHERE People.pid = Takes.pid) as p2 
    ON 
    p1.pid = p2.pid AND p1.cid = p2.cid AND p1.date = p2.date GROUP BY p1.pid
) as averagegrades;

#################################################################################################################