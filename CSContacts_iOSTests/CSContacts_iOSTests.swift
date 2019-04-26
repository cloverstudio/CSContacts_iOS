//
//  CSContacts_iOSTests.swift
//  CSContacts_iOSTests
//
//  Created by Vedran on 26/04/2019.
//  Copyright © 2019 Vedran. All rights reserved.
//

import XCTest
import RxSwift
@testable import CSContacts_iOS

class CSContacts_iOSTests: XCTestCase {

    override func setUp() {
        let mockData = Observable.of([PhoneContact(phoneIdentifier: "test",
                                                                     serverId: "test2",
                                                                     name: "John Doe",
                                                                     email: nil,
                                                                     phoneNumbers: ["1111"])])
        CSContactsProvider.instance.startWithMockContacts(contacts: mockData)
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

}
