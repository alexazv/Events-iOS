//
//  EventDataSource.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import RxSwift

protocol EventDataSource {
    func getEvents() -> Single<[Event]>
    func getEvent(eventId: String) -> Single<Event>
    func confirmEvent(eventId: String, name: String, email: String) -> Completable
}
