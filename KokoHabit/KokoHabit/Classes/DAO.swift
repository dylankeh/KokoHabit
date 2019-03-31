//
//Name: Dennis Suarez
//Date: March 11, 2019
//

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
    
    public func deletePerson(email:NSString) {
        //Code
    }
    
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
    
    public func updatePerson(email:String) {
        //Code
    }
    
    // Phoenix added
    public func addHabit(userEmail: NSString, habitName: NSString, habitPoint: Int32, addedDate: NSString, status: Int32) {
        let addHabit = "INSERT INTO habit (userEmail, habitName, habitPoint, addedDate, status) VALUES (?,?,?,?,?)"
        
        if validator(){
            var sqlQuery: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, addHabit, -1 , &sqlQuery, nil) == SQLITE_OK{
                
                sqlite3_bind_text(sqlQuery, 1, userEmail.utf8String, -1, nil)
                sqlite3_bind_text(sqlQuery, 2, habitName.utf8String, -1, nil)
                sqlite3_bind_int(sqlQuery, 3, habitPoint)
                
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
    
    public func deleteHabit(email:String) {
        //Code
    }
    
    public func getHabits(date:Date) {
        delegate.habits.removeAll();
        
        db = nil
        
        if validator() {
            print("Successfully opened connection to database at \(String(describing: self.databasePath))")
            
            var queryStatement: OpaquePointer? = nil
            let queryStatementString: String = "SELECT h.id, h.name, dh.pointsWorth, dh.completed FROM habit h INNER JOIN day_habit dh ON h.id = dh.habitId WHERE dh.date = ? AND h.email = ?;"
            
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK{
                
                let dateStr = dateFormatter.string(from: date) as NSString
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
                    delegate.habits.append(data)
                    
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
    }
    
    private func validator()->Bool {
        return sqlite3_open(self.databasePath, &db) == SQLITE_OK
    }
    
}
