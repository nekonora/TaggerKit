//
//  TagsView+CV.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//

import Foundation

extension TagsView: TagCellLayoutDelegate {
    
    public func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
        return tagStyle.tagsSpacing ?? 0
    }
    
    public func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
        return tagStyle.tagsSpacing ?? 0
    }
    
    public func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        guard let tag = tagsCollection?.tags[index], let collectionView = collectionView  else { return .zero }
        let font: UIFont = tagStyle.font ?? UIFont.systemFont(ofSize: 10)
        let cellSize     = textSize(text: tag,
                                    font: font,
                                    collectionView: collectionView)
        return cellSize
    }
    
    public func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        var viewBounds         = collectionView.bounds
        viewBounds.size.height = 9999.0

        let label: UILabel = {
            let _label           = UILabel()
            _label.numberOfLines = 1
            _label.text          = text
            _label.font          = font
            return _label
        }()
        
        let sizeThatFits: CGSize = {
            guard let height = tagStyle.tagCellHeight else { return label.sizeThatFits(viewBounds.size) }
            var size    = label.sizeThatFits(viewBounds.size)
            size.height = height
            size.width += (tagStyle.action != nil ? (height * 0.8) : 0) + (height * 0.8).rounded()
            return size
        }()

        return sizeThatFits
    }
}

extension TagsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsCollection?.tags.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell else { return UICollectionViewCell() }
        cell.setupWith(tagsCollection?.tags[indexPath.item] ?? "", tagStyle: tagStyle)
        return cell
    }
}
