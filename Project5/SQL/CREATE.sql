DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS Boats;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Courses;

CREATE TABLE Persons (
  ID INTEGER,                  -- ID AI?
  PN CHARACTER VARYING,        -- Personal Name
  DID INTEGER,                 --
  DN CHARACTER VARYING,        --
  SSN CHAR(10),                -- Social Security
  Z INTEGER,                   --
  T CHARACTER VARYING,         --
	PRIMARY KEY (ID)
);

CREATE TABLE Boats (
	BL CHAR(2),
	BNo INTEGER,
	Z INTEGER,
	T CHARACTER VARYING, 
	BN CHARACTER VARYING,
	SSN CHAR(10),
	PRIMARY KEY (BL, BNo)
);

CREATE TABLE Projects (
	ID INTEGER,
	PID INTEGER,
	DID INTEGER,
	DN CHARACTER VARYING,
	PN CHARACTER VARYING,
	DM INTEGER,
	PRIMARY KEY (ID)
);

CREATE TABLE Courses (
	CID INTEGER,
	TID INTEGER,
	BID INTEGER,
	SID INTEGER,
	TN CHARACTER VARYING,
	SN CHARACTER VARYING,
	SY INTEGER,
	PRIMARY KEY (CID, TID, BID, SID)
);
