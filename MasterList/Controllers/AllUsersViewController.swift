//
//  AllUsersViewController.swift
//  MasterList
//
//  Created by Admin on 16.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class AllUsersViewController: UIViewController {

    private var usersTableView: UITableView!
    
    private var allUsers: [MyUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUsersTableView()
        addConstraints()
        
        let ref = Database.database().reference()
        
        let arrayUserId = ref.value(forKey: "users") as! [User]
        for item in arrayUserId {
            var myUser = MyUser(user: item)
            myUser.name = ref.child(myUser.uid).value(forKey: "name") as! String
            allUsers.append(myUser)
        }
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
    }
    
    private func addUsersTableView() {
        usersTableView = UITableView()
        usersTableView.translatesAutoresizingMaskIntoConstraints = false
        usersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "usersList")
        view.addSubview(usersTableView)
    }
    
    private func addConstraints() {
        usersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        usersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        usersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        usersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AllUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersList", for: indexPath)
        cell.textLabel?.text = allUsers[indexPath.row].name
        return cell
    }
}

extension AllUsersViewController: UITableViewDelegate {
    
}

