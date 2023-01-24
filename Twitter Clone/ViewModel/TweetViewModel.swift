//
//  TweetViewModel.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 20/1/23.
//

import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "7m"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a . MM/dd/YYYY"
        return formatter.string(from: tweet.timestamp)
    }
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var retweetsAttributedString: NSAttributedString? {
        return attributedText(with: tweet.retweetCount, text: " ReTweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributedText(with: tweet.likes, text: " likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName,
                                              attributes: [.font: UIFont.systemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        title.append(NSAttributedString(string: " · \(timestamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(with value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: text,
                                                  attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.lineBreakMode = .byWordWrapping
        measurementLabel.numberOfLines = 0
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}
