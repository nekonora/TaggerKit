//
//  TKTagButton.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

/// The type of action that can be done on a tag
public enum ActionType {
    case addTag
    case removeTag
    case noAction
}

class TKTagButton: UIButton {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle methods
    
    // MARK: - Setup methods
    
    private func setup() {
        alpha = 0.5
    }
}
