//
//  EngineTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/13/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import XCTest
@testable import DyPhotos

class EngineTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMyFeed() {
        
        let expectation = expectationWithDescription("Test myFeed")
        
        Engine.shared.myFeed(nil) { (result, error) -> () in
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testSearchLocations() {
        
        let expectation = expectationWithDescription("Test searchLocation")
        
        Engine.shared.searchLocations(-6.876569, longitude: 107.584254) { (result, error) -> () in
            
            if let _ = result as? [[String: AnyObject]] {
                expectation.fulfill()
            }
            else if let _ = error {
                expectation.fulfill()
            }
            else {
                expectation.fulfill()
            }
        }
        
        waitForExpectationsWithTimeout(10) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPhotosAroundLocation() {
        
        let expectation = expectationWithDescription("Test photosAroundLocation")
        
        Engine.shared.photosAroundLocation("", maxId: nil, completion: { (result, error) -> () in
            
            if let result = result {
                if result is [PhotoAroundLocation] {
                    expectation.fulfill()
                }
                else {
                    XCTAssert(false, "The result not [PhotoAroundLocation]")
                }
            }
            else if let _ = error {
                expectation.fulfill()
            }
            else {
                expectation.fulfill()
            }
        })
        
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
