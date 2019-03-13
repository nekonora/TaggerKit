//
//  TagCellLayout.swift
//  TagCellLayout
//
//  Created by Ritesh-Gupta on 20/11/15.
//  Copyright © 2015 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public class TagCellLayout: UICollectionViewLayout {
	
	let alignment: LayoutAlignment

	var layoutInfoList: [LayoutInfo] = []
	var numberOfTagsInCurrentRow = 0
	var currentTagIndex: Int = 0
	
	weak var delegate: TagCellLayoutDelegate?
	
	//MARK: - Init Methods
	
	public init(alignment: LayoutAlignment = .left, delegate: TagCellLayoutDelegate?) {
		self.delegate = delegate
		self.alignment = alignment
		super.init()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		alignment = .left
		super.init(coder: aDecoder)
	}
	
	override convenience init() {
		self.init(delegate: nil)
	}
	
	//MARK: - Override Methods
	
	override public func prepare() {
		resetLayoutState()
		setupTagCellLayout()
	}
	public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		guard layoutInfoList.count > indexPath.row else { return nil }
		return layoutInfoList[indexPath.row].layoutAttribute
	}
	
	override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard !layoutInfoList.isEmpty else { return nil }
		return layoutInfoList
			.lazy
			.map { $0.layoutAttribute }
			.filter { rect.intersects($0.frame) }
	}
	
	override public var collectionViewContentSize: CGSize {
		let width = collectionViewWidth
		let height = layoutInfoList
			.filter { $0.isFirstElementInARow }
			.reduce(0, { $0 + $1.layoutAttribute.frame.height })
		return CGSize(width: width, height: height)
	}
}

//MARK: - Private Methods

private extension TagCellLayout {
	
	var currentTagFrame: CGRect {
		guard let info = currentTagLayoutInfo?.layoutAttribute else { return .zero }
		var frame = info.frame
		frame.origin.x += info.bounds.width + (delegate?.tagCellLayoutInteritemHorizontalSpacing(layout: self) ?? 0.0)
		return frame
	}
	
	var currentTagLayoutInfo: LayoutInfo? {
		let index = max(0, currentTagIndex - 1)
		guard layoutInfoList.count > index else { return nil }
		return layoutInfoList[index]
	}
	
	var tagsCount: Int {
		return collectionView?.numberOfItems(inSection: 0) ?? 0
	}
	
	var collectionViewWidth: CGFloat {
		return collectionView?.frame.size.width ?? 0
	}
	
	var isLastRow: Bool {
		return currentTagIndex == (tagsCount - 1)
	}
	
	func setupTagCellLayout() {
		// delegate and collectionview shouldn't be nil
		guard delegate != nil, collectionView != nil else {
			// otherwise throwing an error
			handleErrorState()
			return
		}
		// basic layout setup which is independent of TagAlignment type
		basicLayoutSetup()
		
		// handle if TagAlignment is other than Left
		handleTagAlignment()
	}
	
	func basicLayoutSetup() {
		// asking the client for a fixed tag height
		
		// iterating over every tag and constructing its layout attribute
		(0 ..< tagsCount).forEach {
			currentTagIndex = $0
			
			// creating layout and adding it to the dataSource
			createLayoutAttributes()
			
			// configuring white space info || this is later used for .Right or .Center alignment
			configureWhiteSpace()
			
			// processing info for next tag || setting up the coordinates for next tag
			configurePositionForNextTag()
			
			// handling tha layout for last row separately
			handleWhiteSpaceForLastRow()
		}
	}
	
	func createLayoutAttributes() {
		// calculating tag-size
		let tagSize = delegate!.tagCellLayoutTagSize(layout: self, atIndex: currentTagIndex)
		
		let layoutInfo = tagCellLayoutInfo(tagIndex: currentTagIndex, tagSize: tagSize)
		layoutInfoList.append(layoutInfo)
	}
	
	func tagCellLayoutInfo(tagIndex: Int, tagSize: CGSize) -> LayoutInfo {
		// local data-structure (TagCellLayoutInfo) that has been used in this library to store attribute and white-space info
		var isFirstElementInARow = tagIndex == 0
		var tagFrame = currentTagFrame
		tagFrame.size = tagSize
		
		// if next tag goes out of screen then move it to next row
		if shouldMoveTagToNextRow(tagWidth: tagSize.width) {
			tagFrame.origin.x = 0.0
			tagFrame.origin.y += currentTagFrame.height +
                (delegate?.tagCellLayoutInteritemVerticalSpacing(layout: self) ?? 0.0)
			isFirstElementInARow = true
		}
		let attribute = layoutAttribute(tagIndex: tagIndex, tagFrame: tagFrame)
		var info = LayoutInfo(layoutAttribute: attribute)
		info.isFirstElementInARow = isFirstElementInARow
		return info
	}
	
	func shouldMoveTagToNextRow(tagWidth: CGFloat) -> Bool {
		return ((currentTagFrame.origin.x + tagWidth) > collectionViewWidth)
	}
	
	func layoutAttribute(tagIndex: Int, tagFrame: CGRect) -> UICollectionViewLayoutAttributes {
		let indexPath = IndexPath(item: tagIndex, section: 0)
		let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
		layoutAttribute.frame = tagFrame
		return layoutAttribute
	}
	
	func configureWhiteSpace() {
		let layoutInfo = layoutInfoList[currentTagIndex].layoutAttribute
		let tagWidth = layoutInfo.frame.size.width
		if shouldMoveTagToNextRow(tagWidth: tagWidth) {
			applyWhiteSpace(startingIndex: (currentTagIndex - 1))
		}
	}
	
	func applyWhiteSpace(startingIndex: Int) {
		let lastIndex = startingIndex - numberOfTagsInCurrentRow
		let whiteSpace = calculateWhiteSpace(tagIndex: startingIndex)
		
		for tagIndex in (lastIndex+1) ..< (startingIndex+1) {
			insertWhiteSpace(tagIndex: tagIndex, whiteSpace: whiteSpace)
		}
	}
	
	func calculateWhiteSpace(tagIndex: Int) -> CGFloat {
		let tagFrame = tagFrameForIndex(tagIndex: tagIndex)
		let whiteSpace = collectionViewWidth - (tagFrame.origin.x + tagFrame.size.width)
		return whiteSpace
	}
	
	func insertWhiteSpace(tagIndex: Int, whiteSpace: CGFloat) {
		var info = layoutInfoList[tagIndex]
		let factor = alignment.distributionDivisionFactor
		info.whiteSpace = whiteSpace/factor
		layoutInfoList[tagIndex] = info
	}
	
	func tagFrameForIndex(tagIndex: Int) -> CGRect {
		let tagFrame =  tagIndex > -1 ? layoutInfoList[tagIndex].layoutAttribute.frame : .zero
		return tagFrame
	}
	
	func configurePositionForNextTag() {
		let layoutInfo = layoutInfoList[currentTagIndex].layoutAttribute
		let moveTag = shouldMoveTagToNextRow(tagWidth: layoutInfo.frame.size.width)
		numberOfTagsInCurrentRow = moveTag ? 1 : (numberOfTagsInCurrentRow + 1)
	}
	
	func handleTagAlignment() {
		guard alignment != .left else { return }
		let tagsCount = collectionView!.numberOfItems(inSection: 0)
		for tagIndex in 0 ..< tagsCount {
			var tagFrame = layoutInfoList[tagIndex].layoutAttribute.frame
			let whiteSpace = layoutInfoList[tagIndex].whiteSpace
			tagFrame.origin.x += whiteSpace
			let tagAttribute = layoutAttribute(tagIndex: tagIndex, tagFrame: tagFrame)
			layoutInfoList[tagIndex].layoutAttribute = tagAttribute
		}
	}
	
	func handleWhiteSpaceForLastRow() {
		guard isLastRow else { return }
		applyWhiteSpace(startingIndex: (tagsCount-1))
	}
	
	func handleErrorState() {
		print("TagCollectionViewCellLayout is not properly configured")
	}
	
	func resetLayoutState() {
		layoutInfoList = Array<LayoutInfo>()
		numberOfTagsInCurrentRow = 0
	}
}
