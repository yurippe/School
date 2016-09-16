#Which students have received a grade that is 10 or lower?
SELECT DISTINCT name FROM People INNER JOIN Takes ON People.pid = Takes.pid WHERE Takes.grade <= 10;

########################################

