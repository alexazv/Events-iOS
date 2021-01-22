//
//  DataSource.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation

class DataSource {
    static private var mock = false
    static private var returnError = false

    static func eventDataSource() -> EventDataSource {
        if mock {
            return EventAPISource(requestMaker: MockEventRequestMaker(returnError: returnError))
        } else {
            return EventAPISource()
        }
    }
}
