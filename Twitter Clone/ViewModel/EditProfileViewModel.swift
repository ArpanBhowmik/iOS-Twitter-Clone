//
//  EditProfileViewModel.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 30/1/23.
//

import Foundation

enum EditProfileOption: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname: return "Name"
        case .username: return "Username"
        case .bio     : return "Bio"
        }
    }
}

struct EditProfileViewModel {
    private let user: User
    let option: EditProfileOption
    
    var titleText: String {
        return option.description
    }
    
    var shouldHideTextField: Bool {
        return option == .bio
    }
    
    var shouldHideTextView: Bool {
        return option != .bio
    }
    
    var optionValue: String? {
        switch option {
        case .fullname: return user.fullName
        case .username: return user.username
        case .bio     : return user.bio
        }
    }
    
    init(user: User, option: EditProfileOption) {
        self.user = user
        self.option = option
    }
}
