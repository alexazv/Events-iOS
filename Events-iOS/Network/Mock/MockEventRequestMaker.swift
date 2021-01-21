//
//  MockRequestMaker.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 21/01/21.
//

import Foundation

class MockEventRequestMaker: RequestMaker {
    
    private var returnError: Bool
    
    init(returnError: Bool = false) {
        self.returnError = returnError
    }
    
    func get(_ url: String, parameters: [String : Any], completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.main.async {
            
            guard !self.returnError else {
                completion(nil, RuntimeError("Mock error"))
                return
            }
            
            guard let path = Bundle.main.path(forResource: "MockEvents", ofType: "json") else {
                completion(nil, RuntimeError("File not found"))
                return
            }
            
            let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            completion(data, nil)
        }
    }
    
    func post(_ url: String, parameters: [String : Any], completion: @escaping (Data?, Error?) -> Void) {
        completion(nil, RuntimeError("No implementation"));
    }
}
