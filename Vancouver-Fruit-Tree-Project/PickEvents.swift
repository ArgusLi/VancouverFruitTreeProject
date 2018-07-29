//  PickEvents.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.21
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers
class PickEvents: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _creationTime: String?
    var _address: String?
    var _creationDate: String?
    var _distanceFrom: NSNumber?
    var _eventDate: String?
    var _eventTime: String?
    var _latitude: NSNumber?
    var _longitude: NSNumber?
    var _registeredUsers: [String]?
    var _teamLead: String?
    var _treeMap: [String: String]?
    var _volunteers: [String]?
    var _yield: [String : [String]]?
    class func dynamoDBTableName() -> String {
        
        return "vancouverfruittreepr-mobilehub-79870386-PickEvents"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {
        
        return "_creationTime"
    }
    func isFull() -> Bool{
        if _volunteers != nil{
            if let map = _treeMap {
                if let capacity = map[TreeProperties.numofV.rawValue]{
                    if(_volunteers!.count >= Int(capacity)!){
                        return true
                    }
                    else {
                        return false
                    }
                }
                fatalError("This event has no capacity property")
            }
            else {
                fatalError("This event has no properties in the map")
            }
        }
        else {
            return false
        }
        return false
    }
    func hasTeamLead() -> Bool{
        if _teamLead != nil{
            return true
        }
        else {
            return false
        }
    }
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_creationTime" : "creationTime",
            "_address" : "address",
            "_creationDate" : "creationDate",
            "_distanceFrom" : "distanceFrom",
            "_eventDate" : "eventDate",
            "_eventTime" : "eventTime",
            "_latitude" : "latitude",
            "_longitude" : "longitude",
            "_registeredUsers" : "registeredUsers",
            "_teamLead" : "teamLead",
            "_treeMap" : "treeMap",
            "_volunteers" : "volunteers",
            "_yield" : "yield",
        ]
    }
}
