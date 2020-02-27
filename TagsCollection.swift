//
//  TagCollection.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 27/02/2020.
//

internal class TagsCollection {
    
    // MARK - Properties

    var tags = [String]() { didSet { onTagsUpdated?() } }

    var selectedTag: String?
    var selectedTags = [String]()
    var filteredTags = [String]()
    
    private var onTagsUpdated: (() -> ())?
    
    // MARK - Init
    
    required init(initialTags: [String], onUpdate: (() -> ())? = nil) {
        self.tags          = initialTags
        self.onTagsUpdated = onUpdate
    }
    
    // MARK - Methods
    
    func filterFor(_ string: String) {
        filteredTags = tags.filter { $0.contains(string) }
    }
}
