//
//  ExploreController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 16/1/23.
//

import UIKit

class ExploreController: UITableViewController {
    private var users: [User] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var filteredUsers: [User] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive
        && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    private func fetchUsers() {
        UserService.shared.fetchUsers { users in
            self.users = users
        }
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

//MARK: UITableView Delegate / DataSource

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseIdentifier, for: indexPath) as! UserCell
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        
        filteredUsers = users.filter{ $0.username.lowercased().contains(searchText) }
    }
}
