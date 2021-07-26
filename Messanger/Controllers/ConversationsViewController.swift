//
//  ViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 10.07.21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {

    private let progressSpinner = JGProgressHUD(style: .dark)
    
    private let table: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    private let noMessages: UILabel = {
        let label = UILabel()
        label.text = "No messager"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        view.addSubview(table)
        view.addSubview(noMessages)
        setupTable()
        fetchConversations()
    }
    
    @objc private func didTapCompose() {
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateLogin()
    }
    
    private func validateLogin() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            vc.title = "Login"
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            present(navigation, animated: true)
        }
    }
    
    private func setupTable() {
        table.delegate = self
        table.dataSource = self
    }
    
    private func  fetchConversations() {
        table.isHidden = false
    }
}



extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Robert Ners"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
