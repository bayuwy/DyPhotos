//
//  EngineTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 12/13/16.
//  Copyright © 2016 DyCode. All rights reserved.
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
        
        let expextation = self.expectation(description: "Test myFeed")
        
        Engine.shared.myFeed(nil) { (result, error) in
            
            if result != nil {
                XCTAssertTrue(result is [Photo])
            }
            else if let error = error {
                XCTAssert(false, error.localizedDescription)
            }
            else {
                XCTFail()
            }
            
            expextation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func testMapPhotos() {
        
        let url = Bundle(for: type(of: self)).url(forResource: "ValidJson", withExtension: "json")!
        let data = try? Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
        
        let photos = Engine.shared.mapPhotos(from: json)
        
        XCTAssertTrue(photos.count > 0)
    }
    
}
