//
//  UsersViewController.swift
//  MasterList
//
//  Created by Admin on 16.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class MyUsersViewController: UIViewController {

    private var myUsersTableView: UITableView!
    
    private var myUsersRef: DatabaseReference!
    private var myUsers: [MyUser] = []
    private var currentMyUser: MyUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        configNavController()
        addUsersTableView()
        addConstraints()
        myUsersTableView.dataSource = self
        myUsersTableView.delegate = self

        guard let currentUser = Auth.auth().currentUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
        }
        print("MyUsersViewController user exist")
        currentMyUser = MyUser(user: currentUser)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillAppear(true)
        
        // как JSON декодировать попробовать
        myUsersRef = Database.database().reference().child("users").child("list").child(currentMyUser.uid).child("frends")
        
        myUsersRef.observe(.value) { [weak self] (snapshot) in
            self?.myUsers = []
            print("snapshot = \(snapshot)")
            let dict = snapshot.value as? [String: Any] ?? [:]
            print("dict = \(dict)")
            for item in dict {
                let dic = item.value as? [String: Any] ?? [:]
                let id = dic["uid"] as! String
                let name = dic["name"] as! String
                let myUser = MyUser(uid: id, name: name)
                self?.myUsers.append(myUser)
            }
            self?.myUsersTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        myUsersRef.removeAllObservers()
    }
    
    private func configNavController() {
//        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMyUsersButton))
        let rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(addMyUsersButton))
//        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signOutButton))
        let leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .done, target: self, action: #selector(signOutButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc
    private func signOutButton() {
        
        do {
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        } catch {
            print("error = \(error.localizedDescription)")
        }
    }
    
    @objc
    private func addMyUsersButton() {
        
        let allUsersVC = AllUsersViewController()
        navigationController?.pushViewController(allUsersVC, animated: true)
    }

    private func addUsersTableView() {
        myUsersTableView = UITableView()
        myUsersTableView.translatesAutoresizingMaskIntoConstraints = false
        myUsersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "usersList")
        view.addSubview(myUsersTableView)
    }

    private func addConstraints() {
        myUsersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        myUsersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        myUsersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        myUsersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension MyUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersList", for: indexPath)
        cell.textLabel?.text = myUsers[indexPath.row].name
        return cell
    }
}

extension MyUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // index
        let frend = myUsers[indexPath.row]
        navigationController?.pushViewController(ChatViewController(myFrend: frend), animated: true)
    }
}
