//
//  UIViewController+.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 12/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit


public extension UIViewController {
	
	
	public func add(_ child: UIViewController, toView view: UIView) {
		
		addChild(child)
		child.view.frame = view.bounds
		view.addSubview(child.view)
		
		child.didMove(toParent: self)
	}
	
	
	public func remove() {
		guard parent != nil else { return }
		
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
	
	
}


extension UIViewController: TKCollectionViewDelegate {
	
	@objc public func tagIsBeingAdded(name: String?) { }
	
	@objc public func tagIsBeingRemoved(name: String?) { }
	
}
