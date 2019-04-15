//
//  DAO.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-11.
//  Copyright © 2019 koko. All rights reserved.
//
// This class allows to cover a few CRUD operations to insert, select, update and delete information
// from the database

import UIKit
import SQLite3

class DAO: NSObject {
    
    private let databaseCheck = DatabaseConnection();
    private var databasePath: String?
    private var db: OpaquePointer? = nil
    
    let dateFormatter = DateFormatter()
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override init() {
        super.init()
        databasePath = databaseCheck.getDataBasePath(databaseName: "KokoHabitDB.db")
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }
    
    // created by Dennis Suarez
    // how to add an user to the application
    public func addPerson(email:NSString, name:NSString, age:Int32, password:NSString, occupation:NSString) {
        let addPerson = "INSERT INTO user (email, name, age, password, occupation) VALUES (?,?,?,?,?)"
        
        if validator(){
            var sqlQuery: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, addPerson, -1 , &sqlQuery, nil) == SQLITE_OK{
                sqlite3_bind_text(sqlQuery, 1, email.utf8String, -1, nil)
                sqlite3_bind_text(sqlQuery, 2, name.utf8String, -1, nil)
                sqlite3_bind_int(sqlQuery, 3, age)
                sqlite3_bind_text(sqlQuery, 4, password.utf8String, -1, nil)
                sqlite3_bind_text(sqlQuery, 5, occupation.utf8String, -1, nil)
                
                if sqlite3_step(sqlQuery) == SQLITE_DONE {
                    print("Successful insertion")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlQuery)
        }
        sqlite3_close(db)
    }
    
    // created by Dennis Suarez
    // how to get the login information of an user
    public func viewPerson(email:NSString)->User{
        let selectPerson = "SELECT * FROM user WHERE UPPER(email) = UPPER(?)"
        let user: User = User.init()
        
        if validator(){
            var sqlQuery: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, selectPerson, -1 , &sqlQuery, nil) == SQLITE_OK{
                sqlite3_bind_text(sqlQuery, 1, email.utf8String, -1, nil)
                
                while sqlite3_step(sqlQuery) == SQLITE_ROW{
                    
                    let cemail = sqlite3_column_text(sqlQuery, 0)
                    let cname = sqlite3_column_text(sqlQuery, 1)
                    let age: Int = Int(sqlite3_column_int(sqlQuery, 2))
                    let cpassword = sqlite3_column_text(sqlQuery, 3)
                    let coccupation = sqlite3_column_text(sqlQuery, 4)
                    
                    let name = String(cString: cname!)
                    let password = String(cString: cpassword!)
                    let occupation = String(cString: coccupation!)
                    let realemail = String(cString: cemail!)
                    
                   user.initWithData(email: realemail, name: name, age: age, password: password, occupation: occupation)
                    
                    print("Query Result")
                }
                print(databasePath!)
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlQuery)
        }
        sqlite3_close(db)
        return user;
    }
    
    // Phoenix added
    public func addHabit(email: NSString, pointValue: Int32, name: NSString) {
        let addHabit = "INSERT INTO habit (email, pointValue, name) VALUES (?,?,?)"
        
        if validator(){
            var sqlQuery: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, addHabit, -1 , &sqlQuery, nil) == SQLITE_OK{
                
                sqlite3_bind_text(sqlQuery, 1, email.utf8String, -1, nil)
                sqlite3_bind_int(sqlQuery, 2, pointValue)
                sqlite3_bind_text(sqlQuery, 3, name.utf8String, -1, nil)
                
                if sqlite3_step(sqlQuery) == SQLITE_DONE {
                    print("Successful insertion habit")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlQuery)
        }
        sqlite3_close(db)
    }
    
    // Phoenix added
    public func deleteHabit(habitId: Int32) {
        let updateHabitNamePoint = "DELETE FROM week_habit WHERE habitId=? AND weekStartDate = (SELECT MAX(weekStartDate) FROM week_habit);"
        if validator(){
            var sqlUpdate: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updateHabitNamePoint, -1 , &sqlUpdate, nil) == SQLITE_OK{
                
                sqlite3_bind_int(sqlUpdate, 1, habitId)
                
                //print("point is \(pointValue), name is \(name)")
                
                if sqlite3_step(sqlUpdate) == SQLITE_DONE {
                    print("Successful deleted habit")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("DELETE statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("DELETE statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlUpdate)
        }
        sqlite3_close(db)
    }
    
    // Phoenix added
    public func updateHabit(id: Int32, pointValue: Int32, name: NSString)
    {
        let updateHabitNamePoint = "UPDATE habit SET pointValue=?, name=? WHERE id=?;"
        if validator(){
            var sqlUpdate: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updateHabitNamePoint, -1 , &sqlUpdate, nil) == SQLITE_OK{
                
                sqlite3_bind_int(sqlUpdate, 1, pointValue)
                
                sqlite3_bind_text(sqlUpdate, 2, name.utf8String, -1, nil)
                
                sqlite3_bind_int(sqlUpdate, 3, id)
                print("point is \(pointValue), name is \(name)")
                
                if sqlite3_step(sqlUpdate) == SQLITE_DONE {
                    print("Successful updated habit information")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("UPDATE statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlUpdate)
        }
        sqlite3_close(db)
    }
    
    public func updatePointsAfterRandom(habits: [Habit])
    {
        let updateRandomPoint = "UPDATE day_habit SET pointsWorth=? WHERE date=? AND habitId=?;"
        let today = Date.init()
        // use a loop to update every record in the day_habit table
        for index in 0..<habits.count {
            
            if validator(){
                var sqlUpdate: OpaquePointer? = nil
                if sqlite3_prepare_v2(db, updateRandomPoint, -1 , &sqlUpdate, nil) == SQLITE_OK{
                    sqlite3_bind_int(sqlUpdate, 1, Int32(habits[index].getHabitValue()))
                    let dateStr = dateFormatter.string(from: today) as NSString
                    sqlite3_bind_text(sqlUpdate, 2, dateStr.utf8String, -1, nil)
                    sqlite3_bind_int(sqlUpdate, 3, Int32(habits[index].getHabitId()))
                    
                    if sqlite3_step(sqlUpdate) == SQLITE_DONE {
                        print("Successful updated day_habit pointsValue")
                    }
                    else {
                        let errorMessage = String.init(cString: sqlite3_errmsg(db))
                        print("UPDATE statement could not be prepared. \(errorMessage)")
                    }
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("UPDATE statement could not be prepared. \(errorMessage)")
                }
                sqlite3_finalize(sqlUpdate)
            }
            
        }
        sqlite3_close(db)
    }
    
    
    // Created by Khoa Tran
    // get all habits for a specific day for the current user
    public func getHabits(day:Date) -> [Habit] {
        
        var habitList : [Habit] = []
        
        db = nil
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT h.id, h.name, dh.pointsWorth, dh.completed FROM habit h INNER JOIN day_habit dh ON h.id = dh.habitId WHERE dh.date = ? AND h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(queryStatement, 1, dateStr.utf8String, -1, nil)
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 2, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let habitValue: Int = Int(sqlite3_column_int(queryStatement, 2))
                    let completion: Bool = (sqlite3_column_int(queryStatement, 3) == 0) ? false : true
                    
                    let name = String(cString: cname!)
                    
                    let data: Habit = Habit.init(habitId: id, habitName: name, habitValue: habitValue, completion: completion)
                    habitList.append(data)
                    
                    print("Query result")
                    print("\(id) | \(name) | \(habitValue) | \(completion)")
                }
                print("finished selecting")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        return habitList
    }
    
    // Created by Khoa Tran
    // change the completion status of a habit to either complete or incomplete
    public func setHabitCompletetionStatus(day: Date, habitId: Int, status: Int) {
        let updateHabitStmt = "UPDATE day_habit SET completed=? WHERE date=? AND habitId=?;"
        
        if validator(){
            var sqlUpdate: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updateHabitStmt, -1 , &sqlUpdate, nil) == SQLITE_OK{
                
                sqlite3_bind_int(sqlUpdate, 1, Int32(status))
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(sqlUpdate, 2, dateStr.utf8String, -1, nil)
                
                sqlite3_bind_int(sqlUpdate, 3, Int32(habitId))
                
                if sqlite3_step(sqlUpdate) == SQLITE_DONE {
                    print("Successful changed habit completion status")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("UPDATE statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlUpdate)
        }
        sqlite3_close(db)
    }
    
    // Created by Khoa Tran
    public func checkIfDayExists(day: Date) -> Bool {
        db = nil
        
        var exists: Bool = false
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT date FROM day WHERE date=?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(queryStatement, 1, dateStr.utf8String, -1, nil)
                
                // the day has already been created
                if sqlite3_step(queryStatement) == SQLITE_ROW {
                    exists = true
                } 
                print("finished selecting")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return exists
    }
    
    // created by Khoa Tran
    public func checkIfWeekExists(day: Date) -> Bool {
        db = nil
        
        var exists: Bool = false
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT JULIANDAY(?)-JULIANDAY(MAX(weekStartDate)) FROM week;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(queryStatement, 1, dateStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let dateDiff: Double = sqlite3_column_double(queryStatement, 0)
                    
                    // still in the same week
                    if (dateDiff < 7) {
                        exists = true
                        
                    }
                }
                print("finished selecting")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return exists
    }
    
    // Created by Khoa Tran
    public func getLatestWeek() -> Date {
        var weekStartDate: Date = Date.init()
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT weekStartDate FROM day ORDER BY date DESC LIMIT 1;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let cweekStartDate = sqlite3_column_text(queryStatement, 0)
                    weekStartDate = dateFormatter.date(from: String(cString: cweekStartDate!))!
                    
                }
                print("finished selecting")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return weekStartDate
    }
    
    // Created by Khoa Tran
    public func insertWeek(day: Date) {
        let insertWeekStmt = "INSERT INTO week VALUES (?, DATE(?, \"+6 day\"), FALSE, 60);"
        
        if validator(){
            var sqlInsert: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertWeekStmt, -1 , &sqlInsert, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(sqlInsert, 1, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(sqlInsert, 2, dateStr.utf8String, -1, nil)
                
                if sqlite3_step(sqlInsert) == SQLITE_DONE {
                    print("Successful insertion week")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlInsert)
        }
        sqlite3_close(db)
    }
    
    // Created by Khoa Tran
    public func insertDay(day: Date) {
        let insertDayStmt = "INSERT INTO day SELECT ? , MAX(weekStartDate) FROM week;"
        
        if validator(){
            var sqlInsert: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertDayStmt, -1 , &sqlInsert, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(sqlInsert, 1, dateStr.utf8String, -1, nil)

                if sqlite3_step(sqlInsert) == SQLITE_DONE {
                    print("Successful insertion day")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlInsert)
        }
        sqlite3_close(db)
    }
    
    // created by Khoa Tran
    // check if the current user met their weekly point goal
    public func checkIfUserPassedWeeklyPoints() -> Bool {
        db = nil
        
        var passed: Bool = false
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(SUM(dh.pointsWorth), 0) + (SELECT COALESCE(SUM(pointValue), 0) FROM coupon c INNER JOIN day d ON c.dateUsed = d.date INNER JOIN week w ON d.weekStartDate = w.weekStartDate WHERE w.weekStartDate = (SELECT MAX(weekStartDate) FROM week) AND used=1) FROM Week w INNER JOIN Day d ON w.weekStartDate = d.weekStartDate INNER JOIN day_habit dh ON d.date = dh.date INNER JOIN habit h ON h.id = dh.habitId WHERE w.weekStartDate = (SELECT MAX(weekStartDate) FROM week) AND dh.completed=1 AND h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let totalPoints: Int = Int(sqlite3_column_int(queryStatement, 0))
                    
                    // still in the same week
                    if (totalPoints >= 600) {
                        // check if day has been created yet
                        passed = true
                        
                    }
                }
                print("finished selecting weekly points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return passed
    }
    
    // created by Khoa Tran
    // get the current weekly point total for the current user
    public func getUserWeeklyPointTotal() -> Int {
        db = nil
        
        var totalPoints: Int = 0
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(SUM(dh.pointsWorth), 0) + (SELECT COALESCE(SUM(pointValue), 0) FROM coupon c INNER JOIN day d ON c.dateUsed = d.date INNER JOIN week w ON d.weekStartDate = w.weekStartDate WHERE w.weekStartDate = (SELECT MAX(weekStartDate) FROM week) AND used=1) FROM Week w INNER JOIN Day d ON w.weekStartDate = d.weekStartDate INNER JOIN day_habit dh ON d.date = dh.date INNER JOIN habit h ON h.id = dh.habitId WHERE w.weekStartDate = (SELECT MAX(weekStartDate) FROM week) AND dh.completed=1 and h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    totalPoints = Int(sqlite3_column_int(queryStatement, 0))

                }
                print("finished selecting weekly points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return totalPoints
    }
    
    // created by Khoa Tran
    // get the specific day point total for the current user
    public func getUserDayPointTotal(day: Date) -> Int {
        db = nil
        
        var totalPoints: Int = 0
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(SUM(pointsWorth),0) + (SELECT COALESCE(SUM(pointValue),0) FROM coupon c INNER JOIN day d ON c.dateUsed = d.date WHERE dateUsed=? AND used=1) From day_habit dh INNER JOIN habit h ON h.id = dh.habitId WHERE dh.date=? AND dh.completed = TRUE AND h.email=?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(queryStatement, 1, dateStr.utf8String, -1, nil)
                sqlite3_bind_text(queryStatement, 2, dateStr.utf8String, -1, nil)
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 3, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    totalPoints = Int(sqlite3_column_int(queryStatement, 0))
                    
                }
                print("finished selecting weekly points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return totalPoints
    }
    
    // created by Khoa Tran
    // get the days where the current user passed their daily minimum point requirement
    public func getDaysWhereUserPassedMinPoints() -> [Date] {
        db = nil
        
        var dates: [Date] = []
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "select dh.DATE from day_habit dh INNER JOIN day d ON dh.date = d.date INNER JOIN week w ON d.weekStartDate = w.weekStartDate INNER JOIN habit h ON h.id = dh.habitId WHERE dh.completed=1 AND h.email = ? GROUP BY dh.date HAVING SUM(dh.pointsWorth) > w.minimumDayPointRequirement;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let cday = sqlite3_column_text(queryStatement, 0)!
                    dates.append(dateFormatter.date(from: String(cString: cday))!)
                    
                }
                print("finished selecting days where user passed min points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return dates
    }
    
    // Created by Khoa Tran
    public func insertCoupon() {
        let insertCouponStmt = "INSERT INTO coupon (id, email, pointValue) VALUES (NULL, ?, ?);"
        
        if validator(){
            var sqlInsert: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, insertCouponStmt, -1 , &sqlInsert, nil) == SQLITE_OK{
                
                let userEmailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(sqlInsert, 1, userEmailStr.utf8String, -1, nil)
                
                sqlite3_bind_int(sqlInsert, 2, 50)
                
                if sqlite3_step(sqlInsert) == SQLITE_DONE {
                    print("Successful insertion coupon")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlInsert)
        }
        sqlite3_close(db)
    }
    
    // Created by Khoa Tran
    public func useCoupon(day: Date, couponId: Int) {
        
        let useCouponStmt = "UPDATE coupon SET used=1, dateUsed=? WHERE id=?;"
        
        if validator(){
            var sqlUpdate: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, useCouponStmt, -1 , &sqlUpdate, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: day) as NSString
                sqlite3_bind_text(sqlUpdate, 1, dateStr.utf8String, -1, nil)
              
                sqlite3_bind_int(sqlUpdate, 2, Int32(couponId))
                
                sqlite3_bind_int(sqlUpdate, 2, 50)
                
                if sqlite3_step(sqlUpdate) == SQLITE_DONE {
                    print("Successful insertion coupon")
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("INSERT statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("INSERT statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlUpdate)
        }
        sqlite3_close(db)
    }
    
    // Created by Khoa Tran
    public func getCoupons() {
        delegate.coupons.removeAll();
        
        db = nil
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT id, pointValue FROM coupon WHERE email=? AND used=0;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let couponId: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let pointValue: Int = Int(sqlite3_column_int(queryStatement, 1))
                    
                    let data: Coupon = Coupon.init(couponId: couponId, pointValue: pointValue )
                    delegate.coupons.append(data)
                    
                    print("Query result")
                    print("\(couponId) | \(pointValue)")
                }
                print("finished selecting coupons")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
    }
    
    private func validator()->Bool {
        return sqlite3_open(self.databasePath, &db) == SQLITE_OK
    }
    
    
    public func getUserWeeklyPointTotal(week: String) -> Double! {
        db = nil
        
        var totalPoints: Double = 0.0
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(SUM(dh.pointsWorth), 0) + (SELECT COALESCE(SUM(pointValue), 0) FROM coupon c INNER JOIN day d ON c.dateUsed = d.date INNER JOIN week w ON d.weekStartDate = w.weekStartDate WHERE w.weekStartDate = '" + week + "' AND used=1) FROM Week w INNER JOIN Day d ON w.weekStartDate = d.weekStartDate INNER JOIN day_habit dh ON d.date = dh.date INNER JOIN habit h ON h.id = dh.habitId WHERE w.weekStartDate = '" + week + "' AND dh.completed=1 AND h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    totalPoints = Double(sqlite3_column_int(queryStatement, 0))
                    
                }
                print("finished selecting weekly points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return totalPoints
    }
    
    public func getAllStartWeeks() -> [String] {
        db = nil
        
        var listDate = [String]()
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT weekStartDate from week;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    listDate.append(String(cString: sqlite3_column_text(queryStatement, 0)))
                }
                print("finished selecting weekly points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return listDate
    }
    // created by Dennis Suarez
    // get the points for each habit in a daily progress
    public func getHabitProgress() -> [Habit] {
        db = nil
        var habits: [Habit] = []
        let today = Date.init()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT h.id, h.name, dh.pointsWorth, dh.completed FROM habit h INNER JOIN day_habit dh ON h.id = dh.habitId WHERE dh.date = '" + formatter.string(from: today) + "' AND h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    let id: Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let points: Int = Int(sqlite3_column_int(queryStatement, 2))
                    let completed: Int = Int(sqlite3_column_int(queryStatement, 3))
                    
                    let name = String(cString: cname!)
                    
                    let habit:Habit = Habit.init(habitId: id, habitName: name, habitValue: points, completion: Bool(truncating: completed as NSNumber))
                    habits.append(habit)
                    
                }
                print("finished selecting days where user passed min points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return habits
    }
    
    // created by Khoa Tran
    // get the total cumulative points for the current user
    public func getUserTotalPoints() -> Int {
        db = nil
        
        var totalPoints: Int = 0
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(SUM(pointsWorth),0) + (SELECT COALESCE(SUM(pointValue),0) FROM coupon c WHERE used=1) From day_habit dh INNER JOIN habit h ON h.id = dh.habitId WHERE dh.completed = TRUE AND h.email=?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    totalPoints = Int(sqlite3_column_int(queryStatement, 0))
                    
                }
                print("finished selecting total points")
                sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return totalPoints
    }
    
    // created by Khoa Tran
    // get the total cumulative habits completed for the current user
    public func getUserTotalHabitsCompleted() -> Int {
        db = nil
        
        var totalCompleted: Int = 0
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT COALESCE(COUNT(*),0) FROM day_habit dh INNER JOIN habit h ON h.id = dh.habitId WHERE dh.completed = TRUE AND h.email=?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(queryStatement, 1, emailStr.utf8String, -1, nil)
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    totalCompleted = Int(sqlite3_column_int(queryStatement, 0))
                    
                }
                print("finished selecting total habits completed")
                    sqlite3_finalize(queryStatement)
            } else {
                print("Select statement could not be prepared")
            }
            sqlite3_close(db)
        } else {
            print("Unable to open database")
        }
        
        return totalCompleted
    }
    
    // created by Khoa Tran
    // Last motified: Xiaoyu Liang
    // Change user's password
    public func updatePassword(password: String) -> Bool{
        let updatePasswordQuery = "UPDATE user SET password = ? WHERE email = ?"
        var isSuccessful: Bool = false
        
        if validator(){
            var sqlQuery: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, updatePasswordQuery, -1 , &sqlQuery, nil) == SQLITE_OK{
                
                let emailStr = delegate.user.getEmail() as NSString
                sqlite3_bind_text(sqlQuery, 2, emailStr.utf8String, -1, nil)
                let passwordStr = password as NSString
                sqlite3_bind_text(sqlQuery, 1, passwordStr.utf8String, -1, nil)
                
                if sqlite3_step(sqlQuery) == SQLITE_DONE {
                    print("Successful updated password")
                    isSuccessful = true
                }
                else {
                    let errorMessage = String.init(cString: sqlite3_errmsg(db))
                    print("UPDATE statement could not be prepared. \(errorMessage)")
                }
            }
            else {
                let errorMessage = String.init(cString: sqlite3_errmsg(db))
                print("UPDATE statement could not be prepared. \(errorMessage)")
            }
            sqlite3_finalize(sqlQuery)
        }
        sqlite3_close(db)
        return isSuccessful
    }
}
