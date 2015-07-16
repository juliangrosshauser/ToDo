//
//  ToDoUITests.swift
//  ToDoUITests
//
//  Created by Julian Grosshauser on 16/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import XCTest

class ToDoUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        XCUIApplication().launch()
    }
}
