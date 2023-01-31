//
//  TweetHeader.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 24/1/23.
//

import ActiveLabel
import UIKit

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    static let reuseIdentifier = "TweetHeader"
    weak var delegate: TweetHeaderDelegate?
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .blue
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.layer.masksToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true
        
        return profileImageView
    }()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Arpan Bhowmik"
        
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "@arpancse"
        
        return label
    }()
    
    private lazy var nameStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [fullNameLabel, usernameLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        
        return stack
    }()
    
    private lazy var profileStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, nameStackView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    private lazy var captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20)
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "6:33 PM - 1/28/2"
        
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "2 ReTweets"
        
        return label
    }()
    
    private lazy var likessLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Likes"
        
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let divider1 = UIView()
        divider1.translatesAutoresizingMaskIntoConstraints = false
        divider1.backgroundColor = .systemGroupedBackground
        view.addSubview(divider1)
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likessLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
        
        let divider2 = UIView()
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.backgroundColor = .systemGroupedBackground
        view.addSubview(divider2)
        
        NSLayoutConstraint.activate([
            divider1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider1.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider1.topAnchor.constraint(equalTo: view.topAnchor),
            divider1.heightAnchor.constraint(equalToConstant: 1),
            
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            
            divider2.leadingAnchor.constraint(equalTo: divider1.leadingAnchor),
            divider2.trailingAnchor.constraint(equalTo: divider1.trailingAnchor),
            divider2.heightAnchor.constraint(equalToConstant: 1),
            divider2.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }()
    
    private lazy var commentButton: UIButton = {
        let button = createButton(withImageName: "comment")
        button.addTarget(self, action: #selector(handleCommentTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = createButton(withImageName: "retweet")
        button.addTarget(self, action: #selector(handleReTweetTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = createButton(withImageName: "like")
        button.addTarget(self, action: #selector(handleLikeTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = createButton(withImageName: "share")
        button.addTarget(self, action: #selector(handleShareTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 72
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(profileStackView)
        addSubview(captionLabel)
        addSubview(dateLabel)
        addSubview(optionsButton)
        addSubview(statsView)
        addSubview(actionStack)
        
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            optionsButton.centerYAnchor.constraint(equalTo: profileStackView.centerYAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: optionsButton.trailingAnchor, multiplier: 1),
            
            captionLabel.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            statsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            statsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            statsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            statsView.heightAnchor.constraint(equalToConstant: 40),
            
            actionStack.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 16),
            actionStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func createButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .darkGray
        button.setImage(UIImage(named: imageName), for: .normal)
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return button
    }
    
    private func configure() {
        guard let tweet else { return }
        
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = tweet.caption
        usernameLabel.text = viewModel.usernameText
        fullNameLabel.text = tweet.user.fullName
        profileImageView.sd_setImage(with: viewModel.profileImageUrl)
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
    }
}

extension TweetHeader {
    @objc private func handleProfileImageTapped() {
        
    }
    
    @objc private func showActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc private func handleCommentTap() {
        
    }
    
    @objc private func handleReTweetTap() {
        
    }
    
    @objc private func handleLikeTap() {
        
    }
    
    @objc private func handleShareTap() {
        
    }
}
