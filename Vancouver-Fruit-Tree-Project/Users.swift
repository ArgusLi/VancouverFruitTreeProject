//
//  Users.swift
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

@objcMembers // <-- don't remove this, it will break uploading
class Users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    //var _pickEvents: [(PickEvents, String)]?
    //var _pickEvents: [String]?
    var _pickEvents: [[String]]?
    var _role: String?
    var _yield: NSNumber?
    

    class func dynamoDBTableName() -> String {
        
        return "vancouverfruittreepr-mobilehub-79870386-Users"
    }
    
    class func hashKeyAttribute() -> String {
        
        return "_userId"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
            "_userId" : "userId",
            "_pickEvents" : "PickEvents",
            "_role" : "role",
        ]
    }
}

