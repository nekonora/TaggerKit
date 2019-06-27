//
//  TKCollectionView+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 11/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit
import MobileCoreServices

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
	
	public func addNewTag(named tag: String) {
		guard let receiver = receiver, !tag.isEmpty, receiver.tags.contains(tag) else { return }

		receiver.tags.insert(tag, at: 0)
		
		let indexPath = IndexPath(item: 0, section: 0)
		
		receiver.tagsCollectionView.performBatchUpdates({
			receiver.tagsCollectionView.insertItems(at: [indexPath])
		}, completion: nil)
	}
	
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

// MARK: - Extension to Drag&Drop

#warning("make the code a little bit better")

extension TKCollectionView: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
	
	public func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
		let tagString = tags[indexPath.item]
		guard let data = tagString.data(using: .utf8) else { return [] }
		let itemProvider = NSItemProvider(item: data as NSData, typeIdentifier: kUTTypePlainText as String)
		return [UIDragItem(itemProvider: itemProvider)]
	}
	
	public func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
		let destinationIndexPath: IndexPath
		
		// If a destinationIndexPath (the point between other data) is present, put the drop there
		if let indexPath = coordinator.destinationIndexPath {
			destinationIndexPath = indexPath
		} else {
			let section = tagsCollectionView.numberOfSections - 1
			let row = tagsCollectionView.numberOfItems(inSection: section)
			destinationIndexPath = IndexPath(row: row, section: section)
		}
		
		coordinator.session.loadObjects(ofClass: NSString.self) { items in
			guard let strings = items as? [String] else { return }
			
			var indexPaths = [IndexPath]()
			
			for (index, string) in strings.enumerated() {
				let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
				self.tags.insert(string, at: indexPath.row)
				
				indexPaths.append(indexPath)
			}
			self.tagsCollectionView.insertItems(at: indexPaths)
		}
	}
	
	public func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
		var dragPreview: UIDragPreviewParameters {
			let preview = UIDragPreviewParameters()
			preview.backgroundColor = .clear
			return preview
		}
		
		return dragPreview
	}
	
	public func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
		return UICollectionViewDropProposal(operation: .move)
	}
	
	func setupDragAndDrop() {
		tagsCollectionView.dragInteractionEnabled = true
		tagsCollectionView.dragDelegate = self
		tagsCollectionView.dropDelegate = self
	}
}
