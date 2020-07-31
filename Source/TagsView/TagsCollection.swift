//
//  TagCollection.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 27/02/2020.
//

internal class TagsCollection {
    
    // MARK: - Properties
    var tags = [String]()

    var selectedTag: String?
    var selectedTags = [String]()
    var filteredTags = [String]()
    
    // MARK: - Init
    required init(initialTags: [String]) {
        self.tags = initialTags
    }
    
    // MARK: - Methods
    func filterFor(_ string: String) {
        filteredTags = tags.filter { $0.contains(string) }
    }
    
    func selectTag(_ tag: String) {
        
    }
}
