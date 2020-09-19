//
//  SingleTagViewVC.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 03/13/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import TaggerKit
import Combine

/// Example of a TagsView using combine on iOS 13
///
@available(iOS 13, *)
class SingleTagViewVC: UIViewController {
    
    // MARK: - Outlets
    /// The view storing a complete collection of our tags
    @IBOutlet private var tagsView: TagsView!
    /// The view which will display selected tags
    @IBOutlet private var destinationTagsView: TagsView!
    
    @IBOutlet private var textField: UITextField!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    /// Example array of tags
    private let tags = ["Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Sports"].map { Tag(from: $0) }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTags()
    }
    
    private func setupTags() {
        // We specify a custom style, providing an image to be placed inside tags
        tagsView.tagStyle = TagCellStyle(action: .add, customActionImage: UIImage(systemName: "plus.circle.fill"))
        
        tagsView.setTags(tags)
        
        // We subscribe to the `$selectedTag` publisher in order to act upon a selection, on which we add
        // the selected tag to `destinationTagsView`
        tagsView.$selectedTag
            .sink { if let selectedTag = $0 { self.destinationTagsView.addTags([selectedTag]) } }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    /// Filtering example: filter by textfield's text
    @IBAction private func textFieldTextDidChange(_ sender: UITextField) {
        if let filterTerm = sender.text, !filterTerm.isEmpty {
            tagsView.setTags(tags.filter { $0.name.lowercased().contains(filterTerm) })
        } else {
            tagsView.setTags(tags)
        }
    }
}

// MARK: - UITextFieldDelegate
@available(iOS 13, *)
extension SingleTagViewVC: UITextFieldDelegate {
    
    /// Filtering example: clearing filter
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        tagsView.setTags(tags)
        return true
    }
}
