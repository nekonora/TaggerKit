//
//  TKTextField.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

/// This text field can be used to create new tags (send them to a receiver) or filter tags in a (sender) collection of tags
public class TKTextField: UITextField {
    
    // MARK: - Properties
    
    // Objects to operate - obviously should not be the same
    
    /// A collection view of tags that can be sent to a receiver collection
    public var sender: TKCollectionView? { didSet { allTags = sender?.tags } }
    
    /// A collection view of tags that receives tags from other senders
    public var receiver: TKCollectionView?
    
    var allTags: [String]!
    
    // Style
    fileprivate let defaultBackgroundColor 	= UIColor(red: 1.00, green: 0.80, blue: 0.37, alpha: 1.0)
    fileprivate let defaultCornerRadius 	= CGFloat(14.0)
    
    // MARK: - Lifecycle Methods
    
    public override func awakeFromNib() {
        setupView()
        
        addTarget(self, action: #selector(addingTags), for: .editingChanged)
        addTarget(self, action: #selector(pressedReturn), for: .editingDidEndOnExit)
        
        super.awakeFromNib()
    }
    
    // MARK: - Class Methods
    fileprivate func setupView() {
        clipsToBounds 		= true
        layer.cornerRadius 	= defaultCornerRadius
        backgroundColor 	= defaultBackgroundColor
        
        clearButtonMode 	= .whileEditing
        
        placeholder 		= "Create a tag"
    }
    
    // MARK: - TextField methods
    
    @objc fileprivate func addingTags() {
        guard let sender = sender, let text = text else { return }
        
        let filteredStrings = allTags.filter({(item: String) -> Bool in
            let stringMatch = item.lowercased().range(of: text.lowercased())
            return stringMatch != nil ? true : false
        })
        
        if filteredStrings.isEmpty {
            if text.isEmpty {
                sender.tags = allTags
                sender.tagsCollectionView.reloadData()
            } else {
                sender.tags = ["\(text)"]
                sender.tagsCollectionView.reloadData()
            }
            
        } else {
            sender.tags = filteredStrings
            sender.tagsCollectionView.reloadData()
        }
        
    }
    
    @objc fileprivate func pressedReturn() {
        guard let sender = sender, let text = text else { return }
        sender.addNewTag(named: text)
    }
}
