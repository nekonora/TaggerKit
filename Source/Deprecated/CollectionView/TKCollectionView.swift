//
//  TKCollectionView.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 09/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

/// Conforming to this protocol enables a controller to be notified and act upon
/// the life of a tag (added or removed from a collection)
public protocol TKCollectionViewDelegate: UIViewController {
    func tagIsBeingAdded(name: String?)
    func tagIsBeingRemoved(name: String?)
}

/// This collection view is a container that displays and manages tags
public class TKCollectionView: UIViewController {
    
    // MARK: - Customasible properties
    
    /// The font of the label inside the tag (default: system bold of size 14)
    public var customFont = UIFont.boldSystemFont(ofSize: 14)
    
    /// The inset between every tag (default: 10 points)
    public var customSpacing = CGFloat(10.0)
    
    /// The corner radius of the tag view (default: 14 points)
    public var customCornerRadius = CGFloat(14.0)
    
    /// The background color of the tag view
    public var customBackgroundColor = UIColor(red: 1.00, green: 0.80, blue: 0.37, alpha: 1.0)
    
    /// The color of the tag cell border, if present
    public var customTagBorderColor: UIColor?
    
    /// The border of the tag cell view
    public var customTagBorderWidth: CGFloat?
    
    /// The action embedded in the tag: add, remove or no action (default: no action). (this changes the embedded icon)
    public var action = ActionType.noAction
    
    // MARK: - Class properties
    
    /// The actual collectionView inside the controller, where every cell is a tag
    public var tagsCollectionView: UICollectionView!
    
    /// The custom cell layout of the single cell
    public var tagCellLayout: TagCellLayout!
    
    /// If tags in the collection are given an action of type "add", a receiver can be automatically binded on this property
    public var receiver: TKCollectionView?
    
    /// A controller that confromed to be a delegate for the tags collection view
    public var delegate: TKCollectionViewDelegate?
    
    lazy var oneLineHeight: CGFloat = { customFont.pointSize * 2 }()
    
    var longTagIndex = 1
    
    /// The array containing all the tags of the collection
    public var tags = [String]()
    
    // MARK: - Lifecycle methods
    
    public convenience init(tags: [String], action: ActionType, receiver: TKCollectionView?) {
        self.init()
        
        self.action   = action
        self.receiver = receiver
        self.tags     = tags
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tagsCollectionView.frame = view.bounds
    }
    
    // MARK - Public Methods
    
    /// Adds a tag to the tag view
    /// - Parameter tag: the name of the tag to add
    public func addNewTag(named tag: String) {
        guard
            receiver != nil,
            !tag.isEmpty
            else { return }
        
        if receiver!.tags.contains(tag) {
            return
        } else {
            receiver!.tags.insert(tag, at: 0)
            let indexPath = IndexPath(item: 0, section: 0)
            receiver!.tagsCollectionView.performBatchUpdates({
                receiver!.tagsCollectionView.insertItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    /// Removes a tag from the tag view
    /// - Parameter tag: the name of the tag to remove
    public func removeOldTag(named tag: String) {
        guard tags.contains(tag) else { return }
        
        if let index = tags.firstIndex(of: tag) {
            tags.remove(at: index)
            
            let indexPath = IndexPath(item: index, section: 0)
            
            tagsCollectionView.performBatchUpdates({
                self.tagsCollectionView?.deleteItems(at: [indexPath])
            }, completion: nil)
        }
    }
    
    // MARK: - Class Methods
    
    private func setupView() {
        tagCellLayout             = TagCellLayout(alignment: .left, delegate: self)
        tagCellLayout.delegate     = self
        
        tagsCollectionView                             = UICollectionView(frame: view.bounds, collectionViewLayout: tagCellLayout)
        tagsCollectionView.dataSource                 = self
        tagsCollectionView.delegate                 = self
        tagsCollectionView.alwaysBounceVertical     = true
        tagsCollectionView.backgroundColor            = UIColor.clear
        tagsCollectionView.register(TKTagCell.self, forCellWithReuseIdentifier: "TKCell")
        
        view.addSubview(tagsCollectionView)
    }
}
