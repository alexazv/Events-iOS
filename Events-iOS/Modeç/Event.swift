//
//  Event.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation

import Foundation
import ObjectMapper

class Event: Mappable {
    var eventId: String?
    var title: String?
    var date: Date?
    var description: String?
    var imageUrl: URL?
    var latitude: Double?
    var longitude: Double?
    var price: Float?
    
    var dateString: String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()

        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "pt-br")
        return dateFormatter.string(from: date)
    }
    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
        eventId <- map["id"]
        title <- map["title"]
        description <- map["description"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        price <- map["price"]
        
        var dateEpoch: Int?
        dateEpoch <- map["date"]
        if let dateEpoch = dateEpoch {
          date = Date(timeIntervalSince1970: Double(dateEpoch))
        }
        
        var path: String = ""
        path <- map["image"]
        imageUrl = URL(string: path)
    }
}
