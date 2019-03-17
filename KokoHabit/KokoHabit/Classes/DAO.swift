//
//Name: Dennis Suarez
//Date: March 11, 2019
//

import UIKit
import SQLite3

class DAO: NSObject {
    
    private let databaseCheck = DatabaseConnection();
    private var databasePath: String?
    
    override init() {
        super.init()
        databasePath = databaseCheck.getDataBasePath(databaseName: "IOSProject.db")
    }
    
    public func addPerson() {
        //Code
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

}
