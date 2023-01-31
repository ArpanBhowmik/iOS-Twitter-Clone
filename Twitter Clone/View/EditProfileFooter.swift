//
//  EditProfileFooter.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 31/1/23.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func didTapLogout()
}

class EditProfileFooter: UIView {
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: EditProfileFooterDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            logoutButton.topAnchor.constraint(equalTo: topAnchor),
            logoutButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleLogout() {
        delegate?.didTapLogout()
    }
}
