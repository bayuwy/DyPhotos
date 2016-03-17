//
//  StringExtensionTests.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/12/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import XCTest
@testable import DyPhotos

class StringExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testMd5() {
        let md5Hash = "Hello, World!".md5
        XCTAssertEqual(md5Hash, "65a8e27d8879283831b664bd8b7f0ad4")
    }

}
