SELECT 'id --> did' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT id, COUNT(DISTINCT did)
FROM Persons
GROUP BY id
HAVING COUNT(DISTINCT did) > 1
) X;
SELECT 'id --> ssn' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT id, COUNT(DISTINCT ssn)
FROM Persons
GROUP BY id
HAVING COUNT(DISTINCT ssn) > 1
) X;
SELECT 'id --> z' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT id, COUNT(DISTINCT z)
FROM Persons
GROUP BY id
HAVING COUNT(DISTINCT z) > 1
) X;
SELECT 'z --> t' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT z, COUNT(DISTINCT t)
FROM Persons
GROUP BY z
HAVING COUNT(DISTINCT t) > 1
) X;
SELECT 'did --> dn' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT did, COUNT(DISTINCT dn)
FROM Persons
GROUP BY did
HAVING COUNT(DISTINCT dn) > 1
) X;
SELECT 'ssn --> pn' AS FD, CASE WHEN COUNT(*) = 0 THEN 'HOLDS' ELSE 'DOES NOT HOLD' END AS VALIDITY
FROM (
SELECT ssn, COUNT(DISTINCT pn)
FROM Persons
GROUP BY ssn
HAVING COUNT(DISTINCT pn) > 1
) X;
