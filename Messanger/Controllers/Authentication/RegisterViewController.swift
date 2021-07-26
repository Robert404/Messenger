//
//  RegisterViewController.swift
//  Messanger
//
//  Created by Robert Nersesyan on 10.07.21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
    private let loadSpinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let firstNameTextField: UITextField = {
        let field =  UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        
        return field
    }()
    
    private let lastNameTextField: UITextField = {
        let field =  UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 15
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        
        return field
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
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
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
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let logoImage : UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(systemName: "person.circle")
        logoImage.tintColor = .gray
        logoImage.contentMode = .scaleAspectFit
        logoImage.layer.masksToBounds = true
        logoImage.layer.borderWidth = 2
        logoImage.layer.borderColor = UIColor.lightGray.cgColor
        return logoImage
    }()
    
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .systemGreen
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(logoImage)
        scrollView.addSubview(firstNameTextField)
        scrollView.addSubview(lastNameTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(registerButton)
        
        logoImage.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        logoImage.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic() {
        photoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width / 3
        logoImage.frame = CGRect(x: (scrollView.width - size) / 2, y: 20,
                                 width: size, height: size)
        
        logoImage.layer.cornerRadius = logoImage.width / 2
        
        firstNameTextField.frame = CGRect(x: 30, y: logoImage.bottom + 10,
                                          width: scrollView.width - 60, height: 52)
        
        lastNameTextField.frame = CGRect(x: 30, y: firstNameTextField.bottom + 10,
                                         width: scrollView.width - 60, height: 52)
        
        emailTextField.frame = CGRect(x: 30, y: lastNameTextField.bottom + 10,
                                      width: scrollView.width - 60, height: 52)
        
        passwordTextField.frame = CGRect(x: 30, y: emailTextField.bottom + 10,
                                         width: scrollView.width - 60, height: 52)
        
        registerButton.frame = CGRect(x: 30, y: passwordTextField.bottom + 10,
                                      width: scrollView.width - 60, height: 52)
    }
    
    @objc private func registerButtonTapped() {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
              let email = emailTextField.text, let password = passwordTextField.text,
              !email.isEmpty, !password.isEmpty,!firstName.isEmpty,
              !lastName.isEmpty, password.count > 5 else {
            alertUserLogin()
            return
        }
        
        loadSpinner.show(in: view)
        
        DatabaseManager.shared.isUserExists(with: email) { [weak self] exist in
            
            DispatchQueue.main.async {
                self?.loadSpinner.dismiss()
            }
            
            guard !exist else {
                self?.alertUserLogin(message: "User already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self] authRes, error in
                
                guard authRes != nil, error == nil else {
                    print("Error")
                    return
                }
                
                let user = MessengerAppUser(firstName: firstName,
                                            lastName: lastName,
                                            email: email)
                
                DatabaseManager.shared.insertUserToDb(with: user, completion: { success in
                    if success {
                        //upload image
                        guard let image = self?.logoImage.image,
                              let data = image.pngData() else {
                            
                            return
                        }
                        
                        let fileName = user.profilePicFileName
                        StorageManager.shared.uploadPicture(with: data, name: fileName, completion: { result in
                            switch result {
                            case .success(let urlString):
                                UserDefaults.standard.setValue(urlString, forKey: "pic_url_string")
                                print(urlString)
                            case .failure(let error):
                                print("Storage manager error: \(error)")
                            }
                        })
                    }
                })
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func alertUserLogin(message: String = "Please enter values") {
        let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            registerButtonTapped()
        }
        
        return true
    }
    
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func photoActionSheet() {
        let action = UIAlertController(title: "Picture for Profile",
                                       message: "How would you like to select a picture", preferredStyle: .alert)
        
        action.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        action.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentGallery()
        }))
        
        action.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        present(action, animated: true)
    }
    
    func presentGallery() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.logoImage.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
