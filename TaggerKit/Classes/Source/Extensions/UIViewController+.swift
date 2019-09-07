//
//  UIViewController+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

// MARK: - Extension to implement easy child controllers functionality

public extension UIViewController {
    
    func add(_ child: UIViewController, toView view: UIView) {
        addChild(child)
        child.view.frame = view.bounds
        view.addSubview(child.view)
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

extension UIBezierPath {
    
    func shapeImage(view: UIView) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        
        UIColor.black.setFill()
        fill()
        
        if let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return image
        }
        
        return nil
    }
}
