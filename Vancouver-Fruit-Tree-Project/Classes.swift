//
//  Classes.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Argus Li on 2018-07-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import UIKit
let dbInterface=DatabaseInterface()
//var pickEvents: PickEvents?

/*TODO Ver2
class team:NSObject{
    var teamLeader:String?
    var teamMembers=Set<String>()
    var teamName:String?
    var pickEvent:String?
    var teamID:String?

    
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
 */
class coordinator:NSObject{
    var adminID:String?
    var pickEvent: PickEvents?
    var success:Int=0
    
    /*
    func viewYield()->String{
        //Todo ver2
    }
    func pushNotificationforPick(){
        //Todo ver 2
    }
 */
    func createPickEvent(eventTime: String, eventDate: String, latitude: NSNumber, longitude: NSNumber, teamID: String, address: String, treeMap: [String:String]){
        dbInterface.createPickEvents(eventTime: eventTime, eventDate: eventDate, latitude: latitude, longitude: longitude, teamID: teamID, address: address, treeMap: treeMap)
    }
    func assignPickToTeam(userId: String, creationTime: String, teamID:String){
        //find and read pick
        pickEvent=dbInterface.readPickEvent(userId: userId, creationTime: creationTime)
        //upload pick with new teamID to database
        if pickEvent != nil{
            pickEvent!._assignedTeamID=teamID
            dbInterface.createPickEvents(eventTime: (pickEvent?._eventTime)!, eventDate: (pickEvent?._eventDate)!, latitude: (pickEvent?._latitude)!, longitude: (pickEvent?._longitude)!, teamID: (pickEvent?._assignedTeamID)!, address: (pickEvent?._address)! , treeMap: (pickEvent?._treeMap)!)
        }
    }
    func removePickFromTeam(userId: String, creationTime: String, teamID:String){
        //find and read pick
        pickEvent=dbInterface.readPickEvent(userId: userId, creationTime: creationTime)
        //upload pick with new teamID to database
        if pickEvent != nil{
            pickEvent!._assignedTeamID=nil
            dbInterface.createPickEvents(eventTime: (pickEvent?._eventTime)!, eventDate: (pickEvent?._eventDate)!, latitude: (pickEvent?._latitude)!, longitude: (pickEvent?._longitude)!, teamID: (pickEvent?._assignedTeamID)!, address: (pickEvent?._address)!, treeMap: (pickEvent?._treeMap)!)
        }
}
class volunteer:NSObject{
    var teamID:String?
    var pickCounter:Int?
    var volunteerID:String?
    /*todo version 3
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
 */
}

}
