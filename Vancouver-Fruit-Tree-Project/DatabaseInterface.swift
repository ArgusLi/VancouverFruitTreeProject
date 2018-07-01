//
//  DatabaseInterface.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Cameron Savage on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import Foundation
import AWSDynamoDB
import AWSCognitoIdentityProvider
import AWSAuthCore

@objcMembers
class DatabaseInterface {
    
    //MARK: create pick event
    func createPickEvent(eventTime: String, eventDate: String, latitude: String, longitude: String, teamID: String){
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> createPickEvent...")
        // Create data object using data models you downloaded from Mobile Hub
        let pickEventItem: PickEvents = PickEvents()
        pickEventItem._userId = AWSIdentityManager.default().identityId
        
        //get time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        pickEventItem._creationTime = String(hour) + ":" + String(minutes) + ":" + String(seconds)
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        pickEventItem._creationDate = String(year) + "-" + String(month) + "-" + String(day)
        
        pickEventItem._eventTime = eventTime
        pickEventItem._eventDate = eventDate
        
        pickEventItem._assignedTeamID = teamID
        
        pickEventItem._latitude = latitude
        pickEventItem._longitude = longitude
        
        //Save a new item
        dynamoDbObjectMapper.save(pickEventItem, completionHandler: {
            (error: Error?) -> Void in

            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
    
    }
    
    //TODO: scan pick events using FindPick index
    func scanPickEvent(){
    
        
    }
    
    
}
