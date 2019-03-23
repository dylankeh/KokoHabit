//
//Name: Dennis Suarez
//Date: March 11, 2019
//

import UIKit

class DatabaseConnection: NSObject {
    
    private var docsDir : String?
    private var databasePath : String?
    
    //Initializing basic variables
    override init() {
        
        super.init()
        let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        docsDir = docsPath[0]
    }
    
    //Returns a copy of the database path
    public func getDataBasePath(databaseName : String) -> String?{
        
        databasePath = docsDir?.appending("/" + databaseName)
        return databasePath
    }

}
