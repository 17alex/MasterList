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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIScrollView()
        view.backgroundColor = #colorLiteral(red: 0.4784313725, green: 0.568627451, blue: 1, alpha: 1)
        addNameLabel()
        addLoginTextField()
        addPasswordTextField()
        addSignInButton()
        addSignUpButton()
        addConstraints()
        loginTextField.delegate = self
        passwordtextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(heidKeyboard), name: UIApplication.keyboardDidHideNotification, object: nil)
        loginTextField.becomeFirstResponder()
    }

    @objc
    private func showKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        print("showKeyboard kbFrameSize = \(kbFrameSize)")
        (view as! UIScrollView).contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + kbFrameSize.height)
    }
    
    @objc
    private func heidKeyboard() {
        print("heidKeyboard")
        (view as! UIScrollView).contentSize = CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    private func addNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        nameLabel.textAlignment = .center
        nameLabel.text = "Master list"
        nameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }

    private func addLoginTextField() {
        loginTextField = UITextField()
        loginTextField.textAlignment = .center
        loginTextField.borderStyle = .none
        loginTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        loginTextField.placeholder = "login"
        loginTextField.returnKeyType = .next
        loginTextField.layer.cornerRadius = 16
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTextField)
    }
    
    private func addPasswordTextField() {
        passwordtextField = UITextField()
        passwordtextField.textAlignment = .center
        passwordtextField.borderStyle = .none
        passwordtextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        passwordtextField.placeholder = "password"
        passwordtextField.returnKeyType = .next
        passwordtextField.layer.cornerRadius = 16
        passwordtextField.isSecureTextEntry = true
        passwordtextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordtextField)
    }
    
    private func addSignInButton() {
        signInButton = UIButton()
        signInButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        signInButton.layer.cornerRadius = 16
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(#colorLiteral(red: 0.4784313725, green: 0.568627451, blue: 1, alpha: 1), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonPress), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
    }
    
    private func addSignUpButton() {
        signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonPress), for: .touchUpInside)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signUpButton)
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
        signInButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signInButton.topAnchor.constraint(equalTo: passwordtextField.bottomAnchor, constant: 100).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 30).isActive = true

    }
    
    @objc
    private func signInButtonPress() {
        print("signInButtonPress")

        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            show(text: "fild is empy")
            return
        }
        
        Auth.auth().signIn(withEmail: login, password: pass) { [weak self] (result, error) in
            if let error = error {
                print("signIn error = \(error)")
            } else if let result = result {
                print("signIn result = \(result)")
                let listVC = ListViewController()
                self?.present(listVC, animated: true, completion: nil)
            } else {
                self?.show(text: "signIn -- no user")
            }
        }
    }
    
    @objc
    private func signUpButtonPress() {
        print("signUpButtonPress")
        
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            show(text: "fild is empy")
            return
        }
        
        Auth.auth().createUser(withEmail: login, password: pass) { (result, error) in
            if let error = error {
                print("signUp error = \(error)")
            } else if let result = result {
                print("signUp result = \(result)")
            }
        }
    }
    
    func show(text: String) {
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
