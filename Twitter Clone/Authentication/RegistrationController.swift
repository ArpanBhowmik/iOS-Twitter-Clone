//
//  RegistrationController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 16/1/23.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_mail_outline_white_2x-1"), textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_person_outline_white_2x"), textField: fullNameTextField)
        return view
    }()
    
    private lazy var usernameContainerView = {
        let view = Utilities().inputContainerView(withImage: UIImage(named: "ic_person_outline_white_2x"), textField: userNameTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        return Utilities().textField(withPlaceholder: "Email")
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullNameTextField: UITextField = {
        return Utilities().textField(withPlaceholder: "Full Name")
    }()
    
    private let userNameTextField: UITextField = {
        return Utilities().textField(withPlaceholder: "Username")
    }()
    
    private let SignUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .twitterBlue
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusPhotoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            plusPhotoButton.widthAnchor.constraint(equalToConstant: 150),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 150)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, usernameContainerView, SignUpButton])
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        NSLayoutConstraint.activate([
            SignUpButton.heightAnchor.constraint(equalToConstant: 40),
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: plusPhotoButton.bottomAnchor, multiplier: 3),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            alreadyHaveAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            alreadyHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
}

//MARK: Actions
extension RegistrationController {
    @objc private func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }
    
    @objc private func handleRegistration() {
        guard
            let email = emailTextField.text,
            let password = passwordTextField.text,
            let fullName = fullNameTextField.text,
            let username = userNameTextField.text?.lowercased()
        else {
            return
        }
        
        AuthService.shared.registerUser(credentials: AuthCredentials(
            email: email,
            password: password,
            fullname: fullName,
            username: username,
            profileImage: profileImage ?? UIImage())) { error in
                guard error == nil else { return }
                print("[handleRegistration] user registered successfully")
                
                self.dismiss(animated: true)
            }
    }
}

//MARK: UIImagePickerControllerDelegate
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        plusPhotoButton.layer.cornerRadius = 150 / 2.0
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        dismiss(animated: true)
    }
}
