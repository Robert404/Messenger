//
//  ProfileViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 10.07.21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    let data = ["Log Out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Are You Sure?", message: "We will miss you :(", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                vc.title = "Login"
                let navigation = UINavigationController(rootViewController: vc)
                navigation.modalPresentationStyle = .fullScreen
                self?.present(navigation, animated: true)
                
            } catch {
                print("Failed to Log Out")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
}
