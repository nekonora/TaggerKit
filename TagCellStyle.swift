//
//  TagCellStyle.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//

import UIKit

/// An object defining the style for a tag cell in a tag collection
public struct TagCellStyle {
    
    /// The action to execute when the button of tag is tapped
    enum TagActionType { case add, remove }
    
    var font: UIFont?             = .boldSystemFont(ofSize: 14)
    var fontColor: UIColor?       = .white
    var backgroundColor: UIColor? = .systemRed
    
    var tagCellHeight: CGFloat? = 30
    var tagsSpacing: CGFloat?   = 8
    var cornerRadius: CGFloat?  = 15
    var borderSize: CGFloat?    = 0
    var borderColor: UIColor?   = .black
    
    var action: TagActionType? = .add
    var customActionImage: UIImage? 
}
