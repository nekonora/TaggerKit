//
//  TKCollectionView+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 11/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


// MARK: - UICollectionViewDataSource
extension TKCollectionView: UICollectionViewDataSource {
	
	public func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return tags.count
	}
	
	
	public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TKCell", for: indexPath) as! TKTagCell
		
		cell.tagName 		= tags[indexPath.item]
		cell.tagAction		= action ?? defaultAction
		cell.cornerRadius 	= customCornerRadius ?? defaultCornerRadius
		cell.font			= customFont ?? defaultFont
		cell.color			= customBackgroundColor ?? defaultBackgroundColor
		cell.delegate		= self
		
		return cell
	}
	
	
	public func addNewTag(named: String?) {
		guard receiver != nil else { return }
		if let tagToAdd = named {
			guard tagToAdd.count > 0 else { return }
			if receiver!.tags.contains(tagToAdd) {
				return
			} else {
				receiver!.tags.insert(tagToAdd, at: 0)
				let indexPath = IndexPath(item: 0, section: 0)
				receiver!.tagsCollectionView.performBatchUpdates({
					receiver!.tagsCollectionView.insertItems(at: [indexPath])
				}, completion: nil)
			}
		}
	}
	
	
	public func removeOldTag(named: String?) {
		if let tagToRemove = named {
			if tags.contains(tagToRemove) {
				let index = tags.firstIndex(of: tagToRemove)
				tags.remove(at: index!)
				let indexPath = IndexPath(item: index!, section: 0)
				tagsCollectionView.performBatchUpdates({
					self.tagsCollectionView?.deleteItems(at: [indexPath])
				}, completion: nil)
			}
		}
	}
	
}


// MARK: - UICollectionViewDelegate
extension TKCollectionView: UICollectionViewDelegate {
	
	public  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
	}
	
}


// MARK: - TagCellLayoutDelegate
extension TKCollectionView: TagCellLayoutDelegate {
	
	public func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat {
		return customSpacing ?? defaultSpacing
	}
	
	
	public func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat {
		return customSpacing ?? defaultSpacing
	}
	
	
	public func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize {
		let tagName 	= tags[index]
		let font 		= customFont ?? defaultFont
		let cellSize 	= textSize(text: tagName, font: font, collectionView: tagsCollectionView)
		
		return cellSize
	}
	
	
	public func textSize(text: String, font: UIFont, collectionView: UICollectionView) -> CGSize {
		var viewBounds 			= collectionView.bounds
		viewBounds.size.height 	= 9999.0
		let label 				= UILabel()
		label.numberOfLines 	= 0
		label.text 				= text
		label.font 				= font
		var s 					= label.sizeThatFits(viewBounds.size)
		s.height 				= oneLineHeight
		
		if action == .addTag || action == .removeTag {
			s.width += 50
		} else if action == nil || action == .noAction {
			s.width += 30
		}
		
		return s
	}
}


// MARK: - TagCellDelegate (action delegate)
extension TKCollectionView: TagCellDelegate {
	
	public func didTapButton(name: String?, action: actionType) {
		
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

