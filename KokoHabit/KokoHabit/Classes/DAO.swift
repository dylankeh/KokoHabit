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
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    override init() {
        super.init()
        databasePath = databaseCheck.getDataBasePath(databaseName: "IOSProject.db")
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
                    print("3")
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
                    
                    let cemail = sqlite3_column_text(sqlQuery, 1)
                    let cname = sqlite3_column_text(sqlQuery, 2)
                    let age: Int = Int(sqlite3_column_int(sqlQuery, 3))
                    let cpassword = sqlite3_column_text(sqlQuery, 4)
                    let coccupation = sqlite3_column_text(sqlQuery, 5)
                    
                    let name = String(cString: cname!)
                    let password = String(cString: cpassword!)
                    let occupation = String(cString: coccupation!)
                    let realemail = String(cString: cemail!)
                    
                   user.initWithData(email: realemail, name: name, age: age, password: password, occupation: occupation)
                    
                    print("Query Result")
                }
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
    
    public func addHabit() {
        //Code
    }
    
    public func deleteHabit(email:String) {
        //Code
    }
    
    public func viewHabits(email:String) {
        //Code
    }
    
    private func validator()->Bool {
        return sqlite3_open(self.databasePath, &db) == SQLITE_OK
    }
    
}
