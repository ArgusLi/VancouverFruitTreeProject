//
//  Vancouver_Fruit_Tree_ProjectTests.swift
//  Vancouver-Fruit-Tree-ProjectTests
//
//  Created by Artem Gromov on 2018-06-12.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import XCTest
@testable import Vancouver_Fruit_Tree_Project

class Vancouver_Fruit_Tree_ProjectTests: XCTestCase {
    
    let DBInterface = DatabaseInterface()
    
    override func setUp() {
        super.setUp()
        /*
        // Trying createPickEvents
        DBInterface.createPickEvents(eventTime:"01:01:01", eventDate:"0001/01/01", latitude:1, longitude:2, teamID: "1")
        */
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUserClass() {
       
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    /*
    func testDatabaseInterface() {
        var pickEvents = [PickEvents]()
        // Trying createPickEvents
        pickEvents = DBInterface.queryPickEventsByDate(date: "1/1/1", time: "1:1:1")
        XCTAssertEqual(pickEvents[0]._assignedTeamID, "1", "TeamID Wrong")
        XCTAssertEqual(pickEvents[0]._latitude, 1, "Latitude Wrong")
        XCTAssertEqual(pickEvents[0]._longitude, 2, "Longitude Wrong")
        // Trying deletePickEvent
        XCTAssertEqual(DBInterface.deletePickEvent(itemToDelete: pickEvents[0]), 1, "Delete Failed")
    }
    */
}
