//
//  Vancouver_Fruit_Tree_ProjectTests.swift
//  Vancouver-Fruit-Tree-ProjectTests
//
//  Created by Jeff Lee on 2018-08-01.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import XCTest
@testable import Vancouver_Fruit_Tree_Project

class Vancouver_Fruit_Tree_ProjectTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //Logical test: tests if the sorting methods return the correct value
    /// Pass if number == 1
    /// Fail if number != 1
    func testLeaderboadSorting()  {
        let testVC = LeaderBoardViewController()
        let number = 1
        let array = [3, 2, 1, 5]
        XCTAssertTrue(testVC.testableSortLeader(arrIn: array, n: number))
    }
    
    //Ｌoads username as an example to test if database connection is working
    func testUsernameLoaded() {
        let testVC = DatabaseInterface()
        let testUsername = testVC.getUsername()
        XCTAssertNotNil(testUsername)
    }
    
    func testUserEmailLoaded() {
        let testVC = DatabaseInterface()
        let testEmail = testVC.getEmail()
        XCTAssertNotNil(testEmail)
    }
    
    

    
    func testPerformance() {
        // This is an example of a performance test case.
        let testvw = MyPicksTableViewController()
        
        self.measure {
            testvw.loadMyPicks()
        }
        
       
    }
    
}
