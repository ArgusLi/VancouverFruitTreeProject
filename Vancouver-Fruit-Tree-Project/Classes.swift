//
//  Classes.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit

class team:NSObject{
    var teamLeader:String?
    var teamMembers=Set<String>()
    var teamName:String?
    var pickEvent:String?
    var teamID:String?
    var dbInterface=DatabaseInterface()
    
    func addMember(accountID:String){
        //Add to database
        //update local teamMembers
    }
    func addLeader(leaderID:String){
        //Add to database
        //update local teamMembers
        
    }
    func removeMember(accountID:String){
        //Add to database
        //update local teamMembers
    }
    func setPickEvent(pickID:String){
        pickEvent=pickID
    }
    func removePickEvent(){
        pickEvent=nil
    }
}
class coordinator:NSObject{
    var adminID:String?
    var dbInterface=DatabaseInterface()
    
    func viewYield()->String{
        //Todo
        return "yield"
    }
    func pushNotificationforPick(){
        //Todo
    }
    func createPickEvent(eventTime: String, eventDate: String, latitude: NSNumber, longitude: NSNumber, teamID: String){
        dbInterface.createPickEvents(eventTime: eventTime, eventDate: eventDate , latitude: latitude, longitude: longitude, teamID: teamID)
    }
    func assignPickToTeam(pickID:String,teamID:String){
        //modify database to change team ID
    }
    func removePickFromTeam(pickID:String,teamID:String){
        //Modify database to change team ID
    }
}
class volunteer: NSObject{
    var teamID: String?
    var pickCounter: Int?
    var volunteerID: String?
    var dbInterface = DatabaseInterface()
    var pickevent: PickEvents?
    
    func requestTeam(teamID:String){
        //Send notification to team leader
        //Message team leader of team
    }
    func viewPick(pick:String?){
        //pull pick from database and display data
    }
    func viewPickOnMap(pick:String?){
        //display pick from database
    }
}

