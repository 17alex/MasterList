//
//  ChatViewController.swift
//  MasterList
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private var chatTableView: UITableView!
    private var chatTextField: UITextField!
    private var chatSendButton: UIButton!
    private var loadingView: LoadingView!
    
    private var myFrend: People!
    private var currentMyUser: People!
    private var myPosts: [Post] = []
    private let storedManager: StoredProtocol
    
    init(myFrend: People, _ storedManager: StoredProtocol) {
        self.myFrend = myFrend
        self.storedManager = storedManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        storedManager.removeChatObserver(forUser: myFrend)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let currMyUser = storedManager.currentMyUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
            // TODO: - Dissmis
        }
        currentMyUser = currMyUser
        
        addChatTableView()
        addChatTextField()
        addChatSendButton()
        addConstraints()
        
        chatTextField.delegate = self
        chatTableView.dataSource = self
        chatTableView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showLoadingView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        storedManager.createChatObserver(forUser: myFrend) { [weak self] (posts) in
            self?.myPosts = posts
            self?.myPosts.sort(by: { (m1, m2) -> Bool in
                return m1.time < m2.time
            })
            self?.chatTableView.reloadData()
            if let numberRows = self?.myPosts.count {
                let scrollRow = numberRows == 0 ? 0 : numberRows - 1
                if scrollRow > 0 {
                    self?.chatTableView.scrollToRow(at: IndexPath(row: scrollRow , section: 0), at: .middle, animated: true)
                }
            }
            self?.removeLoadingView()
        }
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardShow(notification: NSNotification) {
//        print("keyboardShow")
        guard let userInfo = notification.userInfo else { return }
//        print("userInfo = \(userInfo)")
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
//        print("showKeyboard kbFrameSize = \(kbFrameSize)")
        let offset = kbFrameSize.height
//        print("offset = \(offset)")
        
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.view.frame.size.height -= offset
        }) { [weak self] (_) in
            if let numberRows = self?.myPosts.count {
                let scrollRow = numberRows == 0 ? 0 : numberRows - 1
                if scrollRow > 0 {
                    self?.chatTableView.scrollToRow(at: IndexPath(row: scrollRow , section: 0), at: .middle, animated: true)
                }
            }
        }
    }
    
    @objc
    private func keyboardHide() {
        
        UIView.animate(withDuration: 0.25) { [weak self] in
//            self?.view.frame.origin.y = 0
            self?.view.frame.size.height = UIScreen.main.bounds.height
        }
    }
    
    @objc
    private func chatSendButtonPress() {
        
        guard let messageText = chatTextField.text, !messageText.isEmpty else { return }
        let timeInterval = Date().timeIntervalSince1970
        myPosts.append(Post(time: timeInterval, text: messageText))
        chatTextField.text = ""
        var dict: [String: String] = [:]
        for item in myPosts {
            dict[Int(item.time).description] = item.text
        }
        storedManager.set(posts: dict, forUser: myFrend)
    }
    
    private func addChatTableView() {
        chatTableView = UITableView()
        chatTableView.backgroundColor = .white
        chatTableView.separatorStyle = .none
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
        view.addSubview(chatTableView)
    }
    
    private func addChatTextField() {
        chatTextField = UITextField()
        chatTextField.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatTextField.borderStyle = .roundedRect
        chatTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatTextField)
    }
    
    private func addChatSendButton() {
        chatSendButton = UIButton()
        chatSendButton.setTitle("Send", for: .normal)
        chatSendButton.setTitleColor(.red, for: .normal)
        chatSendButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatSendButton.addTarget(self, action: #selector(chatSendButtonPress), for: .touchUpInside)
        chatSendButton.layer.cornerRadius = 5
        chatSendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatSendButton)
    }

    private func addConstraints() {
        chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        chatTableView.bottomAnchor.constraint(equalTo: chatTextField.topAnchor, constant: -8).isActive = true
        
        chatTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        chatTextField.rightAnchor.constraint(equalTo: chatSendButton.leftAnchor, constant: -8).isActive = true
        chatTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        chatSendButton.topAnchor.constraint(equalTo: chatTextField.topAnchor).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        chatSendButton.bottomAnchor.constraint(equalTo: chatTextField.bottomAnchor).isActive = true
        chatSendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        chatSendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    private func removeLoadingView() {
        loadingView.removeFromSuperview()
    }
}

extension ChatViewController: UITextFieldDelegate {
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        print("textFieldShouldEndEditing")
//        return true
//    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        cell.messText = myPosts[indexPath.row].text
        cell.messTime = myPosts[indexPath.row].time
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        chatTextField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
