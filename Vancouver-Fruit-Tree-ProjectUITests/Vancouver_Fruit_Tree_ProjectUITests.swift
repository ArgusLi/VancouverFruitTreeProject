//
//  Vancouver_Fruit_Tree_ProjectUITests.swift
//  Vancouver-Fruit-Tree-ProjectUITests
//
//  Created by Artem Gromov on 2018-06-12.
//  Copyright © 2018 Harvest8. All rights reserved.
//

import XCTest
import AWSAuthCore
import AWSAuthUI
import AWSGoogleSignIn
import SideMenu
class Vancouver_Fruit_Tree_ProjectUITests: XCTestCase {
    
    override func setUp() {
       super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test all essential sections in the side menu
    // Pass - if all are place correctly
    // Fail - if one of them is missing
    /*func testSideMenuSections() {
        
        let app = XCUIApplication()
        let itemButton = app.navigationBars["Vancouver_Fruit_Tree_Project.View"].buttons["Item"]
        itemButton.tap()
        
        let tablesQuery = app.tables
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Available Picks"]/*[[".cells.staticTexts[\"Available Picks\"]",".staticTexts[\"Available Picks\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["My Picks"]/*[[".cells.staticTexts[\"My Picks\"]",".staticTexts[\"My Picks\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["My Account"]/*[[".cells.staticTexts[\"My Account\"]",".staticTexts[\"My Account\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
        XCTAssert(tablesQuery/*@START_MENU_TOKEN@*/.cells.staticTexts["Leaderboard"]/*[[".cells.staticTexts[\"Leaderboard\"]",".staticTexts[\"Leaderboard\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.exists)
    }*/
    
}

