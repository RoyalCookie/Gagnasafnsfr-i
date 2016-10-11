
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

SELECT 6 as Query;
CREATE OR REPLACE FUNCTION UpdatePeople() RETURNS TRIGGER AS $UpdatePeople$
BEGIN
	IF (NEW.pGender  <> 'M' AND NEW.pGender  <> 'F') THEN
	RAISE EXCEPTION 'Gender needs to be M for male or F for female' USING ERRCODE = '45000';
	else if (NEW.pHeight <= 0) THEN
	RAISE EXCEPTION 'Hight cant be less or equal to 0' USING ERRCODE = '45001';
	END if ;
	END if;
	INSERT INTO Accounts(PID, aOver)
	Values(NEW.PID, 10000);
	RETURN NEW;
 END;
 $UpdatePeople$ LANGUAGE plpgsql;

CREATE TRIGGER NewPerson AFTER INSERT ON People
FOR EACH ROW
EXECUTE PROCEDURE UpdatePeople();


SELECT 9 as Query;
CREATE OR REPLACE FUNCTION Transfer(IN iToAID INT, IN iFromAID INT, IN iAmount INT) 
RETURNS VOID AS $$
BEGIN
INSERT INTO AccountRecords(rBalance,rDate)
SELECT *
FROM Accounts
WHERE AID = iToAID;
Values(rBalance + iAmount, current_date);

INSERT INTO AccountRecords(rBalance,rDate)
SELECT *
FROM Accounts
WHERE RID = iFromAID;
Values(rBalance - iAmount, current_date);
END;
$$ LANGUAGE plpgsql


SELECT 10 as Query;

CREATE OR REPLACE FUNCTION LoanMoney(IN iAID INT, IN iAmount INT, IN iDueDate DATE, 
OUT billID INT, OUT billPID INT) AS $$
DECLARE Tempo INT;
BEGIN
IF NOT EXISTS (SELECT AID FROM Accounts WHERE AID = iAID) THEN
RAISE EXCEPTION 'THE ID DOES NOT EXSIT' 
USING ERRCODE = '45000';
END IF; 
UPDATE Accounts SET aOver = aOver + iAmount, aDate = current_date WHERE AID = iAID;
billPID := (SELECT PID FROM Accounts WHERE AID = iAID);
	
billID := 1 + (SELECT COALESCE(MAX(BID), 1) FROM Bills);
	  INSERT INTO Bills(BID, PID, bDueDate, bAmount, bIsPaid)
	  VALUES(billID, BillPID, lDueDate, iAmount, 0::bit(1) ); 
Tempo := ((SELECT rBalance FROM AccountRecords WHERE 
					       RID = (SELECT MAX(RID) FROM AccountRecords WHERE AID = iAID)) + iAmount);
	 
	INSERT INTO AccountRecords(AID, rDate, rType, rAmount, rBalance)
	VALUES(iAID, current_date, 'O', iAmount, Tempo); 
END;
$$ LANGUAGE plpgsql;

