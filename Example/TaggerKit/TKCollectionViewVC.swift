//
//  TKCollectionViewVC.swift
//  TaggerKit_Example
//
//  Created by Filippo Zaffoni on 01/08/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TaggerKit

class TKCollectionViewVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet private var addTagsTextField: TKTextField!
    @IBOutlet private var searchContainer: UIView!
    @IBOutlet private var testContainer: UIView!
    
    // We want the whole experience, let's create two TKCollectionViews
    var productTags: TKCollectionView!
    var allTags: TKCollectionView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        addTagsTextField.sender     = allTags
        addTagsTextField.receiver     = productTags
        
        add(productTags, toView: testContainer)
        add(allTags, toView: searchContainer)
    }
}

// MARK: - Extension to TKCollectionViewDelegate
extension TKCollectionViewVC: TKCollectionViewDelegate {
    
    func tagIsBeingAdded(name: String?) {
        // Example: save testCollection.tags to UserDefault
        print("added \(name!)")
    }
    
    func tagIsBeingRemoved(name: String?) {
        print("removed \(name!)")
    }
}
