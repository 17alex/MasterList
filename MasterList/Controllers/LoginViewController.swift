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
    private var activityIndicatorView: UIActivityIndicatorView!
    private var lineView: UIView!
    
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
        addSeparatorLine()
        addActivityIndicatorView()
        
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
        loginTextField.borderStyle = .none
        loginTextField.clearButtonMode = .always
        loginTextField.placeholder = "login"
        loginTextField.returnKeyType = .next
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTextField)
    }
    
    private func addPasswordTextField() {
        passwordtextField = UITextField()
        passwordtextField.textAlignment = .center
        passwordtextField.borderStyle = .none
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
        errorLabel.alpha = 0
        view.addSubview(errorLabel)
    }
    
    private func addActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.stopAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
    }
    
    private func addSeparatorLine() {
        lineView = UIView()
        lineView.backgroundColor = .lightGray
        lineView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineView)
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
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: passwordtextField.bottomAnchor, constant: 50).isActive = true
        
        lineView.leftAnchor.constraint(equalTo: loginTextField.leftAnchor).isActive = true
        lineView.rightAnchor.constraint(equalTo: loginTextField.rightAnchor).isActive = true
        lineView.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 4).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    private func goToListVC() {
        let listVC = ListViewController()
        present(listVC, animated: true, completion: nil)
    }
    
    @objc
    private func signInButtonPress() {
        print("signInButtonPress")
        
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showWarningLabel(withText: "fild or filds is empy")
            return
        }
        activityIndicatorView.startAnimating()
        Auth.auth().signIn(withEmail: login, password: pass) { [weak self] (result, error) in
            
            if let error = error {
                print("signIn error = \(error.localizedDescription)")
                self?.showWarningLabel(withText: error.localizedDescription)
                self?.activityIndicatorView.stopAnimating()
                
            } else if let user = result?.user {
                print("signIn user = \(user)")
                self?.activityIndicatorView.stopAnimating()
                self?.goToListVC()
                
            } else {
                self?.showWarningLabel(withText: "User not exist")
                self?.activityIndicatorView.stopAnimating()
            }
        }
        activityIndicatorView.stopAnimating()
    }
    
    @objc
    private func signUpButtonPress() {
        print("signUpButtonPress")
        
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showWarningLabel(withText: "fild or filds is empy")
            return
        }
        activityIndicatorView.startAnimating()
        Auth.auth().createUser(withEmail: login, password: pass) { [weak self] (result, error) in
            
            if let error = error {
                print("signUp error = \(error.localizedDescription)")
                self?.showWarningLabel(withText: error.localizedDescription)
                self?.activityIndicatorView.stopAnimating()
                
            } else if let user = result?.user {
                print("signUp result = \(user)")
                self?.ref.child(user.uid).setValue(["email": user.email])
                self?.activityIndicatorView.stopAnimating()
                self?.goToListVC()
            }
        }
    }
    
    private func showWarningLabel(withText text: String) {
        errorLabel.text = text
        errorLabel.alpha = 1
        
        UIView.animate(withDuration: 3) { [weak self] in
            self?.errorLabel.alpha = 0
        }
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
