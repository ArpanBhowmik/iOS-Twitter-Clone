//
//  CaptionTextView.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 19/1/23.
//

import UIKit

class CaptionTextView: UITextView {
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "What's happening?"
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            placeholderLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInputTextChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleInputTextChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
