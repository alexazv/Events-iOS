//
//  NetworkTest.swift
//  Events-iOSTests
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking

@testable import Events_iOS

class NetworkTest: XCTestCase {

    var systemUnderTest: EventDataSource!
    let disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        systemUnderTest = EventAPISource(requestMaker: MockEventRequestMaker())
    }
    
    func testGetItems() {
        systemUnderTest = EventAPISource(requestMaker: MockEventRequestMaker(returnError: false))
        let expectation = XCTestExpectation(description: "response")
        systemUnderTest.getEvents().subscribe(
            onSuccess: { events in
                XCTAssertGreaterThan(events.count, 0)
                expectation.fulfill()
            }, onFailure: { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }).disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 2)
    }
    
    func testfowardsError() {
        systemUnderTest = EventAPISource(requestMaker: MockEventRequestMaker(returnError: true))
        let expectation = XCTestExpectation(description: "response")
        systemUnderTest.getEvents().subscribe(
            onFailure: { error in
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        ).disposed(by: disposeBag)

        wait(for: [expectation], timeout: 2)
    }
}
