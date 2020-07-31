//
//  Tag.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 31/07/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import Foundation

@available(iOS 13, *)
public protocol TagExpressable {
    
    var tagName: String { get }
}

@available(iOS 13, *)
public struct Tag: Hashable, Equatable {

    public let id: UUID
    public let name: String
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(from tagObject: TagExpressable) {
        self.id = UUID()
        self.name = tagObject.tagName
    }
}
