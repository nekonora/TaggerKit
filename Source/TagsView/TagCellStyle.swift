//
//  TagCellStyle.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import UIKit

/// An object defining the style for a tag cell in a `TagsView` instance
@available(iOS 13, *)
public struct TagCellStyle {
    
    /// The action to execute when the button of tag is tapped
    public enum TagActionType { case add, remove }
    
    public var font: UIFont
    public var fontColor: UIColor
    public var backgroundColor: UIColor
    
    public var tagCellHeight: CGFloat
    public var tagsSpacing: CGFloat
    public var cornerRadius: CGFloat
    public var borderSize: CGFloat
    public var borderColor: UIColor
    
    public var action: TagActionType?
    public var customActionImage: UIImage?
    
    public init(font: UIFont = .boldSystemFont(ofSize: 14),
                fontColor: UIColor = .systemBackground,
                backgroundColor: UIColor = .systemRed,
                tagCellHeight: CGFloat = 30,
                tagsSpacing: CGFloat = 8,
                cornerRadius: CGFloat = 15,
                borderSize: CGFloat = 0,
                borderColor: UIColor = .systemBackground,
                action: TagActionType? = nil,
                customActionImage: UIImage? = nil) {
        self.font = font
        self.fontColor = fontColor
        self.backgroundColor = backgroundColor
        self.tagCellHeight = tagCellHeight
        self.tagsSpacing = tagsSpacing
        self.cornerRadius = cornerRadius
        self.borderSize = borderSize
        self.borderColor = borderColor
        self.action = action
        self.customActionImage = customActionImage
    }
}
