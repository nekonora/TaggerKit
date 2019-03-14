//
//  TKTagCell.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 11/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//


import UIKit


protocol TagCellDelegate {
	func didTapButton(name: String?, action: actionType)
}


class TKTagCell: UICollectionViewCell {
	
	
	// MARK: - Properties
	var tagName			: String? { didSet { nameLabel.text = tagName } }
	var font			: UIFont? { didSet { nameLabel.font = font } }
	var color 			: UIColor? { didSet { backgroundColor = color } }
	var cornerRadius	: CGFloat? { didSet { layer.cornerRadius = cornerRadius! } }
	var tagAction 		: actionType! { didSet { setupButton(action: tagAction) } }
	
	lazy var nameLabel: UILabel = {
		let label 										= UILabel()
		label.textColor 								= UIColor.darkGray
		label.textAlignment 							= .center
		return label
	}()
	
	let button 		= TKTagButton()
	var delegate 	: TKCollectionView?
	
	
	// MARK: - Lifecycle methods
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupCell()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: - Setup methods
	private func setupCell() {
		clipsToBounds = true
		
		addSubview(nameLabel)
		addSubview(button)
	
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
	}
	
	
	private func setupButton(action: actionType) {
		
		// Button layout
		var computedPadding: CGFloat = 0
		button.alpha = 0.3
		
		if tagAction == .addTag || tagAction == .removeTag {
			computedPadding = -10
		} else if tagAction == .noAction {
			computedPadding = 0
		}
		
		
		switch action {
		case .addTag:
			let icon = loadImage(name: "addIcon")
			button.setImage(icon, for: .normal)
		case .removeTag:
			let icon = loadImage(name: "removeIcon")
			button.setImage(icon, for: .normal)
		case .noAction:
			button.setImage(UIImage(), for: .normal)
			button.isHidden = true
		}
		
		self.addConstraints([
			NSLayoutConstraint(item: nameLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: nameLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: computedPadding),
			NSLayoutConstraint(item: nameLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0),
			
			NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28),
			NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 28),
			NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
			])
		
		
		// Button action
		button.isEnabled = true
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}
	
	
	// MARK: - Buttons action methods
	@objc private func buttonTapped() {
		if let cellDelegate = delegate {
			cellDelegate.didTapButton(name: tagName, action: tagAction)
		}
	}

	
	func loadImage(name: String) -> UIImage? {
		let podBundle = Bundle(identifier: "org.cocoapods.TaggerKit")!
		if let url = podBundle.url(forResource: "TaggerKit", withExtension: "bundle") {
			let bundle = Bundle(url: url)
			return UIImage(named: name, in: bundle, compatibleWith: nil)
		}
		return nil
	}
	
	
}
