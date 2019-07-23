//
//  ViewController.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 03/13/2019.
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
    let productTags = TKCollectionView()
    let allTags 	= TKCollectionView()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customisation example
        //		testCollection.customFont = UIFont.boldSystemFont(ofSize: 14)		// Custom font
        //		testCollection.customCornerRadius = 14.0							// Corner radius of tags
        //		testCollection.customSpacing = 20.0									// Spacing between cells
        //		testCollection.customBackgroundColor = UIColor.red					// Background of cells
        
        // These are the tags already added by the user, give an aray of strings to the collection
        productTags.tags = ["Tech", "Design", "Writing", "Social Media"]
        
        // These are intended to be all the tags the user has added in the app, which are going to be filtered
        allTags.tags = ["Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Music", "Sports"]
        
        /*
         We set this collection's action to .removeTag,
         becasue these are supposed to be the tags the user has already added
         */
        productTags.action = .removeTag
        
        // Set the current controller as the delegate of both collections
        productTags.delegate = self
        allTags.delegate = self
        
        // "testCollection" takes the tags sent by "searchCollection"
        allTags.receiver = productTags
        
        // The tags in "searchCollection" are going to be added, so we set the action to addTag
        allTags.action = .addTag
        
        // Set the sender and receiver of the TextField
        addTagsTextField.sender 	= allTags
        addTagsTextField.receiver 	= productTags
        
        add(productTags, toView: testContainer)
        add(allTags, toView: searchContainer)
    }
    
}

// MARK: - Extension to TKCollectionViewDelegate

extension ViewController: TKCollectionViewDelegate {
    
    /*
     These methods come from UIViewController now conforming to TKCollectionViewDelegate,
     You use these to do whatever you want when a tag is added or removed (e.g. save to file, etc)
     */
    
    func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
    }
    
    func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
    }
    
}

