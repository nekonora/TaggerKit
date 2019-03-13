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
	public var sender 		: TKCollectionView?
	public var receiver	: TKCollectionView?
	
	
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
		
		// Toolbar button
		let toolbarDone = UIToolbar.init()
		toolbarDone.sizeToFit()
		let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(doneButtonAction))
		toolbarDone.items = [barBtnDone] // You can even add cancel button too
		self.inputAccessoryView = toolbarDone
	}
	
	
	// MARK: - TextField methods
	@objc func addingTags() {
		guard sender != nil && receiver != nil else { return }
		if let searchTerm = text {
			
			let tags = receiver!.tags
			let filteredStrings = tags.filter({(item: String) -> Bool in
				let stringMatch = item.lowercased().range(of: searchTerm.lowercased())
				return stringMatch != nil ? true : false
			})
			
			if filteredStrings.isEmpty {
				sender!.tags 	= ["\(searchTerm)"]
				sender!.tagsCollectionView.reloadData()
			} else {
				sender!.tags 	= filteredStrings
				sender!.tagsCollectionView.reloadData()
			}
		}
	}
	
	
	@objc func pressedReturn() {
		guard sender != nil && receiver != nil else { return }
		sender?.addNewTag(named: text, to: receiver)
	}
	
	
	// Done button to hide keyboard
	@objc func doneButtonAction() {
		self.resignFirstResponder()
	}
	
	
}
