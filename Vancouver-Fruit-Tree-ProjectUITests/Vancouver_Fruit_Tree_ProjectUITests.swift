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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Available Picks"]/*[[".cells.staticTexts[\"Available Picks\"]",".staticTexts[\"Available Picks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.alerts["Allow “VFTP” to access your location while you are using the app?"].buttons["Allow"].tap()
        
        
      
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
    }
    
}
