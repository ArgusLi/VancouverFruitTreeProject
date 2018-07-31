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
        
        //test if adding a new available pick works
        let app = XCUIApplication()
        app.navigationBars["Vancouver_Fruit_Tree_Project.View"].buttons["Item"].tap()
        
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Available Picks"]/*[[".cells.staticTexts[\"Available Picks\"]",".staticTexts[\"Available Picks\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Available Picks"].buttons["Add"].tap()
        app.buttons["Enter the address"].tap()
        app.searchFields["Enter Adress"].tap()
        app/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["4348 Main St, Vancouver BC"]/*[[".cells.staticTexts[\"4348 Main St, Vancouver BC\"]",".staticTexts[\"4348 Main St, Vancouver BC\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Vancouver_Fruit_Tree_Project.SearchLocationTableView"].buttons["Back"].tap()
        app.datePickers.pickerWheels["1 o’clock"]/*@START_MENU_TOKEN@*/.press(forDuration: 0.5);/*[[".tap()",".press(forDuration: 0.5);"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let element = app.otherElements.containing(.navigationBar, identifier:"Vancouver_Fruit_Tree_Project.AddPickEventView").children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .other).element(boundBy: 0).steppers.buttons["Increment"].tap()
        element.children(matching: .other).element(boundBy: 1).steppers.buttons["Increment"].tap()
        app/*@START_MENU_TOKEN@*/.pickerWheels["none"].press(forDuration: 0.6);/*[[".pickers.pickerWheels[\"none\"]",".tap()",".press(forDuration: 0.6);",".pickerWheels[\"none\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        app.buttons["Save"].tap()
        app.alerts["Event Saved Successfully"].buttons["Ok"].tap()
      
    
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
    }
    
}
