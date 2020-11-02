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
/// A view capable of displaying tags
public class TagsView: UIView {
    
    // MARK: - Types
    /// Type indicating the desired selection mode for a `TagsView` instance
    public enum SelectionMode {
        /// Selecting a tag will only act as the tap of a button, selection is not persistent
        /// Observe the `$selectedTag` publisher to act on the selection
        case none
        /// Selecting a tag will act as classic selection, selection is persistent.
        /// When another tag will be selected, the previous will be unselected
        /// Observe the `$selectedTag` publisher to act on the selection
        case single
        /// Selecting a tag will add it to the `selectedTags` array if not already present,
        /// otherwise it will be removed from the array.
        /// Observe the `$selectedTags` publisher to act on the selection
        case multiple
    }
    
    // MARK: - Public properties
    /// The currently displayed tags
    @Published public private(set) var tags = [Tag]()
    /// The currently selected tag if present. Only for `selectionMode` `.none` or `.single`
    @Published public private(set) var selectedTag: Tag?
    /// The currently selected tags. Only for `selectionMode` `.multiple`
    @Published public private(set) var selectedTags = [Tag]()
    
    /// Defines if the tags collection always bounces
    public var isBouncingEnabled = false { didSet { updateBouncing() } }
    
    /// Desidered selection mode for the tags in the collection
    public var selectionMode = SelectionMode.single
    
    /// Indicates the style applied to the tag cell in the collection
    public var tagStyle = TagCellStyle() { didSet { updateLayout() } }
    
    /// Alignment of the tag cells inside of the collection
//    public var tagsAlignment = TagCellLayout.LayoutAlignment.left { didSet { updateLayout() } }
    
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
    /// Clears the tags array and re-sets a new array of tags
    public func setTags(_ newTags: [Tag]) {
        tags = newTags
    }
    
    /// Appends tags to the existing tags array if not already added
    public func addTags(_ tagsToAdd: [Tag]) {
        let safeAppendingArray = tagsToAdd.filter { !self.tags.contains($0) }
        tags.append(contentsOf: safeAppendingArray)
    }
    
    /// Removes tags from the existing tags array if present
    public func removeTags(_ tagsToRemove: [Tag]) {
        tags = tags.filter { !tagsToRemove.contains($0) }
    }
}

// MARK: - Updates
@available(iOS 13, *)
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
@available(iOS 13, *)
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
        guard newTags != tags else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Tag>()
        snapshot.appendSections([0])
        snapshot.appendItems(newTags)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}

@available(iOS 13, *)
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
