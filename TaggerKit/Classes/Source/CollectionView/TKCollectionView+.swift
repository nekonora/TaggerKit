//
//  TKCollectionView+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 11/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

// MARK: - Extension to UICollectionViewDataSource

extension TKCollectionView: UICollectionViewDataSource {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int { return 1 }
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tags.count
	}
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TKCell", for: indexPath) as? TKTagCell else { return UICollectionViewCell() }
		return cell
	}
}

// MARK: - Extension to UICollectionViewDelegate

extension TKCollectionView: UICollectionViewDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = cell as? TKTagCell else { return }
		
		cell.tagName 		= tags[indexPath.item]
		cell.tagAction		= action
		cell.cornerRadius 	= customCornerRadius
		cell.font			= customFont
		cell.color			= customBackgroundColor
        cell.borderSize     = customTagBorderWidth
        cell.borderColor    = customTagBorderColor
		cell.delegate		= self
	}
}

// MARK: - Extension to TagCellLayoutDelegate

extension TKCollectionView: TagCellLayoutDelegate {
	
	public func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
		return customSpacing
	}
	
	public func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
		return customSpacing
	}
	
	public func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
		let tagName 	= tags[index]
		let font 		= customFont
		let cellSize 	= textSize(text: tagName, font: font, collectionView: tagsCollectionView)
		
		return cellSize
	}
	
	public func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
		var viewBounds 			= collectionView.bounds
		viewBounds.size.height 	= 9999.0
		
		let label: UILabel = {
			let _label 				= UILabel()
			_label.numberOfLines 	= 0
			_label.text 			= text
			_label.font 			= font
			return _label
		}()
		
		var sizeThatFits 	= label.sizeThatFits(viewBounds.size)
		sizeThatFits.height = oneLineHeight
		
		switch action {
		case .addTag, .removeTag:
			sizeThatFits.width += 50
		case .noAction:
			sizeThatFits.width += 30
		}
		
		return sizeThatFits
	}
}

// MARK: - Extension to TagCellDelegate (action delegate)

extension TKCollectionView: TagCellDelegate {
	
	public func didTapButton(name: String, action: ActionType) {
		switch action {
		case .addTag:
			addNewTag(named: name)
			delegate?.tagIsBeingAdded(name: name)
		case .removeTag:
			removeOldTag(named: name)
			delegate?.tagIsBeingRemoved(name: name)
		case .noAction:
			break
		}
	}
}
