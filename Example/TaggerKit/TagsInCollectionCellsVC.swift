//
//  TagsInCollectionCellsVC.swift
//  TaggerKit_Example
//
//  Created by Filippo Zaffoni on 19/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TaggerKit

@available(iOS 13, *)
class TagsInCollectionCellsVC: UICollectionViewController {
    
    /// Quick example data source for the tableView
    private let tagsData = [
        ["🚙 Cars", "😛 Humor", "🧭 Travel", "Music", "Places"].map { Tag(from: $0) },
        ["🛹 Skateboard", "😎 Freetime", "Journalism", "Sports"].map { Tag(from: $0) },
        ["#freetime", "#workhard", "#naptime"].map { Tag(from: $0) },
        ["iOS development", "app development", "swift", "iPhone", "macOS", "cocoapods", "SPM", "tim apple"].map { Tag(from: $0) },
        ["basketball", "football", "baseball", "dodgeball", "whateverball"].map { Tag(from: $0) }
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 180)
            return flowLayout
        }()
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.reloadData()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tagsData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellWithTags", for: indexPath)
        let tagsView = cell.contentView.viewWithTag(101) as? TagsView
        tagsView?.setTags(tagsData[indexPath.item])
        
        let label = cell.contentView.viewWithTag(102) as? UILabel
        label?.text = "Cell #\(indexPath.item)"
        cell.contentView.layoutIfNeeded()
        return cell
    }
}
