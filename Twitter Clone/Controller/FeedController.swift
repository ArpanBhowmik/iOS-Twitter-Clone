//
//  FeedController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 16/1/23.
//

import SDWebImage
import UIKit

class FeedController: UICollectionViewController {
    static let reuseIdentifier = "TweetCell"
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

    var user: User? {
        didSet {
            configureProfileImage()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationItem.titleView = imageView
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.reuseIdentifier)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func configureProfileImage() {
        guard let user else { return }
        
        let profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.backgroundColor = .systemBlue
        profileImageView.clipsToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.layer.cornerRadius = 48 / 2
        profileImageView.layer.masksToBounds = true
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTap))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(tap)
    }
    
    private func fetchTweets() {
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets.sorted(by: { $0.timestamp > $1.timestamp })
            self.checkIfUserLikedTweets()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
    
    private func checkIfUserLikedTweets() {
        tweets.forEach { tweet in
            TweetService.shared.checkIfUserLikeTweet(tweet) { didLike in
                guard didLike == true else { return }
                
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    @objc private func handleLogout() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        }
    }
    
    @objc private func handleRefresh() {
        fetchTweets()
    }
    
    @objc private func handleProfileImageTap() {
        guard let user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UICollectionView Delegate / DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        return CGSize(width: view.frame.width, height: height + 90)
    }
}

//MARK: - TweetCell Delegate
extension FeedController: TweetCellDelegate {
    func handleMentionUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func handleLike(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            guard !tweet.didLike else { return }
            NotificationService.shared.uploadNotification(type: .like, tweet: tweet)
        }
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = UploadTweetController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
