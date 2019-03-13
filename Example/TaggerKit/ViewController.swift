//
//  ViewController.swift
//  TaggerKit
//
//  Created by registration.fi.za@outlook.com on 03/13/2019.
//  Copyright (c) 2019 registration.fi.za@outlook.com. All rights reserved.
//


import UIKit
import TaggerKit		// Import taggerKit


class ViewController: UIViewController {

	
	// MARK: - Outlets
	@IBOutlet var addTagsTextField	: TKTextField!
	@IBOutlet var searchContainer	: UIView!
	@IBOutlet var testContainer		: UIView!
	
	
	// We want the whole experience, let's create two TKCollectionViews
	let testCollection 		= TKCollectionView()
	let searchCollection 	= TKCollectionView()
	
	
	// MARK: - Lifecycle Methods
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
		// Customisation example
		//		testCollection.customFont = UIFont.boldSystemFont(ofSize: 14)		// Custom font
		//		testCollection.customCornerRadius = 14.0							// Corner radius of tags
		//		testCollection.customSpacing = 20.0									// Spacing between cells
		//		testCollection.customBackgroundColor = UIColor.red					// Background of cells
		
		
		// These are the tags already added by the user, give an aray of strings to the collection
		testCollection.tags = ["Tech", "Design", "Humor", "Travel", "Music", "Writing", "Social Media"]
		searchCollection.tags = [""] 	// I do this only to show the empty tag prompt at the start
		
		/*
		We set this collection's action to .removeTag,
		becasue these are supposed to be the tags the user has already added
		*/
		testCollection.action = .removeTag
		
		
		// Set the current controller as the delegate of both collections
		testCollection.delegate = self
		searchCollection.delegate = self
		
		// "testCollection" takes the tags sent by "searchCollection"
		searchCollection.receiver = testCollection
		
		// The tags in "searchCollection" are going to be added, so we set the action to addTag
		searchCollection.action = .addTag
		
		
		// Set the sender and receiver of the TextField
		addTagsTextField.sender 	= searchCollection
		addTagsTextField.receiver 	= testCollection
		
		add(testCollection, toView: testContainer)
		add(searchCollection, toView: searchContainer)
		
	}
	
	
	/*
	These methods come from UIViewController now conforming to TKCollectionViewDelegate,
	You use these to do whatever you want when a tag is added or removed (e.g. save to file, etc)
	*/
//	override func tagIsBeingAdded(name: String?) {
//		// Example: save testCollection.tags to UserDefault
//	}
//	
//	override func tagIsBeingRemoved(name: String?) {
//		
//	}
	
}
