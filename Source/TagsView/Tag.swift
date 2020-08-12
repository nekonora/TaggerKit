//
//  Tag.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 31/07/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import Foundation

/// Conforming to this protocol will enable an object to be used to create a tag
@available(iOS 13, *)
public protocol TagExpressable {
    
    /// The name that identifies the tag and will be shown as the tag label
    var tagName: String { get }
}

@available(iOS 13, *)
public struct Tag: Hashable, Equatable {

    /// The unique identifier of the tag
    public let id: UUID
    /// The name of the tag, as well as the string shown in the tag's own label
    public let name: String
    
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Creates a new tag from an object conforming to `TagExpressable`
    public init(from tagObject: TagExpressable) {
        self.id = UUID()
        self.name = tagObject.tagName
    }
}
