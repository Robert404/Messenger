//
//  LoginViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 10.07.21.
//

//func hideKeyboardWhenTappedAround() {
//    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//    tap.cancelsTouchesInView = false
//    view.addGestureRecognizer(tap)
//}

//@objc func dismissKeyboard() {
//    view.endEditing(true)
//}

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {

    private let loadSpinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailTextField: UITextField = {
        let field =  UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        field.leftViewMode = .always
        
        return field
    }()
    
    private let passwordTextField: UITextField = {
        let field =  UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let logoImage : UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo")
        logoImage.contentMode = .scaleAspectFit
        return logoImage
    }()
    
    
    private let loginButton: UIButton = {
       let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
       return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        logoImage.frame = CGRect(x: (scrollView.width - size) / 2, y: 20,
                                 width: size, height: size)
        
        emailTextField.frame = CGRect(x: 30, y: logoImage.bottom + 10,
                                      width: scrollView.width - 60, height: 52)
        
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10,
                                         width: scrollView.width - 60, height: 52)
        
        loginButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10,
                                         width: scrollView.width - 60, height: 52)
    }
    
    @objc private func loginButtonTapped() {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let email = emailTextField.text, let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty, password.count > 5 else {
            alertUserLogin()
            return
        }
        
        loadSpinner.show(in: view)
        //Firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authRes, error in
            
            DispatchQueue.main.async {
                self?.loadSpinner.dismiss()
            }
            
            guard let res = authRes, error == nil else {
                print("Error while login")
                return
            }
            
            let user = res.user
            UserDefaults.standard.setValue(email, forKey: "email")
            print("Logged in: \(user)")
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    func alertUserLogin() {
        let alert = UIAlertController(title: "Oops", message: "Entered information is not correct", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func didTapRegister() {
        let vc = RegisterViewController()
        vc.title = "Register"
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            loginButtonTapped()
        }
        
        return true
    }
}
