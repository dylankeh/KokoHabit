//
//  DatabaseConnection.swift
//  KokoHabit
//
//  Created by Dennis Suarez on 2019-03-11.
//  Copyright © 2019 koko. All rights reserved.
//
// This class allows the DAO class to connect to the SQLite3 Database through a connection

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
