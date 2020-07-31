//
//  TagsLayoutGenerator.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 31/07/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import Foundation
import UIKit

@available(iOS 13, *)
internal class TagsLayoutGenerator {
    
    private var tagCellHeight: CGFloat

    init(tagHeight: CGFloat) {
        self.tagCellHeight = tagHeight
    }
    
    func generateLayout() -> UICollectionViewCompositionalLayout {
        let tagDefaultSize = CGSize(width: 100, height: tagCellHeight)
        
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .estimated(tagDefaultSize.width),
                heightDimension: .absolute(tagDefaultSize.height)
            )
        )

        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(8),
            bottom: .fixed(0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(tagDefaultSize.height)
            ),
            subitems: [item]
        )
        
        group.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(
            leading: .fixed(0),
            top: .fixed(0),
            trailing: .fixed(8),
            bottom: .fixed(8)
        )

        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
