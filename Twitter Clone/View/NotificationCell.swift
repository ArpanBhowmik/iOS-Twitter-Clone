//
//  NotificationCell.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 26/1/23.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: NotificationCell)
    func didTapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    static let reuseIdentifier = "NotificationCell"
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .blue
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        return profileImageView
    }()
    
    private lazy var notificationsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "some notification is going on"
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, notificationsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        
        return stackView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(stackView)
        addSubview(followButton)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -1),
            
            followButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            followButton.widthAnchor.constraint(equalToConstant: 88),
            followButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func configure() {
        guard let notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        notificationsLabel.attributedText = viewModel.notificationText
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
    }
}

extension NotificationCell {
    @objc private func handleProfileImageTapped() {
        delegate?.handleProfileImageTapped(self)
    }
    
    @objc private func handleFollowTapped() {
        delegate?.didTapFollow(self)
    }
}
