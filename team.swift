//
//  team.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit


class team: NSObject {
    
    
    class Team {
        var teamLeader:String?
        var teamMembers:String?
        var teamName=Set<String>()
        var pickEvent:Event?
        var teamID:String?
        
        func addMember(accountID:String){
            //add onto database
        }
        func addLeader(leaderID:String){
            //add onto database
        }
        func removeMember(accountID:String){
            //remove from database
        }
        func setPickEvent(){
            
        }
        func removePickEvent(){
            
        }
        
    }
    class Coordinator{
        var adminID
        
    }
}
