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

    private var usersTableView: UITableView!
    
    private var myUsers: [MyUser] = []
    private var currentMyUser: MyUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        configNavController()
        addUsersTableView()
        addConstraints()
        usersTableView.dataSource = self
        usersTableView.delegate = self

        guard let currentUser = Auth.auth().currentUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
        }
        print("MyUsersViewController user exist")
        currentMyUser = MyUser(user: currentUser)
        
        let myUsersRef = Database.database().reference(withPath: "users").child(currentMyUser.uid).child("myUsers")
        

        myUsersRef.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let dd = item as! DataSnapshot
                print("dd = \(dd)")
                let ss = dd.value as! [String: String]
                print("ss = \(ss)")
                let vv = ss["userUID"]! as String
                print("===> \(vv)")
                self.myUsers.append(MyUser(uid: vv, name: "11"))
                self.usersTableView.reloadData()
            }
        }
        
        print("test")
//        for item in arrayUserId {
//            let myUser = MyUser(uid: item.key, name: item.value)
//            myUsers.append(myUser)
//        }
    }
    
    private func configNavController() {
        
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButton))
        let leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(signOutButton))
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
    private func addTaskButton() {
        
        print(#function)
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

extension MyUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersList", for: indexPath)
        cell.textLabel?.text = myUsers[indexPath.row].uid
        return cell
    }
}

extension MyUsersViewController: UITableViewDelegate {
    
}
