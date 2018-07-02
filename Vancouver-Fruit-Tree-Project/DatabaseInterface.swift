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
    /// Creates and uploads a new pick event to the database
    ///
    /// - Parameters:
    ///   - eventTime: the scheduled time for the event, in 24HR format. Format: "HH/MM/SS". Do not use leading 0s. Example: "12:30:5" ; "16:5:30"
    ///   - eventDate: the scheduled date for the event, in YYYY/MM/DD format. Do not use leading 0s. Example: "2018/6/30"
    ///   - latitude: the latitude for the location of the event
    ///   - longitude: the longitude for the location of the event
    ///   - teamID: the ID string for the team assigned to the pickEvent
    func createPickEvents(eventTime: String, eventDate: String, latitude: NSNumber, longitude: NSNumber, teamID: String){
        
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
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        /*  ._creationTime stores a combination of the date and time as
            the sorting hash to guarantee the uniqueness of the primary
            hash
        */
        pickEventItem._creationTime = String(year) + "/" + String(month) + "/" + String(day) + "-" + String(hour) + ":" + String(minutes) + ":" + String(seconds)

        //this isn't really a necessary attribute
        pickEventItem._creationDate = String(year) + "/" + String(month) + "/" + String(day)
        
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
    
    //MARK: Search for pickEvents by date and time
    /// Queries pick events by date and time using FindPick index.
    /// Returns all pick events that are on the date and at or before the time.
    ///
    /// - Parameters:
    ///   - date: Search criteria for Pick Event, format: "YYYY/MM/DD"
    ///             **NOTE** Do not use leading 0s
    ///             **Example** "1970/1/1"
    ///   - time: Search criteria for Pick Event in 24HR format, format: "HH:MM:SS"
    ///             **NOTE** Do not use leading 0s
    /// - Returns: [PickEvents]
    func queryPickEventsByDate(date: String, time: String?) -> [PickEvents] {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> queryPickEventsByDate")
        var pickArray: [PickEvents] = []
        var queryComplete = false
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "FindPick"
        queryExpression.keyConditionExpression = "#eventDate = :eventDate AND #eventTime <= :eventTime";
        queryExpression.expressionAttributeNames = ["#eventDate": "eventDate", "#eventTime": "eventTime"]
        queryExpression.expressionAttributeValues = [":eventDate": date, ":eventTime": time!]
        
        dynamoDBObjectMapper.query(PickEvents.self, expression: queryExpression)
        { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            
            if output != nil {
                for pick in output!.items {
                    let pickItem = pick as? PickEvents
                    //print("\(pickItem!._eventDate!)")
                    pickArray.append(pickItem!)

                }
            }
            
            //print("After appeding inside of function: ", pickArray.count)
            queryComplete = true;
        }
        
        while queryComplete == false {
            if queryComplete == true{
                print("query is finished")
                queryComplete = false
                return pickArray
            }
        }
        
        return pickArray
        //print("count outside of inside function:", self._pickArray.count)
        //return self._pickArray
    }
    
    //MARK: scans whole table, then applies filters afterwards
    func scanPickEvents(){
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 20
//        
//        dynamoDBObjectMapper.scan(PickEvents.self, expression: scanExpression).continueWith(block: { (task:AWSTask<AWSDynamoDBPaginatedOutput>!) -> Any? in
//            if let error = task.error as NSError? {
//                print("The request failed. Error: \(error)")
//            } else if let paginatedOutput = task.result {
//                for pick in paginatedOutput.items as! PickEvents {
//                    // Do something with pick.
//                    print(type(of: PaginatedOutput.items))
//                }
//            }
//        })
        
    }
    
    
}
