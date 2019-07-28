//
//  TKTagCell.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 11/03/2019.
//  Copyright © 2019 Filippo Zaffoni. All rights reserved.
//

import UIKit

protocol TagCellDelegate {
	func didTapButton(name: String, action: ActionType)
}

class TKTagCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	var tagName: String? {
        didSet {
            guard let name = tagName else { return }
            nameLabel.text = name
        }
    }
    
	var font: UIFont? {
        didSet {
            guard let newFont = font else { return }
            nameLabel.font = newFont
        }
    }
    
	var color: UIColor? {
        didSet {
            guard let newColor = color else { return }
            backgroundColor = newColor
        }
    }
    
	var cornerRadius: CGFloat? {
        didSet {
            guard let radius = cornerRadius else { return }
            layer.cornerRadius = radius
        }
    }
    
    var tagAction: ActionType! {
        didSet {
            guard let newAction = tagAction else { return }
            setupButton(action: newAction)
        }
    }
    
    var borderSize: CGFloat? {
        didSet {
            guard let newSize = borderSize else { return }
            self.layer.borderWidth = newSize
        }
    }
    
    var borderColor: UIColor? {
        didSet {
            guard let newColor = borderColor else { return }
            self.layer.borderColor = newColor.cgColor
        }
    }
	
	lazy var nameLabel: UILabel = {
		let label 			= UILabel()
		label.textColor 	= UIColor.darkGray
		label.textAlignment = .center
		return label
	}()
	
	let button = TKTagButton(frame: CGRect(x: 0, y: 0, width: 28, height: 28))
	var delegate: TKCollectionView?
	
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
		button.translatesAutoresizingMaskIntoConstraints 	= false
	}
	
	private func setupButton(action: ActionType) {
		var computedPadding: CGFloat = 10
		button.alpha = 0.3
		
		self.addConstraints([
			NSLayoutConstraint(item: nameLabel,
							   attribute: .width,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .width,
							   multiplier: 1.0,
							   constant: 0),
			NSLayoutConstraint(item: nameLabel,
							   attribute: .height,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .height,
							   multiplier: 1.0,
							   constant: 0),
			NSLayoutConstraint(item: nameLabel,
							   attribute: .centerX,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .centerX,
							   multiplier: 1.0,
							   constant: 0 - computedPadding),
			NSLayoutConstraint(item: nameLabel,
							   attribute: .centerY,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .centerY,
							   multiplier: 1.0,
							   constant: 0),
			
			NSLayoutConstraint(item: button,
							   attribute: .width,
							   relatedBy: .equal,
							   toItem: nil,
							   attribute: .notAnAttribute,
							   multiplier: 1.0,
							   constant: 28),
			NSLayoutConstraint(item: button,
							   attribute: .height,
							   relatedBy: .equal,
							   toItem: nil,
							   attribute: .notAnAttribute,
							   multiplier: 1.0,
							   constant: 28),
			NSLayoutConstraint(item: button,
							   attribute: .trailing,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .trailing,
							   multiplier: 1.0,
							   constant: 0),
			NSLayoutConstraint(item: button,
							   attribute: .centerY,
							   relatedBy: .equal,
							   toItem: self,
							   attribute: .centerY,
							   multiplier: 1.0,
							   constant: 0)
			])
		
        switch action {
        case .addTag:
            let icon = drawAddImagePath().shapeImage(view: button)
            button.setImage(icon, for: .normal)
        case .removeTag:
            let icon = drawCloseImagePath().shapeImage(view: button)
            button.setImage(icon, for: .normal)
        case .noAction:
            computedPadding = 0
            button.setImage(UIImage(), for: .normal)
            button.isHidden = true
        }
        
		button.isEnabled = true
		button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}
	
	// MARK: - Buttons action methods
	
	@objc private func buttonTapped() {
		guard let tagName = tagName, let delegate = delegate else { return }
		delegate.didTapButton(name: tagName, action: tagAction)
	}

    // MARK: - Image form bezier paths

    func drawCloseImagePath() -> UIBezierPath {
        let path = drawAddImagePath()
        path.apply(CGAffineTransform(translationX: -12, y: -12))
        path.apply(CGAffineTransform(rotationAngle: -(CGFloat.pi / 4)))
        path.apply(CGAffineTransform(translationX: 11, y: 14))
        return path
    }
    
    func drawAddImagePath() -> UIBezierPath {
        //// Color Declarations
        let color = UIColor.black

        //// Bezier 2 Drawing
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 11.92, y: 4.8))
        bezier2Path.addLine(to: CGPoint(x: 11.78, y: 4.8))
        bezier2Path.addCurve(to: CGPoint(x: 11.3, y: 4.9), controlPoint1: CGPoint(x: 11.61, y: 4.8), controlPoint2: CGPoint(x: 11.45, y: 4.83))
        bezier2Path.addCurve(to: CGPoint(x: 10.6, y: 5.63), controlPoint1: CGPoint(x: 10.98, y: 5.03), controlPoint2: CGPoint(x: 10.72, y: 5.29))
        bezier2Path.addLine(to: CGPoint(x: 10.59, y: 5.68))
        bezier2Path.addCurve(to: CGPoint(x: 10.5, y: 10.8), controlPoint1: CGPoint(x: 10.52, y: 5.87), controlPoint2: CGPoint(x: 10.51, y: 6.09))
        bezier2Path.addLine(to: CGPoint(x: 6.54, y: 10.8))
        bezier2Path.addCurve(to: CGPoint(x: 6.27, y: 10.8), controlPoint1: CGPoint(x: 6.44, y: 10.8), controlPoint2: CGPoint(x: 6.35, y: 10.8))
        bezier2Path.addCurve(to: CGPoint(x: 5.88, y: 10.81), controlPoint1: CGPoint(x: 6.12, y: 10.8), controlPoint2: CGPoint(x: 5.99, y: 10.8))
        bezier2Path.addCurve(to: CGPoint(x: 5.33, y: 10.9), controlPoint1: CGPoint(x: 5.67, y: 10.82), controlPoint2: CGPoint(x: 5.5, y: 10.85))
        bezier2Path.addCurve(to: CGPoint(x: 4.5, y: 12.08), controlPoint1: CGPoint(x: 4.83, y: 11.08), controlPoint2: CGPoint(x: 4.5, y: 11.55))
        bezier2Path.addLine(to: CGPoint(x: 4.5, y: 12.15))
        bezier2Path.addCurve(to: CGPoint(x: 4.5, y: 12.22), controlPoint1: CGPoint(x: 4.5, y: 12.15), controlPoint2: CGPoint(x: 4.5, y: 12.15))
        bezier2Path.addCurve(to: CGPoint(x: 5.33, y: 13.4), controlPoint1: CGPoint(x: 4.5, y: 12.75), controlPoint2: CGPoint(x: 4.83, y: 13.22))
        bezier2Path.addLine(to: CGPoint(x: 5.38, y: 13.41))
        bezier2Path.addCurve(to: CGPoint(x: 5.88, y: 13.5), controlPoint1: CGPoint(x: 5.65, y: 13.5), controlPoint2: CGPoint(x: 5.94, y: 13.5))
        bezier2Path.addLine(to: CGPoint(x: 10.5, y: 13.5))
        bezier2Path.addCurve(to: CGPoint(x: 10.5, y: 17.47), controlPoint1: CGPoint(x: 10.5, y: 14.64), controlPoint2: CGPoint(x: 10.5, y: 15.95))
        bezier2Path.addCurve(to: CGPoint(x: 10.5, y: 18.12), controlPoint1: CGPoint(x: 10.5, y: 17.56), controlPoint2: CGPoint(x: 10.5, y: 18.12))
        bezier2Path.addCurve(to: CGPoint(x: 10.5, y: 17.47), controlPoint1: CGPoint(x: 10.5, y: 17.9), controlPoint2: CGPoint(x: 10.5, y: 17.69))
        bezier2Path.addCurve(to: CGPoint(x: 10.51, y: 18.12), controlPoint1: CGPoint(x: 10.5, y: 17.74), controlPoint2: CGPoint(x: 10.5, y: 17.95))
        bezier2Path.addCurve(to: CGPoint(x: 10.6, y: 18.67), controlPoint1: CGPoint(x: 10.52, y: 18.33), controlPoint2: CGPoint(x: 10.55, y: 18.5))
        bezier2Path.addCurve(to: CGPoint(x: 11.78, y: 19.5), controlPoint1: CGPoint(x: 10.78, y: 19.17), controlPoint2: CGPoint(x: 11.25, y: 19.5))
        bezier2Path.addLine(to: CGPoint(x: 11.92, y: 19.5))
        bezier2Path.addCurve(to: CGPoint(x: 13.1, y: 18.67), controlPoint1: CGPoint(x: 12.45, y: 19.5), controlPoint2: CGPoint(x: 12.92, y: 19.17))
        bezier2Path.addLine(to: CGPoint(x: 13.11, y: 18.62))
        bezier2Path.addCurve(to: CGPoint(x: 13.2, y: 18.12), controlPoint1: CGPoint(x: 13.2, y: 18.35), controlPoint2: CGPoint(x: 13.2, y: 18.06))
        bezier2Path.addCurve(to: CGPoint(x: 13.2, y: 13.5), controlPoint1: CGPoint(x: 13.2, y: 18.12), controlPoint2: CGPoint(x: 13.2, y: 15.94))
        bezier2Path.addLine(to: CGPoint(x: 17.16, y: 13.5))
        bezier2Path.addCurve(to: CGPoint(x: 18.37, y: 13.4), controlPoint1: CGPoint(x: 17.76, y: 13.5), controlPoint2: CGPoint(x: 18.05, y: 13.5))
        bezier2Path.addCurve(to: CGPoint(x: 19.2, y: 12.22), controlPoint1: CGPoint(x: 18.87, y: 13.22), controlPoint2: CGPoint(x: 19.2, y: 12.75))
        bezier2Path.addLine(to: CGPoint(x: 19.2, y: 12.15))
        bezier2Path.addCurve(to: CGPoint(x: 19.2, y: 12.08), controlPoint1: CGPoint(x: 19.2, y: 12.15), controlPoint2: CGPoint(x: 19.2, y: 12.15))
        bezier2Path.addCurve(to: CGPoint(x: 18.37, y: 10.9), controlPoint1: CGPoint(x: 19.2, y: 11.55), controlPoint2: CGPoint(x: 18.87, y: 11.08))
        bezier2Path.addLine(to: CGPoint(x: 18.32, y: 10.89))
        bezier2Path.addCurve(to: CGPoint(x: 17.82, y: 10.8), controlPoint1: CGPoint(x: 18.05, y: 10.8), controlPoint2: CGPoint(x: 17.76, y: 10.8))
        bezier2Path.addLine(to: CGPoint(x: 13.2, y: 10.8))
        bezier2Path.addCurve(to: CGPoint(x: 13.2, y: 6.84), controlPoint1: CGPoint(x: 13.2, y: 8.64), controlPoint2: CGPoint(x: 13.2, y: 6.84))
        bezier2Path.addCurve(to: CGPoint(x: 13.1, y: 5.63), controlPoint1: CGPoint(x: 13.2, y: 6.24), controlPoint2: CGPoint(x: 13.2, y: 5.95))
        bezier2Path.addCurve(to: CGPoint(x: 11.92, y: 4.8), controlPoint1: CGPoint(x: 12.92, y: 5.13), controlPoint2: CGPoint(x: 12.45, y: 4.8))
        bezier2Path.close()
        bezier2Path.move(to: CGPoint(x: 24, y: 12))
        bezier2Path.addCurve(to: CGPoint(x: 12, y: 24), controlPoint1: CGPoint(x: 24, y: 18.63), controlPoint2: CGPoint(x: 18.63, y: 24))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 12), controlPoint1: CGPoint(x: 5.37, y: 24), controlPoint2: CGPoint(x: 0, y: 18.63))
        bezier2Path.addCurve(to: CGPoint(x: 4.75, y: 2.44), controlPoint1: CGPoint(x: 0, y: 8.1), controlPoint2: CGPoint(x: 1.86, y: 4.63))
        bezier2Path.addCurve(to: CGPoint(x: 12, y: 0), controlPoint1: CGPoint(x: 6.76, y: 0.91), controlPoint2: CGPoint(x: 9.28, y: 0))
        bezier2Path.addCurve(to: CGPoint(x: 24, y: 12), controlPoint1: CGPoint(x: 18.63, y: 0), controlPoint2: CGPoint(x: 24, y: 5.37))
        bezier2Path.close()
        color.setFill()
        bezier2Path.fill()

        bezier2Path.apply(CGAffineTransform(translationX: 2, y: 2))
        
        return bezier2Path
    }
}
