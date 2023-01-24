//
//  UploadTweetController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 19/1/23.
//

import UIKit

class UploadTweetController: UIViewController {
    private var user: User
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2.0
        
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        imageView.backgroundColor = .twitterBlue
        imageView.layer.cornerRadius = 48 / 2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private let captionTextView = CaptionTextView()
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()
        
        let stackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 2)
        ])
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}

//MARK: - Selectors

extension UploadTweetController {
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        
        TweetService.shared.uploadTweet(caption: caption) { error, ref in
            if let error {
                print("uploading tweet failed with error: \(error.localizedDescription)")
                return
            }
            self.dismiss(animated: true)
        }
    }
}
