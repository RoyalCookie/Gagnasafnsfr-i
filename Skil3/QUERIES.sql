
SELECT 1 as Query;
CREATE TEMPORARY VIEW AllAccountRecords AS
SELECT a.*, ar.rid, ar.rdate, ar.rtype, ar.ramount, ar.rbalance
FROM accounts a
LEFT JOIN accountrecords AS ar ON ar.aid = a.aid;


SELECT 2 as Query;
CREATE TEMPORARY VIEW DebtorStatus AS
SELECT DISTINCT p.pid, p.pname, (SELECT SUM(abalance) FROM accounts WHERE pid = p.pid)   
FROM people p
INNER JOIN accounts AS a ON p.pid = a.pid
WHERE a.abalance < 0
ORDER BY p.pid;

SELECT 3 as Query;
CREATE TEMPORARY VIEW FinancialStatus AS
SELECT DISTINCT p.pid, p.pname, 
                (SELECT SUM(abalance) FROM accounts WHERE  pid = p.pid) AS TotalSavings,
                (SELECT SUM(bamount) FROM bills WHERE pid = p.pid AND bispaid = FALSE) AS TotalBills 
FROM people p
INNER JOIN accounts  AS a ON p.pid = a.pid
ORDER BY p.pid;

SELECT * FROM FinancialStatus;


SELECT 4 as Query;
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




SELECT 5 as Query;
CREATE OR REPLACE FUNCTION CheckStatus() RETURNS TRIGGER AS $CheckStatus$
BEGIN
	
IF (-NEW.rAmount > (SELECT aBalance + aOver 
			FROM Accounts A
			WHERE A.AID = NEW.AID))
THEN 
RAISE EXCEPTION 'TRANSACTION DENIED' 
USING ERRCODE = '45000';
 
ELSE IF(TG_OP = 'DELETE')THEN RAISE EXCEPTION 
		     'NOT ALLOWED TO DELETE'
		      USING ERRCODE = '45001';
		     
ELSE IF(TG_OP = 'UPDATE')THEN
			 IF(new.RID <> old.RID
			 OR new.AID <> old.AID 
			 OR new.rDate <> old.rDate 
			 OR new.rType <> old.rType)
			 THEN
		RAISE EXCEPTION 'You can only update aBalance'
		USING ERRCODE = '45002';
		END if;
		      
END if;
END IF;
END IF;
Update Accounts 
SET aBalance = aBalance + NEW.rAmount
WHERE AID = NEW.AID;
NEW.rBalance := (SELECT aBalance
		 FROM Accounts A
		 WHERE A.AID = NEW.AID);
RETURN NEW;
END;
 $CheckStatus$ LANGUAGE plpgsql;

CREATE TRIGGER CheckAccountRecords BEFORE INSERT OR UPDATE OR DELETE ON AccountRecords
FOR EACH ROW
EXECUTE PROCEDURE CheckStatus();
