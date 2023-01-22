//
//  ProfileHeaderViewModel.swift
//  Twitter Clone
//
//  Created by Arpan Bhowmik on 23/1/23.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "likes"
        }
    }
}
