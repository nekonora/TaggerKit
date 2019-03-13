//
//  LayoutAlignment.swift
//  TagCellLayout
//
//  Created by Ritesh Gupta on 06/01/18.
//  Copyright © 2018 Ritesh. All rights reserved.
//

import Foundation
import UIKit

public extension TagCellLayout {
	
	public enum LayoutAlignment: Int {
		
		case left
		case center
		case right
	}
}

extension TagCellLayout.LayoutAlignment {
	
	var distributionDivisionFactor: CGFloat {
		switch self {
		case .center:
			return 2
		default:
			return 1
		}
	}
}
