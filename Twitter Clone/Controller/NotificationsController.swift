//
//  NotificationsController.swift
//  Twitter Clone
//
//  Created by m-arpan-b on 16/1/23.
//

import UIKit

class NotificationsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    

    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notifications"
    }
}
