//
//  DatabaseInterface.swift
//  Vancouver-Fruit-Tree-Project
//
//  Created by Cameron Savage on 2018-06-30.
//  Copyright © 2018 Harvest8. All rights reserved.
//
import UIKit
import Foundation
import AWSDynamoDB
import AWSCognitoIdentityProvider
import AWSAuthCore
import AWSCore
//import AWSS3
//import AWSCognitoIdentityProviderASF

@objcMembers
class DatabaseInterface: NSObject {
    
    //MARK: User Methods
    
    // Author: Artem
    func queryUsers() -> [AWSCognitoIdentityProviderUserType]?{
        var users = [AWSCognitoIdentityProviderUserType]()
        var test = [Dictionary<String, String>]()
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,identityPoolId:"us-east-1:418ae064-cd87-4807-9234-412af6afcb20")
        let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
        

        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let Cognito = AWSCognitoIdentityProvider.default()
        var queryComplete = false
        let request = AWSCognitoIdentityProviderListUsersRequest()
        request?.attributesToGet = []
        request?.userPoolId = "us-east-1_LXKwVfwkz"
        Cognito.listUsers(request!).continueOnSuccessWith(block: { (task: AWSTask) -> AnyObject?
        in
        if let error = task.error as NSError? {
            
            print("Amazon DynamoDB Save Error: \(error)")
            queryComplete = true;
            
            return nil
        }
            
            
            if task.result?.users != nil{
            for us in (task.result?.users)!{
                var temp = Dictionary<String,String>()
                temp["user-name"] = us.username
                temp["enabled"] = "\(us.enabled)"
                temp["user-create-date"] = us.username
                temp["status"] = "\(us.userStatus)"
                test.append(temp)
                users.append(us)
                
            }
            }
            
            print(test)
                        return task
            
            
        }).continueOnSuccessWith(block: {(task: AWSTask) -> AnyObject?
            in
            queryComplete = true
            print("Query set to complete")
            
            return task.result
        })
        
        
        
     
        
        
        
        while queryComplete == false {
        
            if queryComplete == true{
                print("query is finished")
                
                queryComplete = false
                
                return users
            }
        }
        return users
        
    }
    
    //MARK: User info methods
    
    //Author: Artem
    /// returns username of a current user
    ///
    /// - Returns: returns optional String if the userName is found in the user pool, nil otherwise
    func getUsername() -> String? {
        //to check if user is logged in with Cognito... not sure if this is necessary
        let identityManager = AWSIdentityManager.default()
        let identityProvider = identityManager.credentialsProvider.identityProvider.identityProviderName
        
        if identityProvider == "cognito-identity.amazonaws.com" {
            
            let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
            let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "7bgr1sfh851ajh0v3t65hq69q3", clientSecret: "9bllitmncjkeb9nnnvb4ei0e6vod746e7pa83hqm39nsvssqh05", poolId: "us-east-1_LXKwVfwkz")
            AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            let pool = AWSCognitoIdentityUserPool(forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            
            if let username = pool.currentUser()?.username {
                print("Username Retrieved Successfully: \(username)")
                return username
            } else {
                print("Error getting username from current user - attempt to get user")
                let user = pool.getUser()
                
                let username = user.username
                return username
            }
            
            
            
            
            
        }
        return nil
    }

    //Author: Artem
    /// Marks a user with a given username as present for a pick passed in pickItem
    ///
    /// - Parameter userId: the user's userID
    /// - Parameter pickeItem: Pick event
    /// - Returns: returns true if the operation succeded, false otherwise
    func markPresent(pickItem: PickEvents, userID: String) -> Bool{
        var user = queryUserInfo(userId: userID)
        if (user == nil){
            print("user is nil")
            return false
        }
        if let events = user?._pickEvents{
            var index: Int?
            for event in events{
                if (event[0] == pickItem._userId! && event[1] == pickItem._creationTime!)
                {
                    index = events.index(of: event)
                }
            }
            if (index == nil){
                print("No mathing event found in user records")
                return false
            }
            else{
                //Mark this person as present for this event
                user?._pickEvents![index!][2] = "1"
                let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
                dynamoDbObjectMapper.save(user!, completionHandler: {
                    (error: Error?) -> Void in
                    
                    if let error = error {
                        print("Amazon DynamoDB Save Error: \(error)")
                        return
                    }
                    print("An item was saved.")
                })
                
                return true
                
            }
            
        }
        else{
            print("This user has no events")
            return false
        }
      
    }
    
    //Author: Artem
    /// function for getting current's user email
    ///
    /// - Returns: returns optional string that contains current user email or nil otherwise. The function will return only after the task is finished.
    func getEmail() -> String? {
        let identityManager = AWSIdentityManager.default()
        let identityProvider = identityManager.credentialsProvider.identityProvider.identityProviderName
        var responseEmail: String?
        let group = DispatchGroup()
        if identityProvider == "cognito-identity.amazonaws.com" {
            
            group.enter()
            let serviceConfiguration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: nil)
            let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: "7bgr1sfh851ajh0v3t65hq69q3", clientSecret: "9bllitmncjkeb9nnnvb4ei0e6vod746e7pa83hqm39nsvssqh05", poolId: "us-east-1_LXKwVfwkz")
            AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            let pool = AWSCognitoIdentityUserPool(forKey: "vancouverfruittreepr_userpool_MOBILEHUB_79870386")
            if let userFromPool = pool.currentUser() {
                
                
                userFromPool.getDetails().continueOnSuccessWith(block: { (task) -> Any? in
                    DispatchQueue.global(qos: .userInitiated).async {
                        
                        if let error = task.error as NSError? {
                            print("Error getting user attributes from Cognito: \(error)")
                            group.leave()
                        } else {
                            let response = task.result
                            if let userAttributes = response?.userAttributes {
                                
                                for attribute in userAttributes {
                                    if attribute.name == "email" {
                                        if let email = attribute.value
                                        {
                                            
                                            responseEmail = email
                                            group.leave()
                                        }
                                        else{ print("Email is null")
                                            group.leave()
                                        }
                                        
                                        
                                        
                                    }
                                } } } } } )
                
            }
        }
        group.wait()
        return responseEmail
        
    }
    
    //Author: Cameron
    /// returns hashes for all pick events that a user is signed up for
    ///
    /// - Parameter userId: the user's userID
    /// - Returns: returns a Users() object; hashes can be accessed via the ._pickEvents attribute, which contains a [ [String] ] array. Each [String] element contains 3 elements: the partition hash (userId) and the sort hash (creationTime) of the PickEvent, which can be used to read it, and another element that is either 0 or 1 to mark a volunteer's attendance of an event
    func queryUserInfo(userId: String) -> Users? {
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        var received: Users?
        var queryComplete = false
        
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId";
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": userId]
        
        //let currentUserID = AWSIdentityManager.default().identityId
        
        //if currentUserID != userId{
           // print("Error: User ID of current user and creator do not match, read denied")
       // }
        
       
        dynamoDBObjectMapper.query(Users.self, expression: queryExpression)
        { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            
            if output != nil {
                for user in output!.items {
                    let userItem = user as? Users
                    //print("\(pickItem!._eventDate!)")
                    received = userItem!
                }
            }
            
            queryComplete = true;
        }
    
        //waits for query to complete before returning
        while queryComplete == false {
            if queryComplete == true{
                print("query is finished")
                queryComplete = false
                return received //received! != nil
            }
        }
        
        return received //so Xcode stops complaining
        
    }
    
    //Author: Cameron
    /// Saves a pick event to the user's personal database entry
    ///
    /// - Parameters:
    ///   - pickItem: the PickEvent that the user is signing up for
    ///   - userId: the userId of the user
    func signUpForPickEvent (pickItem: PickEvents, userId: String){
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> signUpForPickEvent...")
        
        let UserItemQuery: Users? = queryUserInfo(userId: userId)
        
        var UserItem: Users = Users()
        
        if UserItemQuery != nil {
            UserItem = UserItemQuery!
        }
        
        else {
            UserItem._userId = userId
        }
        
        //UserItem._userId = AWSIdentityManager.default().identityId
        //UserItem._pickEvents?.append((pickItem._userId!, pickItem._creationTime!, "0"))
        
        if UserItem._pickEvents != nil {
            //UserItem._pickEvents!.append((pickItem, "0"))
            print("There are existing events in the list")
            //check if pick event exists in the array already
            
            let count = UserItem._pickEvents!.count
            print("there are " + String(count) + " items")
            var index: Int?
            var i: Int = 0
            
            while index == nil && count != i {
                
                if pickItem._userId == UserItem._pickEvents![i][0] && pickItem._creationTime == UserItem._pickEvents![i][1]{
                    index = i
                    print("item with matching hash found at index [" + String(index!) + "]")
                }
                
                i += 1
                print("at loop itr #" + String(i))
                
            }
            
            if index != nil {
                
                UserItem._pickEvents![index!] = [pickItem._userId!, pickItem._creationTime!, "0"]
                print("item at index [" + String(index!) + "] was replaced")
                
            }
                
            else {
                UserItem._pickEvents!.append([pickItem._userId!, pickItem._creationTime!, "0"])
                print("new item was appended")
            }
        }
        
        else {
            print("list is empty")
            UserItem._pickEvents = [[pickItem._userId!, pickItem._creationTime!, "0"]]
        }
        
        if UserItem._role == nil {
            UserItem._role = Roles.volunteer.rawValue
        }
        
        //Save a new item
        dynamoDbObjectMapper.save(UserItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        if (UserItem._role == Roles.volunteer.rawValue) {
       
                     if( pickItem._volunteers?.append(userId) == nil)
                     {
                        pickItem._volunteers = [userId]
            }
            print("Appended user id")
        }
        if (UserItem._role == Roles.lead.rawValue || UserItem._role == Roles.admin.rawValue){
            pickItem._teamLead = userId
        }
        pickItem._distanceFrom = nil
        dynamoDbObjectMapper.save(pickItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        
        //removeSignUpForPickEvent(pickItem: pickItem, userId: userId)
    }
    
    //Author: Cameron
    /// removes a pick event from the user's personal database entry
    ///
    /// - Parameters:
    ///   - pickItem: the PickEvent that the user is signed up for that they are to be removed from
    ///   - userId: the userID of the user
    func removeSignUpForPickEvent (pickItem: PickEvents, userId: String) {
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> removeSignUpForPickEvent...")
        //let ret: Int = 1
        //var queryComplete = false
        
        let UserItem: Users = queryUserInfo(userId: userId)!
        
        if UserItem._pickEvents != nil {
            //UserItem._pickEvents!.append((pickItem, "0"))
            print("There are existing events in the list")
            //check if pick event exists in the array
            
            let count = UserItem._pickEvents!.count
            var index: Int?
            var i: Int = 0
            
            while index == nil || count != i {
                
                if pickItem._userId == UserItem._pickEvents![i][0] && pickItem._creationTime == UserItem._pickEvents![i][1]{
                    index = i
                    print("item with matching hash found at index [" + String(index!) + "]")
                }
                
                i += 1
                print("at loop itr #" + String(i))
                
            }
            
            if index != nil {
                UserItem._pickEvents!.remove(at: index!)
                print("item at index [" + String(index!) + "] was removed")
                
                if UserItem._pickEvents!.count == 0 {
                    UserItem._pickEvents = nil
                }
                
            }
                
            else {
                print("user is not signed up for passed PickEvent")
            }
        }
            
        else {
            print("user is not signed up for any PickEvent")
        }
        
        if UserItem._role == nil {
            UserItem._role = Roles.volunteer.rawValue
        }
        if (UserItem._role == Roles.volunteer.rawValue){
            if let i = pickItem._volunteers?.index(of: userId){
                pickItem._volunteers?.remove(at: i)
            }
            else{
                print("User is not signed up for this event")
            }
        }
        else if (UserItem._role == Roles.lead.rawValue){
            if pickItem._teamLead != nil{
                pickItem._teamLead = nil
                
            }
            else {
                print("Team lead does not exist ")
            }
        }
        //Save a new item
        dynamoDbObjectMapper.save(UserItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        dynamoDbObjectMapper.save(pickItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        
        
    }
    
    //Author: Cameron
    ///Updates the info stored in Dynamo for the user that calls it
    ///
    /// - Parameter UserInfo: the Users() object that contains the user info
    /// - Returns: returns "success" on upload, error message otherwise
    func UpdateOwnUserInfo(UserInfo: Users) -> String{
        let group = DispatchGroup()
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        var response: String = "incomplete"
        
        group.enter()
        
        //auth user to only access own info
        if UserInfo._userId != self.getUsername(){

            return "user attempting to update info of other user"
        }
        
        //Save a new item
        dynamoDbObjectMapper.save(UserInfo, completionHandler: {
            (error: Error?) -> Void in
            
            DispatchQueue.global(qos: .userInitiated).async{
                
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    response = "Error: " + error.localizedDescription
                    group.leave()
                    return
                }
                print("An item was saved.")
                response = "success"
                group.leave()
            }
            
        })
        
        group.wait()
        return response
        
    }
    
    //Author: Cameron
    /// saves yield into team leader user info and the pick event
    ///
    /// - Parameters:
    ///   - pickItem: pick event
    ///   - Leader: Users() object for the team leader of the pick event
    ///   - totalYield: the total yield collected from all fruit combined, saved to Leader parameter
    ///   - fruitYield: [String:String] map, stores yields for each type of fruit in the event
    /// - Returns: tuple of strings (String, String), 0 = error for PickEvent upload, 1 = error for Users() upload
//    func UpdateYield(pickItem: PickEvents, Leader: Users, totalYield: Int, fruitYield: [String : String]) -> (String, String){
//
//        // check if yield parameter is empty, add to it if it isn't, overwrite if it is
//        if Leader._yield != nil {
//            var currentYield: Int = Leader._yield!.intValue
//
//            currentYield += totalYield
//            Leader._yield! = NSNumber(value: Int32(currentYield))
//        }
//
//        else {
//            Leader._yield = NSNumber(value: Int32(totalYield))
//        }
//
//        //overwrite yield parameter
//        pickItem._yield = fruitYield
//
//        //save new values in database
//        let pickReturn = self.modifyPickEventsWithHash(pickEventItem: pickItem)
//        let userReturn = self.UpdateOwnUserInfo(UserInfo: Leader)
//
//        return (pickReturn, userReturn)
//
//    }

    //Author: Artem
    /// Gets a list of users signed-up for a specific event
    ///
    /// - Parameter pickeItem: Pick event
    /// - Returns: list of Users objects if the username in the users table matches usernames in the pick event volunters
    func getVolunteers(pickItem: PickEvents) -> [Users]{
        var users = [Users]()
        if let userNames = pickItem._volunteers{
            for user in userNames{
                if let us = queryUserInfo(userId: user){
                    users.append(us)
                    
                }
                else{
                    print("Did not find a user with username \(user)")
                }
            }
        }
        else{
            print("No volunteers for this event")
        }
        return users
    }
    
    //Author: Artem
    /// logs a yield for a specific pick event
    ///
    /// - Parameters:
    ///   - pickItem: the PickEvent to log the yield for
    ///   - dict: Dictonary that has type of the tree as a key and list of yield measurments with grade a measurments at position 0 and grade b in the position 1
   
    func logYield(pickItem: PickEvents?, dict: [String : [String]]){
        if( pickItem == nil){
            return
        }
        if (dict.count == 0){
            return
        }
        pickItem!._yield = dict
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        dynamoDbObjectMapper.save(pickItem!, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        
    }
    
    //Author: Cameron
    ///Updates the info stored in Dynamo for a user
    ///
    /// - Parameter UserInfo: the Users() object that contains the user info
    /// - Returns: returns "success" on upload, error message otherwise
    func adminUpdateUserInfo(UserInfo: Users) -> String{
        let group = DispatchGroup()
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        var response: String = "incomplete"
        
        //authenticate admin user
        let auth: Users? = self.queryUserInfo(userId: self.getUsername()!)
        if auth != nil {
            
            if auth?._role != "Administrator"{
                return "Error: user is not Administrator"
            }
        }
            
        else if auth == nil {
            return "Error: user doesn't have a role in database"
        }
        
        
        group.enter()
        
        //Save a new item
        dynamoDbObjectMapper.save(UserInfo, completionHandler: {
            (error: Error?) -> Void in
            
            DispatchQueue.global(qos: .userInitiated).async{
                
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    response = "Error: " + error.localizedDescription
                    group.leave()
                    return
                }
                print("An item was saved.")
                response = "success"
                group.leave()
            }
            
        })
        
        group.wait()
        return response
        
    }
    
    //MARK: User query methods
    
    //Author: Cameron
    /// For admins / coordinators: returns a list of all users who have entries in Users() table
    ///
    /// - Parameter itemLimit: max number of users to be returned
    /// - Returns: tuple of [Users] and int; if user authentication fails, or an entry for the user in the Users table doesn't exist, will return ([], 0)
    func adminGetUsersTable(itemLimit: NSNumber) -> ([Users], Int) {
       
        let group = DispatchGroup()
        
        var UsersArray: [Users] = [Users]()
        
        //authenticate admin user
        let auth: Users? = self.queryUserInfo(userId: self.getUsername()!)
        if auth != nil {
            
            if auth?._role != "Administrator"{
                return (UsersArray, 0)
            }
        }
        
        else if auth == nil {
            return (UsersArray, 0)
        }
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        
        scanExpression.limit = itemLimit
        
        group.enter()
        dynamoDBObjectMapper.scan(Users.self, expression: scanExpression)  { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if error != nil {
                    print("The request failed. Error: \(String(describing: error))")
                    group.leave()
                }
            
                if output != nil {
                    for user in output!.items {
                        let UserItem = user as? Users
                        print("\(UserItem!._userId!)")
                        UsersArray.append(UserItem!)
                    }
                }
                group.leave()
            }
            
        }
        
        group.wait()
        return (UsersArray, 1)
    }
    
    // Author: Cameron
    /// For admins: change the user role of another user
    ///
    /// - Parameters:
    ///   - username: username of the user to be modified
    ///   - roleToChangeTo: role to change the user to; Volunteer, Leader, Administrator
    /// - Returns: "success" for successful, error message otherwise
    func adminChangeUserRole(username: String, roleToChangeTo: String) -> String {
        
        let group = DispatchGroup()
        group.enter()
        //authenticate admin user
        let auth: Users? = self.queryUserInfo(userId: self.getUsername()!)
        if auth != nil {
            
            if auth?._role != "Administrator"{
                group.leave()
                return "Error: you are not an administrator"
            }
        }
            
        else if auth == nil {
            group.leave()
            return "Error: no entry in table for current user"
        }
        
        
        let UserInfo = self.queryUserInfo(userId: username)
        
        
        if UserInfo != nil {
            UserInfo!._role! = roleToChangeTo
            
        }
        
        else {
            
            let UserInfo = Users()
            UserInfo!._userId = username
            UserInfo!._role = roleToChangeTo
            UserInfo!._pickEvents = nil
            
        }
        
        //update user info
        let response = self.adminUpdateUserInfo(UserInfo: UserInfo!)
        
        //group.wait()
        return response
        
        
    }
   
    /// Get list of users who have a specific role
    ///
    /// - Parameters:
    ///   - role: either "Volunteer", "Leader", or "Administrator"
    ///   - itemLimit: max number of users to be returned
    /// - Returns: optional array of Users objects
    func queryUserByRoles(userRole: String, itemLimit: NSNumber) -> [Users]? {
        
        
        let group = DispatchGroup()
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "role"
        queryExpression.keyConditionExpression = "#r = :role";
        queryExpression.expressionAttributeNames = ["#r": "role"]
        queryExpression.expressionAttributeValues = [":role": userRole]
        
        var userArray = [Users]()
        
        group.enter()
        dynamoDBObjectMapper.query(Users.self, expression: queryExpression)
        { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            
            if output != nil {
                for user in output!.items {
                    let userItem = user as? Users
                    //print("\(pickItem!._eventDate!)")
                    userArray.append(userItem!)
                }
            }
            group.leave()
        }
        
        
        group.wait()
        return userArray
 
    }
    
    //MARK: PickEvent Methods
    
    //create pick event (V1)
    //Author: Cameron
    /// Creates and uploads a new pick event to the database
    ///
    /// - Parameters:
    ///   - eventTime: the scheduled time for the event, in 24HR format. Format: "HH/MM/SS". **MUST USE** leading 0s for correct query evaluation. Example: "12:30:05" ; "05:05:30"
    ///   - eventDate: the scheduled date for the event, in YYYY/MM/DD format. **MUST USE** leading 0s for correct query evaluation. Example: "2018/06/03"
    ///   - latitude: the latitude for the location of the event
    ///   - longitude: the longitude for the location of the event
    ///   - teamID: the ID string for the team assigned to the pickEvent
    func createPickEvents(eventTime: String, eventDate: String, latitude: NSNumber, longitude: NSNumber, teamID: String, address: String, treeMap: [String:String]){
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> createPickEvent...")
        // Create data object using data models you downloaded from Mobile Hub
        let pickEventItem: PickEvents = PickEvents()
        let userID = AWSIdentityManager.default().identityId
        pickEventItem._userId = userID
        
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

        //this isn't a necessary attribute
        pickEventItem._creationDate = String(year) + "/" + String(month) + "/" + String(day)
        
        pickEventItem._eventTime = eventTime
        pickEventItem._eventDate = eventDate
        
        pickEventItem._latitude = latitude
        pickEventItem._longitude = longitude
        pickEventItem._address = address
        pickEventItem._treeMap = treeMap
        
        //Save a new item
        dynamoDbObjectMapper.save(pickEventItem, completionHandler: {
            (error: Error?) -> Void in

            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("An item was saved.")
        })
        
        //let request = AWSCognitoIdentityProvider()
        
        //request.List
        
        //AWSCognitoIdentityProvider.adminAddUser(<#T##AWSCognitoIdentityProvider#>)
    
    }
    
    
    // create pick event (V2) - same as V1, except strips attributes from
    ///Creates and uploads a new pick event to the database
    ///
    /// - Parameter pickEventItem: event that is to be uploaded, with all relevant parameters except for creationTime, which is set in this function
    ///  - Returns: true if the operation was successful and false otherwise
    func createPickEvents(pickEventItem: PickEvents)-> Bool{
        
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> createPickEvent...")
        // Create data object using data models you downloaded from Mobile Hub
        
        pickEventItem._userId = AWSIdentityManager.default().identityId
        var result = false
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
        
        //this isn't really a necessary attribute, since creationTime stores both anyway
        pickEventItem._creationDate = String(year) + "/" + String(month) + "/" + String(day)
        
        pickEventItem._distanceFrom = nil
        pickEventItem._volunteers = nil
        pickEventItem._teamLead = nil
        let group = DispatchGroup()
        group.enter()

        //Save a new item
        DispatchQueue.global(qos: .userInitiated).async {
            dynamoDbObjectMapper.save(pickEventItem, completionHandler: {
                (error: Error?) -> Void in
                
                if let error = error {
                    print("Amazon DynamoDB Save Error: \(error)")
                    group.leave()
                    return
                }
                group.leave()
                result = true
                print("An item was saved.")
            })
        }
       group.wait()
      return result
    }
    
    // create pick event (V3) - uses primary hash
    ///Call this when wanting to push changes to the database on an existing event
    ///
    /// - Parameter pickEventItem: event that is to be uploaded, with modified attributes, but with _userId and creationTime unmodified
    /// - Returns: error message
    func modifyPickEventsWithHash(pickEventItem: PickEvents) -> String {

        let group = DispatchGroup()
        var result = "success"
        let dynamoDbObjectMapper = AWSDynamoDBObjectMapper.default()
        group.enter()
        print("in DatabaseInterface -> modifyPickEvent...")

        //re-save a new item
        dynamoDbObjectMapper.save(pickEventItem, completionHandler: {
            (error: Error?) -> Void in
            
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                result = error.localizedDescription
                group.leave()
                return
            }
            print("An item was overwritten.")
            group.leave()
        })
        
        group.wait()
        return result
    }
    
    //Author: Cameron
    /// Queries pick events by date and time using FindPick index.
    /// Returns all pick events that are **on** the date AND at or before the time.
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
    
    // can table based on date range
    /// Scans the whole table and returns all items that are **equal to or earlier than** the maxDate parameter
    ///
    /// - Parameters:
    ///   - itemLimit: max number of items returned in the [PickEvents] array
    ///   - maxDate: upper limit date range; **MUST** have leading 0s, be in format YYYY/MM/DD or else string evaluation will be wrong
    /// - Returns: array of PickEvents objects that match scan parameters
    func scanPickEvents(itemLimit: NSNumber, maxDate: String) -> [PickEvents]{
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        var pickArray: [PickEvents] = []
        var queryComplete = false
        
        scanExpression.limit = itemLimit
        scanExpression.indexName = "FindPick"
        scanExpression.filterExpression = "eventDate <= :maxDate"
        //scanExpression.expressionAttributeNames =
        scanExpression.expressionAttributeValues = [":maxDate" : maxDate]
        
        
        dynamoDBObjectMapper.scan(PickEvents.self, expression: scanExpression)  { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
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
        

    }

    
    //Author: Artem
    //MARK: Search for all events user signed-up for
    ///
    /// returns all pick events a current user is signedup for
    /// - Returns: [PickEvents]
    func getMyPickEvents() -> [PickEvents]?{
        let DBIN = DatabaseInterface()
        var events = [PickEvents]()
        guard let userName = DBIN.getUsername()
            else{
                fatalError("userName is nil")
        
        }
        guard let user = DBIN.queryUserInfo(userId: userName)
            else{
                fatalError("user retunrned is nil")
        }
        guard let attributesutes = user._pickEvents
            else{
                print("No pick events for this user")
                return events
        }
        for pick in attributesutes{
            let event = DBIN.readPickEvent(userId: pick[0], creationTime: pick[1])
            if event != nil{
                events.append(event!)}
            
        }
        return events
    }
    
    /// Query database for a specific pickEvent using hash criteria - userId and creationTime
    ///
    /// - Parameters:
    ///   - userId: the userId parameter of the PickEvents object
    ///   - creationTime: the creationTime parameter of the PickEvents object
    /// - Returns: an optional PickEvents? object; if the object is nil, then nothing was found for the submitted criterion or the query timed out
    func readPickEvent(userId: String, creationTime: String) -> PickEvents? {
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        var received: PickEvents?
        var queryComplete = false
        
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #creationTime = :creationTime";
        queryExpression.expressionAttributeNames = ["#userId": "userId", "#creationTime": "creationTime"]
        queryExpression.expressionAttributeValues = [":userId": userId, ":creationTime": creationTime]

            dynamoDBObjectMapper.query(PickEvents.self, expression: queryExpression)
            { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
                if error != nil {
                    print("The request failed. Error: \(String(describing: error))")
                }
                
                if output != nil {
                    for pick in output!.items {
                        let pickItem = pick as? PickEvents
                        //print("\(pickItem!._eventDate!)")
                        received = pickItem
                    }
                }
                
                queryComplete = true;
            }
        
            //waits for query to complete before returning
            while queryComplete == false {
                if queryComplete == true{
                    print("query is finished")
                    queryComplete = false
                    return received //received! != nil
                }
            }
        
        return received //so Xcode stops complaining
    }
    
    /// removes a pick event from the database
    ///
    /// - Parameter PickEvents: the PickEvents object that is to be removed from the table
    /// - Returns: 1 for success, 0 for failure
    
    func deletePickEvent(itemToDelete: PickEvents) -> Int {
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        var ret: Int = 1
        var queryComplete = false
        if itemToDelete._teamLead != nil{
            removeSignUpForPickEvent(pickItem: itemToDelete, userId: itemToDelete._teamLead!)
        }
        if (itemToDelete._volunteers != nil && itemToDelete._volunteers?.count != 0){
            for user in itemToDelete._volunteers! {
                removeSignUpForPickEvent(pickItem: itemToDelete, userId: user)
            }
        }
        dynamoDBObjectMapper.remove(itemToDelete, completionHandler: {(error: Error?) -> Void in
            if let error = error {
                print(" Amazon DynamoDB Save Error: \(error)")
                ret = 0
                return
            }
            print("An item was deleted.")
            ret = 1
            queryComplete = true
        })
        
        while queryComplete == false {
            if queryComplete == true{
                print("query is finished")
                queryComplete = false
                return ret
            }
        }
        
        return ret
        
    }

// MARK: yield data query

/// scans PickEvents table for events within the passed month that are completed, gets a total of their yields
///
/// - Parameters:
///   - year: year as a string, i.e. "2018"
///   - month: month as a two-digit number, i.e. "05", "12"
/// - Returns: an int tuple; position 0: total yield of grade A fruit; position 1: grade B
    func getYieldDataByMonth(year: String, month: String) -> (Int, Int) {
        let group = DispatchGroup()
        
        let dynamoDBObjectMapper = AWSDynamoDBObjectMapper.default()
        print("in DatabaseInterface -> queryPickEventsByDate")
        var yieldA: Int = 0
        var yieldB: Int = 0
        
        let monthStart: String = year + "/" + month + "/" + "01"
        let monthEnd: String = year + "/" + month + "/" + "31"
        
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.indexName = "FindYield"
        //queryExpression.keyConditionExpression = "#eventDate >= :monthStart AND #eventDate <= :monthEnd";
        //queryExpression.keyConditionExpression = "#completed = :complete AND #eventDate BETWEEN :monthStart AND :monthEnd";
        queryExpression.keyConditionExpression = "#completed = :complete AND (#eventDate BETWEEN :monthStart AND :monthEnd)";
        queryExpression.expressionAttributeNames = ["#eventDate": "eventDate", "#completed": "completed"]
        queryExpression.expressionAttributeValues = [":monthStart": monthStart, ":monthEnd": monthEnd, ":complete": "1" ]
        
        group.enter()
        dynamoDBObjectMapper.query(PickEvents.self, expression: queryExpression)
        { (output: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if error != nil {
                print("The request failed. Error: \(String(describing: error))")
            }
            
            if output != nil {
                for pick in output!.items {
                    let pickItem = pick as? PickEvents
                    //print("\(pickItem!._eventDate!)")
                    print("# of items returned: " + String(output!.items.count))
                    
                    //all completed events should have values in yield, so unwrapping should never fail
                    
                    for (_, fruit) in pickItem!._yield! {
                        
                        yieldA += Int(fruit[0])!
                        yieldB += Int(fruit[1])!
                        
                    }
                }
            }
            
            //print("After appeding inside of function: ", pickArray.count)
            group.leave()
        }
        
        group.wait()
        return (yieldA, yieldB)
        
    }

} //end of DatabaseInterface class

/*
 Previous test cases from ViewController:
 
 TestDBScan
 let DBInterface = DatabaseInterface()
 
 let pickArray = DBInterface.scanPickEvents(itemLimit: 20, maxDate: "2018/07/01")
 
 print(pickArray.count)
 for x in pickArray {
 print(x._eventDate!)
 }
 
 TestDBQueryAndDelete
 let DBInterface = DatabaseInterface()
 let userID = AWSIdentityManager.default().identityId!
 print("User #: " + userID)
 
 let pick = DBInterface.readPickEvent(userId: userID , creationTime: "2018/7/1-14:58:33")
 var unwrappedPick: PickEvents
 if pick != nil{
 unwrappedPick = pick!
 print("userID: " + unwrappedPick._userId!)
 print("creationTime: " + unwrappedPick._creationTime!)
 
 }
 
 let result = DBInterface.deletePickEvent(itemToDelete: pick!)
 
 print("Result of delete: " + String(result))
 
 
 TestDBUpload
 let DBInterface = DatabaseInterface();
 
 DBInterface.createPickEvents(eventTime: "16:45", eventDate:"2018/07/01" , latitude: 4000, longitude: 2000, teamID: "2");
 
 let d1 = "2018/07/29"
 let d2 = "2018/12/02"
 let result  = d1 > d2
 print("Evaluation of " + String(d1) + " > "  + String(d2) + " :" + String(result) )
 
 TestDBFetch
 let DBInterface = DatabaseInterface()
 let userID = AWSIdentityManager.default().identityId!
 print("User #: " + userID)
 
 let pick = DBInterface.readPickEvent(userId: userID , creationTime: "2018/7/1-14:58:33")
 
 if pick != nil{
 let unwrappedPick = pick!
 print("userID: " + unwrappedPick._userId!)
 print("creationTime: " + unwrappedPick._creationTime!)
 
 }
 
*/









