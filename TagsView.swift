//
//  TKView.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 05/10/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

public class TagsView: UIView {
    
    // MARK - Types
    
    enum SelectionMode { case none, single, multiple }
    
    // MARK: - Public properties
    
    // Read only
    
    var selectedTag: String? { tagsCollection?.selectedTag }
    var selectedTags: [String] { tagsCollection?.selectedTags ?? [] }
    var filteredTags: [String] { tagsCollection?.filteredTags ?? [] }
    
    // Settable
    
    var isBouncingEnabled: Bool = false { didSet { updateBouncing() } }
    
    var tagsAlignment: TagCellLayout.LayoutAlignment = .left { didSet { updateLayout() } }
    
    // MARK: - Private properties
    
    private(set) var selectionMode: SelectionMode?
    private(set) var style: TKTagStyle?
    
    private var tagCellLayout: TagCellLayout?
    
    internal var collectionView: UICollectionView?
    internal var tagsCollection: TagsCollection?
    
    // MARK: - Actions
    
    var onTagButtonTapped: ((String) -> ())?
    var onTagSelected: ((String) -> ())?
    var onTagDeselected: ((String) -> ())?
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

// MARK: - Updates

private extension TagsView {
    
    func updateLayout() {
        let layout: TagCellLayout = {
            let _layout      = TagCellLayout(alignment: tagsAlignment, delegate: self)
            _layout.delegate = self
            return _layout
        }()
        
        collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
    func updateBouncing() {
        collectionView?.alwaysBounceVertical = isBouncingEnabled
    }
}

// MARK: - Setup

private extension TagsView {
    
    func commonInit() {
        tagsCollection = TagsCollection(initialTags: ["Ciao", "hey"])
        
        let layout: TagCellLayout = {
            let _layout      = TagCellLayout(alignment: .left, delegate: self)
            _layout.delegate = self
            return _layout
        }()
        
        let collection: UICollectionView = {
            let _collectionView                  = UICollectionView(frame: bounds, collectionViewLayout: layout)
            _collectionView.dataSource           = self
            _collectionView.delegate             = self
            _collectionView.alwaysBounceVertical = false
            _collectionView.backgroundColor      = UIColor.clear
            _collectionView.register(TKTagCell.self, forCellWithReuseIdentifier: "TagCell")
            return _collectionView
        }()
        
        addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        let anchors = [
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        anchors.forEach { $0.isActive = true }
        collectionView = collection
    }
}
