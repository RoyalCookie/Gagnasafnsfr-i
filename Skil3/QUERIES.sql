

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















