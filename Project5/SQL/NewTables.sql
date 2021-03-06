DROP TABLE IF EXISTS Persons;
DROP TABLE IF EXISTS Boats;
DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS PostNumbers;
DROP TABLE IF EXISTS Social;

CREATE TABLE Social (
  SSN CHAR(10),
  PN  CHARACTER VARYING,
  PRIMARY KEY (SSN)
);

CREATE TABLE Departments (
  DID INTEGER,
  DN CHARACTER VARYING,
  PRIMARY KEY (DID)
);

CREATE TABLE PostNumbers (
  Z INTEGER,
  T CHARACTER VARYING,
  PRIMARY KEY (Z)
);

CREATE TABLE Persons (
  ID INTEGER,                  -- ID AI?
  DID INTEGER,                 --
  SSN CHAR(10),                --
  Z INTEGER,                   --
  PRIMARY KEY (ID),
  FOREIGN KEY (Z)   REFERENCES PostNumbers  (Z),
  FOREIGN KEY (DID) REFERENCES Departments  (DID),
  FOREIGN KEY (SSN) REFERENCES Social       (SSN)
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
