//
//  UserCell.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 23/1/23.
//

import UIKit

class UserCell: UITableViewCell {
    var user: User? {
        didSet { configure() }
    }
    
    static let reuseIdentifier = "UserCell"
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .blue
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        
        return profileImageView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "username"
        
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "fullname"
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(profileImageView)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            //profileImageView
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            //stackView
            stackView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12)
        ])
    }
    
    private func configure() {
        guard let user else { return }
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        usernameLabel.text = user.username
        fullnameLabel.text = user.fullName
    }
}
