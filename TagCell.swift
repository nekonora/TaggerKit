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
    
    lazy var nameLabel: UILabel = {
        let label           = UILabel()
        label.textColor     = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    func setupWith(_ tagName: String, tagStyle: TagCellStyle? = nil) {
        setupUI()
        
        nameLabel.text = tagName
        style          = tagStyle
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cleanUp()
    }
}

// MARK: - Setup

private extension TagCell {
    
    func setupUI() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let anchors = [
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -2),
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
        backgroundColor     = style.backgroundColor
        layer.cornerRadius  = style.cornerRadius ?? 0
        
        layer.borderColor   = style.borderColor?.cgColor ?? UIColor.clear.cgColor
        layer.borderWidth   = style.borderSize ?? 0
        
        nameLabel.textColor = style.fontColor
        nameLabel.font      = style.font
        
        clipsToBounds = true
    }
    
    func setupTagButton() {
        guard style?.action != nil else { return }
        
        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false

        let anchors = [
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2),
            actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            actionButton.heightAnchor.constraint(equalTo: heightAnchor, constant: -4),
            actionButton.widthAnchor.constraint(equalTo: actionButton.heightAnchor)
        ]
        anchors.forEach { $0.isActive = true }
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
