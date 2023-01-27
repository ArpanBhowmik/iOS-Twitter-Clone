//
//  ProfileHeader.swift
//  Twitter Clone
//
//  Created by Arpan Bhowmik on 22/1/23.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismiss()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {
    static let reuseIdentifier = "ProfileHeader"
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 80 / 2
        
        return imageView
    }()
    
    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 1.25
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        button.layer.cornerRadius = 36 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "This is an user bio that will span for more than one line for test purposes"
        return label
    }()
    
    private lazy var userDetailsStackView: UIStackView = {
        let userDetailsStack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel, bioLabel])
        userDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.axis = .vertical
        userDetailsStack.spacing = 4
        
        return userDetailsStack
    }()
    
    private lazy var filterBar: ProfileFilterView = {
        let filterBar = ProfileFilterView()
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        filterBar.delegate = self
        
        return filterBar
    }()
    
    private lazy var followingLabel: UILabel = {
        let label = UILabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var followersLabel: UILabel = {
        let label = UILabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTap))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var followStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(containerView)
        containerView.addSubview(backButton)
        addSubview(profileImageView)
        addSubview(editProfileFollowButton)
        addSubview(userDetailsStackView)
        addSubview(filterBar)
        addSubview(followStack)
                
        NSLayoutConstraint.activate([
            //containerView
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 108),
            
            //backButton
            backButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 42),
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            //ProfileImageView
            profileImageView.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            profileImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: containerView.leadingAnchor, multiplier: 1),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            //editProfileFollowButton
            editProfileFollowButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12),
            editProfileFollowButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            editProfileFollowButton.widthAnchor.constraint(equalToConstant: 100),
            editProfileFollowButton.heightAnchor.constraint(equalToConstant: 36),
            
            //userDetailsStackView
            userDetailsStackView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            userDetailsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            userDetailsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            //filterBar
            filterBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            filterBar.heightAnchor.constraint(equalToConstant: 50),
                        
            //followStack
            followStack.topAnchor.constraint(equalTo: userDetailsStackView.bottomAnchor, constant: 8),
            followStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func configure() {
        guard let user else { return }
        
        let viewModel = ProfileHeaderViewModel(user: user)
        
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        
        usernameLabel.text = viewModel.userName
        fullNameLabel.text = user.fullName
    }
}

//MARK: - Selectors
extension ProfileHeader {
    @objc private func handleDismiss() {
        delegate?.handleDismiss()
    }
    
    @objc private func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc private func handleFollowingTap() {
        
    }
    
    @objc private func handleFollowersTap() {
        
    }
}

//MARK: - FilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {

    }
}
