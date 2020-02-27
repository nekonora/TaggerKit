//
//  TagsView+CV.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//

import Foundation

extension TagsView: TagCellLayoutDelegate {
    
    public func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10
    }
    
    public func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
        return 10
    }
    
    public func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
        guard let tag = tagsCollection?.tags[index], let collectionView = collectionView  else { return .zero }
        let font     = UIFont.systemFont(ofSize: 12)
        let cellSize = textSize(text: tag, font: font, collectionView: collectionView)
        
        return cellSize
    }
    
    public func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
        var viewBounds             = collectionView.bounds
        viewBounds.size.height     = 9999.0

        let label: UILabel = {
            let _label           = UILabel()
            _label.numberOfLines = 0
            _label.text          = text
            _label.font          = font
            return _label
        }()

        let oneLineHeight   = font.pointSize * 2
        var sizeThatFits    = label.sizeThatFits(viewBounds.size)
        sizeThatFits.height = oneLineHeight
        
//        switch action {
//        case .addTag, .removeTag:
//            sizeThatFits.width += 50
//        case .noAction:
            sizeThatFits.width += 30
//        }

        return sizeThatFits
    }
}

extension TagsView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsCollection?.tags.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TKTagCell else { return UICollectionViewCell() }
        cell.backgroundColor = .red
        
        let label = UILabel()
        label.text = tagsCollection?.tags[indexPath.item]
        label.textAlignment = .center
        
        cell.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let anchors = [
            label.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor)
        ]
        
        anchors.forEach { $0.isActive = true }
        
        return cell
    }
}
