DROP TABLE IF EXISTS Bills;
DROP TABLE IF EXISTS AccountRecords;
DROP TABLE IF EXISTS Accounts;
DROP TABLE IF EXISTS People;

CREATE TABLE People (
	PID SERIAL, 
	pName VARCHAR(50),
	pGender CHAR(1),
	pHeight FLOAT,
	PRIMARY KEY (PID)
);

CREATE TABLE Accounts (
    AID SERIAL, 
    PID INT,
    aDate DATE,
    aBalance INT,
    aOver INT,
    PRIMARY KEY (AID),
    FOREIGN KEY (PID) REFERENCES People(PID)
);

CREATE TABLE AccountRecords (
    RID SERIAL,
    AID INT,
    rDate DATE,
    rType CHAR(1),
    rAmount INT,
    rBalance INT,
    PRIMARY KEY (RID),
    FOREIGN KEY (AID) REFERENCES Accounts(AID)
);

CREATE TABLE Bills (
    BID SERIAL,
    PID INT,
    bDueDate DATE NOT NULL,
    bAmount INT,
    bIsPaid BOOLEAN NOT NULL,
    PRIMARY KEY (BID),
    FOREIGN KEY (PID) REFERENCES People(PID)
);
