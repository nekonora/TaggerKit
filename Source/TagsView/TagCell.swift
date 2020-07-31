//
//  TagCell.swift
//  TaggerKit
//
//  Created by Filippo Zaffoni on 28/02/2020.
//  Copyright © 2020 Filippo Zaffoni. All rights reserved.
//

import UIKit

@available(iOS 13, *)
internal class TagCell: UICollectionViewCell {
    
    static let reuseId = "TagCell"
    
    // MARK: - Properties
    private var style: TagCellStyle?
    private var tagConfig: Tag?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        return button
    }()
    
    // MARK: - Lifecycle
    func setupWith(_ tag: Tag, tagStyle: TagCellStyle, onButtonTapped: ((Tag) -> Void)? = nil) {
        tagConfig = tag
        style = tagStyle
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
        nameLabel.text = tagConfig?.name
        let rightNamePadding: CGFloat = style.action != nil
            ? style.tagCellHeight.rounded()
            : 10
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let anchors = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightNamePadding)
        ]
        anchors.forEach { $0.isActive = true }
        
        setupStyle()
    }
    
    func setupStyle() {
        setupNameLayout()
        setupTagButton()
    }
    
    func setupNameLayout() {
        guard let style = style else { return }
        backgroundColor = style.backgroundColor
        
        layer.cornerRadius = style.cornerRadius
        layer.borderColor = style.borderColor.cgColor
        layer.borderWidth = style.borderSize
        
        nameLabel.textColor = style.fontColor
        nameLabel.font = style.font
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
            case .add:    actionButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
            case .remove: actionButton.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
            }
        } else if let customImage = style.customActionImage {
            actionButton.setImage(customImage, for: .normal)
        }
    }
    
    func cleanUp() {
        nameLabel.removeFromSuperview()
        actionButton.removeFromSuperview()
        nameLabel.text = nil
        actionButton.setImage(nil, for: .normal)
        tagConfig = nil
    }
}
