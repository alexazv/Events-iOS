//
//  HeroAPISource.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 12/13/20.
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
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
        let item = Mapper<T>().map(JSONObject: json)
        return item
    }
    
    private func decodeArray<T: Mappable>(_ type: T.Type, from data: Data) throws -> [T]? {
        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [[String : Any]]
        let item = Mapper<T>().mapArray(JSONObject: json)
        return item
    }
    
    func getEvents() -> Single<[Event]> {
        
        let url = "\(self.baseUrl)events"
        
        return Single.create { observer in
            let disposable = Disposables.create()
            
            self.requestMaker.request(url, parameters: [:]) { data, error in
                
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
                    observer(.success(events ?? []));
                } catch let error {
                    observer(.failure(error));
                }
            }
            
            return disposable
        }
    }
    
    func getEvent(id: String) -> Single<Event> {
        
        let url = "\(self.baseUrl)events/\(id)/"
        
        return Single.create { observer in
            let disposable = Disposables.create()
            
            self.requestMaker.request(url, parameters: [:]) { data, error in
                
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
                    observer(.success(event));
                } catch let error {
                    observer(.failure(error));
                }
            }
            
            return disposable
        }
    }
}
