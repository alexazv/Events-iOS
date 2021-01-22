//
//  EventFeedViewControllerTest.swift
//  Events-iOSTests
//
//  Created by Alexandre Azevedo on 22/01/21.
//

import XCTest
@testable import Events_iOS

class EventFeedViewControllerTest: XCTestCase {

    var systemUnderTest: EventFeedViewController?

    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "EventFeedViewController")
            as? EventFeedViewController
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSUT_CanInstantiateViewController() {
        XCTAssertNotNil(systemUnderTest)
    }

    func testSUT_TableViewIsNotNilAfterViewDidLoad() {
        XCTAssertNotNil(systemUnderTest?.tableView)
    }

    func testSUT_ShouldSetTableViewDataSource() {
        XCTAssertNotNil(systemUnderTest?.tableView?.dataSource)
    }

    func testSUT_ConformsToTableViewDataSource() {
        XCTAssert(systemUnderTest.self?.conforms(to: UITableViewDataSource.self) ?? false)
        XCTAssert(systemUnderTest?.responds(to:
                                                #selector(systemUnderTest?.tableView(
                                                _:numberOfRowsInSection:))) ?? false)
        XCTAssert(systemUnderTest?.responds(to: #selector(systemUnderTest!.tableView(_:cellForRowAt:))) ?? false)
    }

    func testSUT_ShouldSetTableViewDelegate() {

        XCTAssertNotNil(systemUnderTest?.tableView?.delegate)
    }

    func testSUT_ConformsToTableViewDelegate() {
        XCTAssert(systemUnderTest.self?.conforms(to: UITableViewDelegate.self) ?? false)
        XCTAssert(systemUnderTest?.responds(to: #selector(systemUnderTest?.tableView(_:didSelectRowAt:))) ?? false)
    }
}
