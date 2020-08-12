//
//  TKTagsCollection.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 05/10/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

protocol TKTagsCollectionManager: class {
    
    func collectionDidUpdateTags()
}

/// An object managing a collection of tags
@available(iOS, deprecated: 13.0, message: "'TagsView' is now available.")
public class TKTagsCollection {
    
    // MARK - Properties
    
    private var manager: TKTagsCollectionManager!

    /// The current tags in the collection
    var tags = [String]() { didSet { manager.collectionDidUpdateTags() } }

    /// The selected tag in a collection with selection mode = .single
    var selectedTag: String?
    
    /// The selected tags in a collection with selection mode = .multiple
    var selectedTags = [String]()
    
    /// The tags filtered by the method "filterFor:String"
    var filteredTags = [String]()
    
    private var onTagsUpdated: (() -> ())?
    
    // MARK - Init
    
    /// Initializes a tag collection object with given parameters
    /// - Parameters:
    ///   - initialTags: the tags initially present in the collection
    ///   - readOnly: (optional) if true the tags can not be added or removed, default false
    ///   - selectionMode: (optional) whether the user can select one, more than one or no tags, default none
    ///   - style: (optional) a style object that can customize the look of the tags in the collection
    required init(initialTags: [String], manager: TKTagsCollectionManager, onUpdate: (() -> ())?) {
        self.manager       = manager
        self.tags          = initialTags
        self.onTagsUpdated = onUpdate
    }
    
    // MARK - Methods
    
    /// Updates the collection's tags
    /// - Parameter string: the string that could be contained in some of the collection's tags
    func filterFor(_ string: String) {
        filteredTags = tags.filter { $0.contains(string) }
    }
}
