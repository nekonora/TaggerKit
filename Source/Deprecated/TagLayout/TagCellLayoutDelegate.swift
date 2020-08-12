//
//  TagCellLayoutDelegate.swift
//  TagCellLayout
//
//  Created by Ritesh Gupta on 06/01/18.
//  Copyright © 2018 Ritesh. All rights reserved.
//

import Foundation
import UIKit

@available(iOS, deprecated: 13.0, message: "")
public protocol TagCellLayoutDelegate: NSObjectProtocol {
    
    func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index:Int) -> CGSize
    func tagCellLayoutInteritemHorizontalSpacing(layout: TagCellLayout) -> CGFloat
    func tagCellLayoutInteritemVerticalSpacing(layout: TagCellLayout) -> CGFloat
}
