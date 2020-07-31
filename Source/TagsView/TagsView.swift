//
//  TKView.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 05/10/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

@available(iOS 13, *)
public class TagsView: UIView {
    
    // MARK - Types
    enum SelectionMode { case none, single, multiple }
    
    // MARK: - Public properties
    // Read only
    var tags: [String] { tagsCollection?.tags ?? [] }
    var selectedTag: String? { tagsCollection?.selectedTag }
    var selectedTags: [String] { tagsCollection?.selectedTags ?? [] }
    var filteredTags: [String] { tagsCollection?.filteredTags ?? [] }
    
    // Settable
    var isBouncingEnabled = false { didSet { updateBouncing() } }
    var selectionMode = SelectionMode.single
    
    var tagStyle = TagCellStyle() { didSet { collectionView?.reloadData() } }
    var tagsAlignment = TagCellLayout.LayoutAlignment.left { didSet { updateLayout() } }
    
    // MARK: - Private properties
    private var tagCellLayout: TagCellLayout?
    
    internal var collectionView: UICollectionView?
    internal var tagsCollection: TagsCollection?
    
    // MARK: - Actions
    var onTagButtonTapped: ((String) -> ())?
    var onTagSelected: ((String) -> ())?
    var onTagDeselected: ((String) -> ())?
    
    var onTagAdded: ((String) -> ())?
    var onTagRemoved: ((String) -> ())?
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - Methods
    
    public func addTag(_ tag: String) {
        tagsCollection?.tags.append(tag)
    }
    
    public func removeTag(_ tag: String) {
        tagsCollection?.tags.removeAll { $0 == tag }
    }
}

// MARK: - Updates
private extension TagsView {
    
    func updateLayout() {
        let layout: TagCellLayout = {
            let _layout = TagCellLayout(alignment: tagsAlignment, delegate: self)
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
        let layout: TagCellLayout = {
            let _layout = TagCellLayout(alignment: tagsAlignment, delegate: self)
            _layout.delegate = self
            return _layout
        }()
        
        let collection: UICollectionView = {
            let _collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
            _collectionView.dataSource = self
            _collectionView.delegate = self
            _collectionView.alwaysBounceVertical = isBouncingEnabled
            _collectionView.backgroundColor = UIColor.clear
            _collectionView.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
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
    
    func setupLayout() -> UICollectionViewLayout {
        let estimatedHeight: CGFloat = topicsCellCollectionHeight
        let estimatedWidth: CGFloat = 200
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .absolute(estimatedHeight))
        //height is absolute because I know it, and in some cases-not in this one, though-I have to calculate the height of UICollectionView
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .fixed(0), top: .fixed(8), trailing: .fixed(8), bottom: .fixed(8))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
