//
//  PopoverViewController.swift
//  CraftYourProfile
//
//  Created by Дмитрий Константинов on 29.05.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {

    var tableView: UITableView? { return self.view as? UITableView }
    let searchController = UISearchController(searchResultsController: nil)

    override func loadView() {
        self.view = UITableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addSearchController()
        view.backgroundColor = .backgroundGray()

        guard let width = tableView?.frame.width else { return }
        tableView?.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1))
    }

//    override func viewWillLayoutSubviews() {
//        guard let height = tableView?.contentSize.height else { return }
//        preferredContentSize = CGSize(width: 250, height: height)
//    }

    private func addSearchController() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.sizeToFit()
        guard let tableView = tableView else { return }
        tableView.tableHeaderView = searchController.searchBar
    }
}
