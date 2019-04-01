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
    active BOOLEAN DEFAULT(TRUE), 
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

-- automatically insert all active habits into week_habit table when a new week is added
CREATE TRIGGER insert_into_week_habit
	AFTER INSERT ON week
BEGIN
	INSERT INTO week_habit SELECT NEW.weekStartDate, id FROM habit WHERE active=1;
END;

-- automatically insert the weeks habit into day_habit table when a new day is added
CREATE TRIGGER insert_into_day_habit
	AFTER INSERT ON day
BEGIN
	INSERT INTO day_habit SELECT NEW.date, wh.habitId, h.pointValue, 0 
	    FROM week_habit wh INNER JOIN  habit h ON wh.habitId = h.id
	    WHERE wh.weekStartDate=NEW.weekStartDate;
END;

-- set habit to inactive and delete from day_habit when user deletes habit from their weekly habits
CREATE TRIGGER set_habit_to_inactive
	AFTER DELETE ON week_habit
BEGIN
	UPDATE habit SET active=0 WHERE id=OLD.habitId;
	DELETE FROM day_habit WHERE habitId=OLD.habitId;
END;

-- automatically insert into day_habit and week_habit table when new habit is added
CREATE TRIGGER add_habit_to_dayweek_habit
    AFTER INSERT ON habit
BEGIN
    INSERT INTO week_habit SELECT MAX(weekStartDate), NEW.id FROM week;
    INSERT INTO day_habit SELECT MAX(date), NEW.id, NEW.pointValue, 0 FROM day;
END;

-- add habit to week_habit and day_habit if it is updated to active
CREATE TRIGGER set_habit_to_active
    AFTER UPDATE ON habit WHEN NEW.active=1
BEGIN
    INSERT INTO week_habit SELECT MAX(weekStartDate), OLD.id FROM week;
	INSERT INTO day_habit SELECT MAX(date), OLD.id, OLD.pointValue, 0 FROM day;
END;


INSERT INTO user VALUES ("koko","koko",22,"1234","Student");

INSERT INTO habit VALUES (1, "koko", 20, "Eat healthy",1);
INSERT INTO habit VALUES (2, "koko", 40, "Go to gym",1);
INSERT INTO habit VALUES (3, "koko", 10, "Read a book",1);
INSERT INTO habit VALUES (4, "koko", 30, "Wake up early",1);
INSERT INTO habit VALUES (5, "koko", 20, "Sleep Early",1);
INSERT INTO habit VALUES (6, "koko", 20, "Sleep Early",0);

INSERT INTO coupon VALUES (NULL, "koko", 50);

INSERT INTO week VALUES ("2019-03-24","2019-03-30",1,60,500);
INSERT INTO week VALUES ("2019-03-31","2019-04-06",0,60,0);

INSERT INTO day VALUES ("2019-03-30","2019-03-24");
INSERT INTO day VALUES ("2019-03-31","2019-03-31");

-- INSERT INTO week_habit VALUES ("2019-03-24", 1);
-- INSERT INTO week_habit VALUES ("2019-03-24", 2);
-- INSERT INTO week_habit VALUES ("2019-03-24", 3);
-- INSERT INTO week_habit VALUES ("2019-03-24", 4);

INSERT INTO day VALUES ("2019-03-30", "2019-03-24");

-- INSERT INTO day_habit VALUES ("2019-03-30",1,20,1);
-- INSERT INTO day_habit VALUES ("2019-03-30",2,40,1);
-- INSERT INTO day_habit VALUES ("2019-03-30",3,10,1);
-- INSERT INTO day_habit VALUES ("2019-03-30",4,30,0);

