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
@objcMembers
class Users: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var _userId: String?
    var _userName: String?
    var _email: String?
    var _firstName: String?
    var _lastName: String?
    var _role: String?
    
    class func dynamoDBTableName() -> String {

        return "vancouverfruittreepr-mobilehub-79870386-Users"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_userName"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_userName" : "userName",
               "_email" : "email",
               "_firstName" : "firstName",
               "_lastName" : "lastName",
               "_role" : "role",
        ]
    }
}