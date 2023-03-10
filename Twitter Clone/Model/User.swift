//
//  User.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 19/1/23.
//

import Foundation
import Firebase

struct User {
    var fullName: String
    let email: String
    var username: String
    var profileImageUrl: URL?
    let uid: String
    var isFollowed = false
    var stats: UserRelationStats?
    var bio: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        
        guard let profileImageUrlString = dictionary["profileImageUrl"] as? String, let url = URL(string: profileImageUrlString) else { return }
        self.profileImageUrl = url
    }
}

struct UserRelationStats {
    var followers: Int
    var following: Int
}
