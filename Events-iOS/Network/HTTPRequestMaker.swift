//
//  HTTPRequestMaker.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation
import Alamofire

class HTTPRequestMaker: RequestMaker {
    func request(_ url: String, parameters: [String : Any], completion: @escaping (Data?, Error?) -> Void) {
        AF.request(url, method: .get, parameters: parameters as Parameters)
            .validate(statusCode: 200..<300)
            .response { response in
            
                guard response.error == nil else {
                    completion(nil, response.error)
                    return
                }
                
                guard let data = response.data else {
                    completion(nil, RuntimeError("error"))
                    return
                }
                
                completion(data, nil)
            }
    }
}
