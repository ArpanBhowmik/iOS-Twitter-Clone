//
//  ActionSheetCell.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 25/1/23.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    static let reuseIdentifier = "ActionSheetCell"
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private lazy var optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "twitter_logo_blue")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Options"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        contentView.backgroundColor = .white
        addSubview(optionImageView)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            optionImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            optionImageView.widthAnchor.constraint(equalToConstant: 36),
            optionImageView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.centerYAnchor.constraint(equalTo: optionImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: optionImageView.trailingAnchor, constant: 12)
        ])
    }
    
    private func configure() {
        guard let option else { return }
        titleLabel.text = option.description
    }
}
