//
//  TKTextField.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


public class TKTextField: UITextField {
	
	
	// MARK: - Properties
	// Objects to operate - obviously should not be the same
	public var sender 	: TKCollectionView? { didSet { allTags = sender?.tags } }
	public var receiver	: TKCollectionView?
	
	var allTags: [String]!
	
	// Style
	private let defaultBackgroundColor 	= UIColor(red: 1.00, green: 0.80, blue: 0.37, alpha: 1.0)
	private let defaultCornerRadius 	= CGFloat(14.0)
	
	
	// MARK: - Lifecycle Methods
	public override func awakeFromNib() {
		clipsToBounds = true
		layer.cornerRadius = defaultCornerRadius
		backgroundColor = defaultBackgroundColor
		
		clearButtonMode = .whileEditing
		
		placeholder = "Create a tag"
		
		addTarget(self, action: #selector(addingTags), for: .editingChanged)
		addTarget(self, action: #selector(pressedReturn), for: .editingDidEndOnExit)
	}
	
	
	// MARK: - TextField methods
	@objc func addingTags() {
		guard sender != nil && receiver != nil else { return }
		
		let filteredStrings = allTags.filter({(item: String) -> Bool in
			let stringMatch = item.lowercased().range(of: text!.lowercased())
			return stringMatch != nil ? true : false
		})
		
		
		
		if filteredStrings.isEmpty {
			if text! == "" {
				sender!.tags = allTags
				sender!.tagsCollectionView.reloadData()
			} else {
				sender!.tags = ["\(text!)"]
				sender!.tagsCollectionView.reloadData()
			}
			
		} else {
			sender!.tags = filteredStrings
			sender!.tagsCollectionView.reloadData()
		}
		
	}
	
	
	@objc func pressedReturn() {
		guard sender != nil && receiver != nil else { return }
		sender?.addNewTag(named: text)
	}
	
	
}
