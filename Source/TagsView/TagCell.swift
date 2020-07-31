//
//  TagCell.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//

import UIKit

internal class TagCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var style: TagCellStyle? { didSet { setupStyle() } }
    
    let nameLabel: UILabel = {
        let label           = UILabel()
        label.textColor     = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    func setupWith(_ tagName: String, tagStyle: TagCellStyle? = nil) {
        nameLabel.text = tagName
        style          = tagStyle
        
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
}

// MARK: - Setup

private extension TagCell {
    
    func setupUI() {
        guard let style = style else { return }
        
        let leftNamePadding: CGFloat = style.action != nil
            ? ((style.tagCellHeight ?? 0) * 0.4).rounded()
            : 0
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let anchors = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftNamePadding),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        anchors.forEach { $0.isActive = true }
    }
    
    func setupStyle() {
        setupTagName()
        setupTagButton()
    }
    
    func setupTagName() {
        guard let style = style else { return }
        backgroundColor = style.backgroundColor
        
        layer.cornerRadius = style.cornerRadius ?? 0
        layer.borderColor  = style.borderColor?.cgColor ?? UIColor.clear.cgColor
        layer.borderWidth  = style.borderSize ?? 0
        
        nameLabel.textColor     = style.fontColor
        nameLabel.font          = style.font
        nameLabel.textAlignment = style.action != nil ? .left : .center
        
        clipsToBounds = true
    }
    
    func setupTagButton() {
        guard let style = style, let action = style.action else { return }
        
        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        let anchors = [
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalTo: heightAnchor, constant: -4),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor)
        ]
        anchors.forEach { $0.isActive = true }
        
        setupButtonImage(style: style, action: action)
    }
    
    func setupButtonImage(style: TagCellStyle, action: TagCellStyle.TagActionType) {
        actionButton.tintColor = style.fontColor
        
        if style.customActionImage == nil {
            switch action {
            case .add:
                if #available(iOS 13.0, *) {
                    actionButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
                } else {
                    #warning("handle images pre-iOS13")
                }
            case .remove:
                if #available(iOS 13.0, *) {
                    actionButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
                } else {
                    #warning("handle images pre-iOS13")
                }
            }
        } else if let customImage = style.customActionImage {
            actionButton.setImage(customImage, for: .normal)
        }
    }
    
    func cleanUp() {
        nameLabel.removeFromSuperview()
    }
}

// MARK: - Action

private extension TagCell {
    
    @objc func onButtonTapped() {
        
    }
}
