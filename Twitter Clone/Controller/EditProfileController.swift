//
//  EditProfileController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 30/1/23.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, user: User)
}

class EditProfileController: UITableViewController {
    private var user: User
    
    private lazy var headerView = EditProfileHeader(user: user)
    private let imagePicker = UIImagePickerController()
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    private var imageChanged: Bool {
        return selectedImage != nil
    }
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        configureNavigationBar()
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    private func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.reuseIdentifier)
    }
    
    private func updateUserData() {
        UserService.shared.saveUserData(user: user) { error, ref in
            self.delegate?.controller(self, user: self.user)
            
            if self.imageChanged {
                guard let image = self.selectedImage else { return }
                UserService.shared.updateProfileImage(image: image) { url in
                    self.user.profileImageUrl = url
                    self.delegate?.controller(self, user: self.user)
                }
            }
        }
    }
}

//MARK: - Selectors

extension EditProfileController {
    @objc private func handleCancel() {
        dismiss(animated: true)
    }
    
    @objc private func handleDone() {
        view.endEditing(true)
        updateUserData()
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true)
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.reuseIdentifier, for: indexPath) as! EditProfileCell
        let option = EditProfileOption(rawValue: indexPath.row) ?? .fullname
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOption(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 100 : 48
    }
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        self.selectedImage = image
        dismiss(animated: true)
    }
}

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else { return }
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        switch viewModel.option {
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullName = fullname
        case .bio:
            user.bio = cell.bioTextView.text
        }
    }
}
