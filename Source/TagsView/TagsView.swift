//
//  TKView.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 05/10/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import Combine

@available(iOS 13, *)
public class TagsView: UIView {
    
    // MARK: - Types
    public enum SelectionMode { case none, single, multiple }
    
    // MARK: - Public properties
    @Published public private(set) var tags = [Tag]()
    @Published public private(set) var selectedTag: Tag?
    @Published public private(set) var selectedTags = [Tag]()
    @Published public private(set) var filteredTags = [Tag]()
    
    public var isBouncingEnabled = false { didSet { updateBouncing() } }
    public var selectionMode = SelectionMode.single
    
    public var tagStyle = TagCellStyle() { didSet { updateLayout() } }
    public var tagsAlignment = TagCellLayout.LayoutAlignment.left { didSet { updateLayout() } }
    
    // MARK: - Private properties
    private var dataSource: UICollectionViewDiffableDataSource<Int, Tag>?
    private var collectionView: UICollectionView?
    private var cancellables = Set<AnyCancellable>()
    
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
    public func addTags(_ tagsToAdd: [Tag]) {
        tags.append(contentsOf: tagsToAdd)
    }
    
    public func removeTags(_ tagsToRemove: [Tag]) {
        tags.removeAll { tagsToRemove.contains($0) }
    }
    
    func filterFor(_ name: String) {
        filteredTags = tags.filter { $0.name.contains(name) }
    }
}

// MARK: - Updates
private extension TagsView {
    
    func updateLayout() {
        guard let collection = collectionView else { return }
        let layout = TagsLayoutGenerator(tagHeight: 30).generateLayout()
        configureDataSource(for: collection, cellStyle: tagStyle)
        collectionView?.setCollectionViewLayout(layout, animated: true)
        updateSnapShot(with: tags)
    }
    
    func updateBouncing() {
        collectionView?.alwaysBounceVertical = isBouncingEnabled
    }
}

// MARK: - Setup
private extension TagsView {
    
    func commonInit() {
        let collection: UICollectionView = {
            let _collectionView = UICollectionView(frame: bounds, collectionViewLayout: TagsLayoutGenerator(tagHeight: 30).generateLayout())
            _collectionView.delegate = self
            _collectionView.allowsMultipleSelection = selectionMode == .multiple
            _collectionView.alwaysBounceVertical = isBouncingEnabled
            _collectionView.backgroundColor = UIColor.clear
            _collectionView.register(TagCell.self, forCellWithReuseIdentifier: TagCell.reuseId)
            return _collectionView
        }()
        collectionView = collection
        
        addSubview(collection)
        collection.translatesAutoresizingMaskIntoConstraints = false
        
        let anchors = [
            collection.topAnchor.constraint(equalTo: topAnchor),
            collection.bottomAnchor.constraint(equalTo: bottomAnchor),
            collection.leadingAnchor.constraint(equalTo: leadingAnchor),
            collection.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        anchors.forEach { $0.isActive = true }
        configureDataSource(for: collection, cellStyle: tagStyle)
        
        $tags
            .dropFirst()
            .sink { [weak self] in self?.updateSnapShot(with: $0) }
            .store(in: &cancellables)
    }
    
    func configureDataSource(for collectionView: UICollectionView, cellStyle: TagCellStyle) {
        dataSource = UICollectionViewDiffableDataSource<Int, Tag>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tag: Tag) -> UICollectionViewCell? in
            let cell: TagCell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseId, for: indexPath) as! TagCell
            cell.setupWith(tag, tagStyle: cellStyle)
            return cell
        }
    }
    
    func updateSnapShot(with newTags: [Tag]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Tag>()
        snapshot.appendSections([0])
        snapshot.appendItems(newTags)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

extension TagsView: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard tags.count > indexPath.item else { return }
        let tag = tags[indexPath.item]
        switch selectionMode {
        case .none, .single:
            selectedTag = tag
        case .multiple:
            if selectedTags.contains(tag) {
                selectedTags.removeAll { $0.id == tag.id }
            } else {
                selectedTags.append(tag)
            }
        }
    }
}
