//
//  String+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 31/07/2020.
//

import Foundation

/// Providing String conformance to `TagExpressable` makes it easy to create an array of tags
/// from an array of strings
extension String: TagExpressable {
    
    public var tagName: String {
        self
    }
}
