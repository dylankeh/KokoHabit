CREATE TABLE user (
    email TEXT PRIMARY KEY,
    name TEXT,
    age INTEGER,
    password TEXT NOT NULL,
    occupation TEXT
);

CREATE TABLE coupon (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    pointValue INTEGER NOT NULL,
    FOREIGN KEY (email) REFERENCES user (email)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE habit (
    id INTEGER PRIMARY KEY,
    email TEXT NOT NULL,
    pointValue INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (email) REFERENCES user (email)
    ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE week (
	weekStartDate DATE PRIMARY KEY,
	weekEndDate DATE,
	locked INTEGER,
	minimumDayPointRequirement INTEGER, -- will be the same for whole week
	weekPointProgress INTEGER DEFAULT(0)
);

-- shows habits for week
CREATE TABLE week_habit (
	weekStartDate Date NOT NULL,
	habitId INTEGER NOT NULL,
	FOREIGN KEY (weekStartDate) REFERENCES week (weekStartDate)
	FOREIGN KEY (habitId) REFERENCES habit (id)
);

CREATE TABLE day (
    date PRIMARY KEY,
    pointsAchieved INTEGER NOT NULL DEFAULT(0),
    weekStartDate DATE,
    FOREIGN KEY (weekStartDate) REFERENCES week (weekStartDate)
);

-- shows habits for particular day
CREATE TABLE day_habit (
	date DATE,
	habitId INTEGER,
	pointsWorth INTEGER,
	completed BOOLEAN DEFAULT(FALSE),
	FOREIGN KEY (date) REFERENCES day (date)
	FOREIGN KEY (habitId) REFERENCES habit (id)
);

INSERT INTO user VALUES ("koko","koko",22,"",NULL);

INSERT INTO habit VALUES (1, "koko", 20, "Eat healthy");
INSERT INTO habit VALUES (2, "koko", 40, "Go to gym");
INSERT INTO habit VALUES (3, "koko", 10, "Read a book");
INSERT INTO habit VALUES (4, "koko", 30, "Wake up early");

INSERT INTO coupon VALUES (NULL, "koko", 50);

INSERT INTO week VALUES ("2019-03-24","2019-03-30",1,60,500);
-- INSERT INTO week VALUES ("2019-03-31","2019-04-06",0,60,0);

INSERT INTO week_habit VALUES ("2019-03-24", 1);
INSERT INTO week_habit VALUES ("2019-03-24", 2);
INSERT INTO week_habit VALUES ("2019-03-24", 3);
INSERT INTO week_habit VALUES ("2019-03-24", 4);

INSERT INTO day VALUES ("2019-03-30",70,"2019-03-24");

INSERT INTO day_habit VALUES ("2019-03-30",1,20,1);
INSERT INTO day_habit VALUES ("2019-03-30",2,40,1);
INSERT INTO day_habit VALUES ("2019-03-30",3,10,1);
INSERT INTO day_habit VALUES ("2019-03-30",4,30,0);

