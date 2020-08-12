//
//  String+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 31/07/2020.
//

import Foundation

// Providing String conformance to TagExpressable makes it easy to use array of strings as tags
extension String: TagExpressable {
    
    public var tagName: String {
        self
    }
}
