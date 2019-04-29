//
//  ChatViewController.swift
//  MasterList
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    private var chatTableView: UITableView!
    private var chatTextField: UITextField!
    private var chatSendButton: UIButton!
    
    private var toMyFrendsPostsRef: DatabaseReference!
    private var myFrend: MyUser!
    private var currentMyUser: MyUser!
    private var myPosts: [Post] = []
    
    convenience init(myFrend: MyUser) {
        self.init()
        self.myFrend = myFrend
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let fbUser = Auth.auth().currentUser else { return } // TODO: - dismiss
        currentMyUser = MyUser(user: fbUser)
        toMyFrendsPostsRef = Database.database().reference().child("users").child("list").child(currentMyUser.uid).child("frends").child(myFrend.uid).child("posts")
        
        addChatTableView()
        addChatTextField()
        addChatSendButton()
        addConstraints()
        
        chatTextField.delegate = self
        chatTableView.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIApplication.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIApplication.keyboardDidHideNotification, object: nil)
        
        toMyFrendsPostsRef.observe(.value) { [weak self] (snapshot) in
            self?.myPosts = []
            print("snapshot posts = \(snapshot)")
            let dict = snapshot.value as? [String: String] ?? [:]
            print("dict = \(dict)")
            for item in dict {
                self?.myPosts.append(Post(time: TimeInterval(Int(item.key)!) , text: item.value))
            }
            self?.chatTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardShow(notification: NSNotification) {
        print("keyboardShow")
        guard let userInfo = notification.userInfo else { return }
        print("userInfo = \(userInfo)")
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        print("showKeyboard kbFrameSize = \(kbFrameSize)")
        let offset = kbFrameSize.height
        print("offset = \(offset)")
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.frame.origin.y -= offset
        }
    }
    
    @objc
    private func keyboardHide() {
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.frame.origin.y = 0
        }
    }
    
    @objc
    private func chatSendButtonPress() {
        
        chatTextField.resignFirstResponder()
        guard let messageText = chatTextField.text, !messageText.isEmpty else { return }
        let timeInterval = Date().timeIntervalSince1970
        print(timeInterval.description)
        toMyFrendsPostsRef.setValue([Int(timeInterval).description:messageText])
    }
    
    private func addChatTableView() {
        chatTableView = UITableView()
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.register(UITableViewCell.self, forCellReuseIdentifier: "chatCell")
        view.addSubview(chatTableView)
    }
    
    private func addChatTextField() {
        chatTextField = UITextField()
        chatTextField.backgroundColor = .white
        chatTextField.borderStyle = .roundedRect
        chatTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatTextField)
    }
    
    private func addChatSendButton() {
        chatSendButton = UIButton()
        chatSendButton.setTitle("Send", for: .normal)
        chatSendButton.setTitleColor(.red, for: .normal)
        chatSendButton.backgroundColor = .white
        chatSendButton.addTarget(self, action: #selector(chatSendButtonPress), for: .touchUpInside)
        chatSendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatSendButton)
    }

    private func addConstraints() {
        chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        chatTableView.bottomAnchor.constraint(equalTo: chatTextField.topAnchor).isActive = true
        
        chatTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        chatTextField.rightAnchor.constraint(equalTo: chatSendButton.leftAnchor).isActive = true
        chatTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        
        chatSendButton.topAnchor.constraint(equalTo: chatTextField.topAnchor).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatSendButton.bottomAnchor.constraint(equalTo: chatTextField.bottomAnchor).isActive = true
        chatSendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        chatSendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        cell.textLabel?.text = myPosts[indexPath.row].text
        cell.detailTextLabel?.text = myPosts[indexPath.row].time.description
        return cell
    }
}
