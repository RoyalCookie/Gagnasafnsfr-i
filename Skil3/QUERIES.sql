

CREATE TEMPORARY VIEW AllAccountRecords AS
SELECT a.*, ar.rid, ar.rdate, ar.rtype, ar.ramount, ar.rbalance
FROM accounts a
LEFT JOIN accountrecords AS ar ON ar.aid = a.aid;



CREATE TEMPORARY VIEW DebtorStatus AS
SELECT DISTINCT p.pid, p.pname, (SELECT SUM(abalance) FROM accounts WHERE pid = p.pid)   
FROM people p
INNER JOIN accounts AS a ON p.pid = a.pid
WHERE a.abalance < 0
ORDER BY p.pid;


CREATE TEMPORARY VIEW FinancialStatus AS
SELECT DISTINCT p.pid, p.pname, 
                (SELECT SUM(abalance) FROM accounts WHERE  pid = p.pid) AS TotalSavings,
                (SELECT SUM(bamount) FROM bills WHERE pid = p.pid AND bispaid = FALSE) AS TotalBills 
FROM people p
INNER JOIN accounts  AS a ON p.pid = a.pid
ORDER BY p.pid;

SELECT * FROM FinancialStatus;



CREATE OR REPLACE FUNCTION  Billchecker () RETURNS TRIGGER AS $Billchecker$
BEGIN
IF(new.bamount < 0) THEN RAISE EXCEPTION 
		    'The Bill is less then zero '
		    USING ERRCODE = '45001';
ELSE IF (new.bduedate <= CURRENT_DATE) THEN RAISE EXCEPTION 
				       'Date is past current date'
					USING ERRCODE = '45002';
ELSE IF(TG_OP = 'DELETE')THEN RAISE EXCEPTION 
		     'NOT ALLOWED TO DELETE'
		      USING ERRCODE = '45003';
ELSE IF(TG_OP = 'UPDATE')THEN 
			IF
			(new.bid <> old.bid OR new.bduedate <> old.bduedate OR new.bamount <> old.bamount)	
			THEN
			RAISE EXCEPTION 
			'Not allowed to Update accept bispaid'
			USING ERRCODE = '45004';
			END if;
		      
END if;
END if;
END if;
END if;
return new;
END;
$Billchecker$ LANGUAGE plpgsql;


CREATE TRIGGER CheckBills BEFORE INSERT OR UPDATE OR DELETE ON Bills
FOR EACH ROW
EXECUTE PROCEDURE Billchecker();













