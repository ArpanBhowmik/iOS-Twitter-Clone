//
//  EditProfileCell.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 30/1/23.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    static let reuseIdentifier = "EditProfileCell"
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingDidEnd)
        return textField
    }()
    
    lazy var bioTextView: CaptionTextView = {
        let bv = CaptionTextView()
        bv.translatesAutoresizingMaskIntoConstraints = false
        bv.font = UIFont.systemFont(ofSize: 14)
        bv.textColor = .twitterBlue
        bv.placeholderLabel.text = "Bio"
        return bv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoTextField)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            infoTextField.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            infoTextField.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16),
            infoTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
    }
    
    @objc private func handleUpdateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    private func configure() {
        guard let viewModel else { return }
        
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        titleLabel.text = viewModel.titleText
        
        infoTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
    }
}
