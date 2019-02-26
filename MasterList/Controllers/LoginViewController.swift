//
//  ViewController.swift
//  MasterList
//
//  Created by Admin on 15.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    private var nameLabel: UILabel!
    private var loginTextField: UITextField!
    private var passwordtextField: UITextField!
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var errorLabel: UILabel!
    
    private var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIScrollView()
        view.backgroundColor = .white
        
        addNameLabel()
        addLoginTextField()
        addPasswordTextField()
        addSignInButton()
        addSignUpButton()
        addErrorLabel()
        
        addConstraints()
        
        loginTextField.delegate = self
        passwordtextField.delegate = self
        
        ref = Database.database().reference(withPath: "users")
        
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.goToListVC()
            }
            
            print("user =====> \(String(describing: user))")
            print("auth =====> \(auth)")
        }
        
        loginTextField.becomeFirstResponder()
    }

    private func addNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        nameLabel.textAlignment = .center
        nameLabel.text = "Master list"
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }

    private func addLoginTextField() {
        loginTextField = UITextField()
        loginTextField.textAlignment = .center
        loginTextField.borderStyle = .roundedRect
        loginTextField.placeholder = "login"
        loginTextField.returnKeyType = .next
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTextField)
    }
    
    private func addPasswordTextField() {
        passwordtextField = UITextField()
        passwordtextField.textAlignment = .center
        passwordtextField.borderStyle = .roundedRect
        passwordtextField.placeholder = "password"
        passwordtextField.returnKeyType = .next
        passwordtextField.isSecureTextEntry = true
        passwordtextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordtextField)
    }
    
    private func addSignInButton() {
        signInButton = UIButton()
//        signInButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(#colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonPress), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
    }
    
    private func addSignUpButton() {
        signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
    }
    
    private func addErrorLabel() {
        errorLabel = UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        errorLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        errorLabel.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
    }
    
    private func addConstraints() {
        
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.bottomAnchor.constraint(equalTo: loginTextField.topAnchor, constant: -100).isActive = true
        
        loginTextField.bottomAnchor.constraint(equalTo: passwordtextField.topAnchor,  constant: -10).isActive = true
        loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true

        passwordtextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        passwordtextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordtextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        passwordtextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        signInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordtextField.bottomAnchor, constant: 100).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30).isActive = true

        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 30).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        errorLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func goToListVC() {
        let listVC = ListViewController()
        present(listVC, animated: true, completion: nil)
    }
    
    @objc
    private func signInButtonPress() {
        print("signInButtonPress")
        errorLabel.isHidden = true
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showAlert(text: "fild or filds is empy")
            return
        }
        
        Auth.auth().signIn(withEmail: login, password: pass) { [weak self] (result, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("signIn error = \(error.localizedDescription)")
                DispatchQueue.main.async {
                    strongSelf.errorLabel.text = error.localizedDescription
//                    UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        strongSelf.errorLabel.isHidden = false
//                    }, completion: { (complete) in
//                        strongSelf.errorLabel.isHidden = true
//                    })
                }
                
            } else if let result = result {
                print("signIn result = \(result)")
                DispatchQueue.main.async {
                    strongSelf.goToListVC()
                }
                
            } else {
                DispatchQueue.main.async {
                    strongSelf.showAlert(text: "signIn -- no user")
                }
            }
        }
    }
    
    @objc
    private func signUpButtonPress() {
        print("signUpButtonPress")
        errorLabel.isHidden = true
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showAlert(text: "fild or filds is empy")
            return
        }

        Auth.auth().createUser(withEmail: login, password: pass) { [weak self] (result, error) in
            guard let strongSelf = self else  { return }
            
            if let error = error {
                print("signUp error = \(error)")
                DispatchQueue.main.async {
                    strongSelf.errorLabel.text = error.localizedDescription
//                    UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                        strongSelf.errorLabel.isHidden = false
//                    }, completion: { (complete) in
//                        strongSelf.errorLabel.isHidden = true
//                    })
                }

            } else if let user = result?.user {
                print("signUp result = \(user)")
                DispatchQueue.main.async {
                    let userRef = strongSelf.ref.child(user.uid)
                    userRef.setValue(["email": user.email])
                    strongSelf.goToListVC()
                }
            }
        }
    }
    
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordtextField.becomeFirstResponder()
            return true
        } else if textField == passwordtextField {
            passwordtextField.resignFirstResponder()
            return false
        }
        
        return false
    }
}
