//
//  ViewController.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 03/13/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import TaggerKit
import Combine

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private var tagsView: TagsView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tags = ["Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Sports"]
        
        tagsView.selectionMode = .multiple
        
        tagsView.addTags(tags.map { Tag(from: $0) })
        
        tagsView.$selectedTag
            .sink { if let selectedTag = $0 { print(selectedTag.name) } }
            .store(in: &cancellables)

        tagsView.$selectedTags
            .sink { if $0.count > 0 { print($0.map { $0.name } ) } }
            .store(in: &cancellables)
    }
}
