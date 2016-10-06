/*
CREATE VIEW PeopleAccountRecords AS
SELECT P.pid, P.pname, P.pgender, P.pheight, AR.rid, AR.aid, AR.rdate, AR.rtype, AR.ramount, AR.rbalance, A.aover, A.abalance
FROM people P, Accounts  A, AccountRecords AR
WHERE P.pid = A.pid
AND A.aid = AR.aid
ORDER BY AR.aid, AR.rid;

CREATE OR REPLACE FUNCTION NEWACCOUNT( IN pid INT)
returns void
AS
$$	
INSERT INTO Accounts ( pid, adate, abalance, aover)
VALUES(pid, current_date, 0, 0);
$$
LANGUAGE sql;

SELECT NEWACCOUNT(200);
*/

CREATE TRIGGER NoTransMidgets
AFTER INSERT OR UPDATE OF pid ON people
  FOR EACH ROW
    IF (SELECT  P.pheight FROM people P) <= 0 THEN
      RAISE EXCEPTION 'HEIGHT CANNOT BE NEGATIVE!'
      USING ERRCODE = '45000'
      SELECT 1;
    ELSE
      SELECT 2;
    END IF;









