//
//  TagsInTableViewCells.swift
//  TaggerKit_Example
//
//  Created by Filippo Zaffoni on 19/09/2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import TaggerKit

@available(iOS 13, *)
class TagsInTableViewCells: UITableViewController {
    
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
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tagsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWithTags", for: indexPath)
        let tagsView = cell.contentView.viewWithTag(101) as? TagsView
        tagsView?.setTags(tagsData[indexPath.item])
        cell.contentView.layoutIfNeeded()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
