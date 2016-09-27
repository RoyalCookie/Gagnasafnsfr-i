

CREATE TABLE Gender (
       gender CHAR(1),
       description VARCHAR(10),
       PRIMARY KEY (gender)
);

CREATE TABLE People (
       ID INT,
       name VARCHAR(50),
       gender CHAR(1),
       height FLOAT,
       PRIMARY KEY (ID),
       FOREIGN KEY (gender) REFERENCES Gender (gender)
);

CREATE TABLE Sports (
       ID INT,
       name VARCHAR(50),
       record FLOAT,
       PRIMARY KEY (ID),
       UNIQUE (name)
);

CREATE TABLE Competitions (
       ID INT,
       place VARCHAR(50),
       held DATE,
       PRIMARY KEY (ID)
);

CREATE TABLE Results (
       peopleID INT NOT NULL,
       competitionID INT NOT NULL,
       sportID INT NOT NULL,
       result FLOAT,
       PRIMARY KEY (peopleID, competitionID, sportID),
       FOREIGN KEY (peopleID) REFERENCES People (ID),
       FOREIGN KEY (competitionID) REFERENCES Competitions (ID),
       FOREIGN KEY (sportID) REFERENCES Sports (ID)
);
