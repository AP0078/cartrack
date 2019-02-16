//
//  CartrackTests.swift
//  CartrackTests
//
//  Created by Aung Phyoe on 15/2/19.
//  Copyright © 2019 Aung Phyoe. All rights reserved.
//

import XCTest
@testable import Cartrack

class CartrackTests: XCTestCase {
    var countryList: [Country]?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        MockDataHelper.shared.fetchMockData { (complete) in
            self.countryList = MockDataHelper.shared.getCountryList()
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        countryList = nil
    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssertNotNil(self.countryList)
    }

    func test_successLogin() {
        // This is an example of a functional test case.
       let success = MockDataHelper.shared.validateUser(name: "user01", password: "user01", location: "Singapore")
        XCTAssertTrue(success)
        
    }
    func test_failLogin() {
        // This is an example of a functional test case.
        let success = MockDataHelper.shared.validateUser(name: "ddd", password: "dddd", location: "Singapore")
        XCTAssertFalse(success)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
