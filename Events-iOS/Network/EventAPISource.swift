//
//  EventAPISource.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import Alamofire
import ObjectMapper
import RxSwift

class EventAPISource: EventDataSource {

    private let requestMaker: RequestMaker
    private let baseUrl = "http://5f5a8f24d44d640016169133.mockapi.io/api/"

    init(requestMaker: RequestMaker? = nil) {
        guard let requestMaker = requestMaker else {
            self.requestMaker = HTTPRequestMaker()
            return
        }
        self.requestMaker = requestMaker
    }

    private func decode<T: Mappable>(_ type: T.Type, from data: Data) throws -> T? {
        let json = try JSONSerialization.jsonObject(with: data,
                                                    options: []) as? [String: Any]
        let item = Mapper<T>().map(JSONObject: json)
        return item
    }

    private func decodeArray<T: Mappable>(_ type: T.Type, from data: Data) throws -> [T]? {
        let json = try JSONSerialization.jsonObject(with: data,
                                                    options: JSONSerialization.ReadingOptions()) as? [[String: Any]]
        let item = Mapper<T>().mapArray(JSONObject: json)
        return item
    }

    func getEvents() -> Single<[Event]> {

        let url = "\(self.baseUrl)events"

        return Single.create { observer in
            let disposable = Disposables.create()

            self.requestMaker.get(url, parameters: [:]) { data, error in

                if let error = error {
                    observer(.failure(error))
                    return
                }

                guard let data = data else {
                    observer(.failure(RuntimeError("No data")))
                    return
                }

                do {
                    let events = try self.decodeArray(Event.self, from: data)
                    observer(.success(events ?? []))
                } catch let error {
                    observer(.failure(error))
                }
            }

            return disposable
        }
    }

    func getEvent(eventId: String) -> Single<Event> {

        let url = "\(self.baseUrl)events/\(eventId)/"

        return Single.create { observer in
            let disposable = Disposables.create()

            self.requestMaker.get(url, parameters: [:]) { data, error in

                if let error = error {
                    observer(.failure(error))
                    return
                }

                guard let data = data else {
                    observer(.failure(RuntimeError("No data")))
                    return
                }

                do {
                    let event: Event = try self.decode(Event.self, from: data)!
                    observer(.success(event))
                } catch let error {
                    observer(.failure(error))
                }
            }

            return disposable
        }
    }

    func confirmEvent(eventId: String, name: String, email: String) -> Completable {
        let url = "\(self.baseUrl)checkin/"

        let parameters: [String: Any] = [
            "eventId": eventId,
            "name": name,
            "email": email
        ]

        return Completable.create { observer in
            let disposable = Disposables.create()

            self.requestMaker.post(url, parameters: parameters) { _, error in

                if let error = error {
                    observer(.error(error))
                    return
                }

                observer(.completed)
            }

            return disposable
        }
    }
}
