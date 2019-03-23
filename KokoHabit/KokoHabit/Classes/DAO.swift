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
            }
        }
    }
    
    public func deletePerson(email:String) {
        //Code
    }
    
    public func viewPerson(email:String) {
        //Code
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
