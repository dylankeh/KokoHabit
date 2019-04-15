//
//  User.swift
//  KokoHabit
//
//  Created by 葛青 on 3/17/19.
//  Copyright © 2019 koko. All rights reserved.
//

import UIKit

class User: NSObject {
    
    private var id : Int!
    private var email : String!
    private var name : String!
    private var age : Int!
    private var password : String!
    private var occupation : String?
    //private var uga : UGA!
    
    func initWithData(email: String, name: String, age: Int, password: String, occupation: String) {
        self.email = email
        self.name = name
        self.age = age
        self.password = password
        self.occupation = occupation
    }
    
    func getId() -> Int
    {
        return id
    }
    
    func getEmail() -> String
    {
        return email
    }
    
    func getName() -> String
    {
        return name
    }
    
    func getAge() -> Int
    {
        return age
    }
    
    func getPassword() -> String
    {
        return password
    }
    
    func getOccupation() -> String
    {
        return occupation ?? ""
    }
    
    func setPassword(password: String) {
        self.password = password
    }
    
    func setOccupation(occu: String)
    {
        occupation = occu;
    }
}
