//
//  EditProfileHeader.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 30/1/23.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangeProfilePhoto()
}

class EditProfileHeader: UIView {
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.layer.cornerRadius = 100 / 2
        return imageView
    }()
    
    private lazy var changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Change Profile Photo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleChangeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        backgroundColor = .twitterBlue
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(profileImageView)
        addSubview(changePhotoButton)
        
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            changePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8)
        ])
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }
    
    @objc private func handleChangeProfilePhoto() {
        delegate?.didTapChangeProfilePhoto()
    }
}
