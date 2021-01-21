//
//  RequestMaker.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import ObjectMapper

protocol RequestMaker {
    func request(_ url: String, parameters: [String:Any], completion: @escaping (Data?, Error?) -> Void)
}
