//
//  ProfileFilterCell.swift
//  Twitter Clone
//
//  Created by Arpan Bhowmik on 22/1/23.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    static let reuseIdentifier = "ProfileFilterCell"
    
    var option: ProfileFilterOptions = .tweets {
        didSet { titleLabel.text = option.description }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
