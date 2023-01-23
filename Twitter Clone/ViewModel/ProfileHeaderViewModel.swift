//
//  ProfileHeaderViewModel.swift
//  Twitter Clone
//
//  Created by Arpan Bhowmik on 23/1/23.
//

import Firebase
import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    var userName: String {
        return "@\(user.username)"
    }
    
    var followersString: NSAttributedString? {
        return attributedText(with: 2, text: " followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(with: 4, text: " following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollowed ? "Following" : "Follow"
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributedText(with value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
