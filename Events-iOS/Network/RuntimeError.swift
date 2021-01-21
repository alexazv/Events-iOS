//
//  HeroError.swift
//  Events-iOS
//
//  Created by Alexandre Azevedo on 12/13/20.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}
