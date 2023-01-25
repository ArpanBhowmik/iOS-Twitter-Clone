//
//  TweetController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 24/1/23.
//

import UIKit

class TweetController: UICollectionViewController {
    private var tweet: Tweet
    private var actionSheetLauncher: ActionSheetLauncher!
    
    private var replies: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchReplies()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.reuseIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseIdentifier)
    }
    
    private func fetchReplies() {
        TweetService.shared.fetchReplies(fortweet: tweet) { replies in
            self.replies = replies
        }
    }
}

//MARK: UICollectionView DataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.reuseIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

//MARK: UICollectionViewFlowLayoutDelegate
extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 260)
    }
}

//MARK: - TweetHeader Delegate
extension TweetController: TweetHeaderDelegate {
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            actionSheetLauncher = ActionSheetLauncher(user: tweet.user)
            actionSheetLauncher.delegate = self
            actionSheetLauncher.show()
        } else {
            UserService.shared.checkIfUserIsFollowed(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.actionSheetLauncher = ActionSheetLauncher(user: user)
                self.actionSheetLauncher.delegate = self
                self.actionSheetLauncher.show()
            }
        }
    }
}

extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("DEBUG followed user \(user.uid)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("DEBUG unfollowed user \(user.uid)")
            }
        case .report:
            print("DEBUG report")
        case .delete:
            print("DEBUG delete")
        }
    }
}
