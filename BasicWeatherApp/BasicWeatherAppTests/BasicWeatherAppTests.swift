//
//  BasicWeatherAppTests.swift
//  BasicWeatherAppTests
//
//  Created by MIJIN JEON on 01/08/2019.
//  Copyright © 2019 MIJIN JEON. All rights reserved.
//

import XCTest
@testable import BasicWeatherApp

class BasicWeatherAppTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_isPast() {
        let timeNow = Date()
        let timeCompare = "2019-07-31 00:00:00".convertDate
        let result = timeCompare?.isFuture(from: timeNow)
        XCTAssertFalse(result!)
    }

}
