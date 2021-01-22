//
//  RequestMaker.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import ObjectMapper

protocol RequestMaker {
    func get(_ url: String, parameters: [String: Any], completion: @escaping (Data?, Error?) -> Void)
    func post(_ url: String, parameters: [String: Any], completion: @escaping (Data?, Error?) -> Void)
}
