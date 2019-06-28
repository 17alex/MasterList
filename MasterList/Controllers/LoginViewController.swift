//
//  ViewController.swift
//  MasterList
//
//  Created by Admin on 15.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    private var nameLabel: UILabel!
    private var loginTextField: UITextField!
    private var passwordtextField: UITextField!
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var errorLabel: UILabel!
    private var activityIndicatorView: UIActivityIndicatorView!
    private var lineView: UIView!
    private let storedManager: StoredProtocol
    private let coordinator: Coordinator
    private let logedInAction: () -> Void
    
    init(_ storedManager: StoredProtocol, coordinator: Coordinator, _ logedInAction: @escaping () -> Void) {
        self.storedManager = storedManager
        self.coordinator = coordinator
        self.logedInAction = logedInAction
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
        loginTextField.text = ""
        passwordtextField.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if storedManager.currentMyUser != nil {
            print("LoginViewController -> user exist")
            goToFrendsViewController()
        } else {
            print("LoginViewController -> user not logined")
            loginTextField.becomeFirstResponder()
        }
    }
    
    private func addNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 30, weight: .light)
        nameLabel.textAlignment = .center
        nameLabel.text = "Master List"
        nameLabel.textColor = .red
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
    }

    private func addLoginTextField() {
        loginTextField = UITextField()
        loginTextField.textAlignment = .center
        loginTextField.borderStyle = .none
        loginTextField.clearButtonMode = .whileEditing
        loginTextField.placeholder = "login"
        loginTextField.returnKeyType = .next
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginTextField)
    }
    
    private func addPasswordTextField() {
        passwordtextField = UITextField()
        passwordtextField.textAlignment = .center
        passwordtextField.borderStyle = .none
        passwordtextField.clearButtonMode = .whileEditing
        passwordtextField.placeholder = "password"
        passwordtextField.returnKeyType = .done
        passwordtextField.isSecureTextEntry = true
        passwordtextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordtextField)
    }
    
    private func addSignInButton() {
        signInButton = UIButton()
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        signInButton.setTitleColor(#colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonPress), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInButton)
    }
    
    private func addSignUpButton() {
        signUpButton = UIButton()
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        signUpButton.setTitleColor(#colorLiteral(red: 0, green: 0.7049999833, blue: 1, alpha: 1), for: .normal)
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
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func goToFrendsViewController() {
        logedInAction()
        print("goToFrendsViewController")
    }
    
    private func presentAlertForEnterName(complition: @escaping (_ name: String) -> Void) {
        
        let alertController = UIAlertController(title: "Enter", message: "your name", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: nil)
        let saveAction = UIAlertAction(title: "Ok", style: .default, handler: { (_) in
            if let nameText = alertController.textFields?.first?.text {
                if nameText.isEmpty {
                    complition("noName")
                } else {
                    complition(nameText)
                }
            }
        })
        
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func signInButtonPress() {
        
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showWarningLabel(withText: "fild(s) is empty")
            return
        }
        
        activityIndicatorView.startAnimating()
        
        storedManager.userSignIn(withEmail: login, password: pass) { [weak self] (fbError) in
            switch fbError {
            case .error(let errText):
                self?.showWarningLabel(withText: errText)
            case .success:
                self?.goToFrendsViewController()
            }
            self?.activityIndicatorView.stopAnimating()
        }
    }
    
    @objc
    private func signUpButtonPress() {
        print("===== SIGN UP ========")
        guard let login = loginTextField.text, let pass = passwordtextField.text, login != "", pass != "" else {
            showWarningLabel(withText: "fild(s) is empty")
            return
        }
        
        activityIndicatorView.startAnimating()
        
        storedManager.userSignUp(withEmail: login, password: pass) { [weak self] (fbError) in
            switch fbError {
            case .error(let errText):
                self?.showWarningLabel(withText: errText)
            case .success:
                self?.presentAlertForEnterName(complition: { [weak self] (name) in
                    self?.storedManager.save(userName: name)
                    self?.goToFrendsViewController()
                })
            }
            self?.activityIndicatorView.stopAnimating()
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
