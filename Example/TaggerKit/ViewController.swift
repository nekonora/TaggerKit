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
    var productTags: TKCollectionView!
    var allTags: TKCollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customisation example
        //		testCollection.customFont = UIFont.boldSystemFont(ofSize: 14)		// Custom font
        //		testCollection.customCornerRadius = 14.0							// Corner radius of tags
        //		testCollection.customSpacing = 20.0									// Spacing between cells
        //		testCollection.customBackgroundColor = UIColor.red					// Background of cells
        
        productTags = TKCollectionView(tags: [
                                        "Tech", "Design", "Writing", "Social Media"
                                       ],
                                       action: .removeTag,
                                       receiver: nil)
        
        allTags = TKCollectionView(tags: [
                                    "Cars", "Skateboard", "Freetime", "Humor", "Travel", "Music", "Places", "Journalism", "Sports"
                                   ],
                                   action: .addTag,
                                   receiver: productTags)
        
        // Set the current controller as the delegate of both collections
        productTags.delegate = self
        allTags.delegate = self
        
        // Set the sender and receiver of the TextField
        addTagsTextField.sender 	= allTags
        addTagsTextField.receiver 	= productTags
        
        add(productTags, toView: testContainer)
        add(allTags, toView: searchContainer)
    }
}

// MARK: - Extension to TKCollectionViewDelegate

extension ViewController: TKCollectionViewDelegate {

    func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
    }
    
    func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
    }
}
