//
//  TKView.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 05/10/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

public protocol TKViewDelegate: class {
    
    /// Called when (if present) the button inside the tag has been tapped
    func didTapTagButton()
    /// Called when the user selects the tag
    func didSelectTag()
    /// Called when the user deselects the tag
    func didDeselectTag()
}

public class TKView: UIView {
    
    // MARK - Internal Types
    
    enum SelectionMode { case none, single, multiple }
    
    fileprivate(set) var selectionMode: SelectionMode!
    fileprivate(set) var style: TKTagStyle!
    
    var collectionView: UICollectionView!
    var tagsCollection: TKTagsCollection!
    
    var tagCellLayout: TagCellLayout!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.frame = self.bounds
    }
    
    private func commonInit() {
        tagsCollection = TKTagsCollection(initialTags: ["Ciao", "hey"], manager: self)
        
        tagCellLayout             = TagCellLayout(alignment: .left, delegate: self)
        tagCellLayout.delegate     = self
        
        collectionView                             = UICollectionView(frame: bounds, collectionViewLayout: tagCellLayout)
        collectionView.dataSource                 = self
        collectionView.delegate                 = self
        collectionView.alwaysBounceVertical     = true
        collectionView.backgroundColor            = UIColor.clear
        collectionView.register(TKTagCell.self, forCellWithReuseIdentifier: "TKCell")
        
        addSubview(collectionView)
    }
    
    // MARK - Delegate Methods
    
    func onTagButtonTap() {
        
    }
    
    func onTagSelected() {
        
    }
    
    func onTagDeselected() {
        
    }
}

extension TKView: TKTagsCollectionManager {
    
    func collectionDidUpdateTags() {
        
    }
}

extension TKView: TagCellLayoutDelegate {
   public func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10
    }
    
    public func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10
    }
    
    public func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
//        let tagName     = tags[index]
//        let font         = customFont
//        let cellSize     = textSize(text: tagName, font: font, collectionView: tagsCollectionView)
        
        return CGSize(width: 90, height: 30)
    }
    
//    public func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
//        var viewBounds             = collectionView.bounds
//        viewBounds.size.height     = 9999.0
//        
//        let label: UILabel = {
//            let _label                 = UILabel()
//            _label.numberOfLines     = 0
//            _label.text             = text
//            _label.font             = font
//            return _label
//        }()
//        
//        var sizeThatFits     = label.sizeThatFits(viewBounds.size)
//        sizeThatFits.height = oneLineHeight
//        
//        switch action {
//        case .addTag, .removeTag:
//            sizeThatFits.width += 50
//        case .noAction:
//            sizeThatFits.width += 30
//        }
//        
//        return sizeThatFits
//    }
    
}

extension TKView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TKCell", for: indexPath) as? TKTagCell else { return UICollectionViewCell() }
        cell.backgroundColor = .red
        return cell
    }
}
