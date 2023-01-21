//
//  MainTabController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 16/1/23.
//

import Firebase
import UIKit

class MainTabController: UITabBarController {
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            
            feed.user = user
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authenticateUserAndConfigureUI()
       // logUserOut()
    }
    
    private func configureUI() {
        view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 56),
            actionButton.widthAnchor.constraint(equalToConstant: 56),
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -64),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        actionButton.layer.cornerRadius = 56 / 2.0
    }
    
    private func configureViewControllers() {
        let feedNavigationController = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let exploreNavigationController = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())

        let notificationsNavigationController = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationsController())

        let conversationsNavigationController = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: ConversationsController())
        
        viewControllers = [feedNavigationController, exploreNavigationController, notificationsNavigationController, conversationsNavigationController]
    }
    
    private func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.navigationBar.barTintColor = .white
        return navigationController
    }
    
    private func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            print("user is Not logged in")
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            print("user is logged in")
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("failed to log out with error \(error.localizedDescription)")
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        guard let user else { return }
        let controller = UploadTweetController(user: user)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
