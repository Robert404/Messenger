//
//  NewConversationViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 10.07.21.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {
    
    private let loadSpinner = JGProgressHUD(style: .dark)

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Users..."
        return searchBar
    }()
    
    private let table: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noUsersFound: UILabel = {
        let label = UILabel()
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        
        searchBar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    
    func searchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
