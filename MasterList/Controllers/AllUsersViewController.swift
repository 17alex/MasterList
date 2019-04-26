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

    private var allUsersTableView: UITableView!
    
    private var allUsersRef: DatabaseReference!
    private var myUsersRef: DatabaseReference!
    private var currentUser: MyUser!
    private var allUsers: [MyUser] = []
    private var myUsers: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUsersTableView()
        addConstraints()
        
        allUsersTableView.dataSource = self
        allUsersTableView.delegate = self
        
        guard let user = Auth.auth().currentUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            // dismiss  // TODO: - fix dismiss
            return
        }
        currentUser = MyUser(user: user)
        print("user exist = \(currentUser.uid)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        allUsersRef = Database.database().reference().child("users").child("list")

        allUsersRef.observe(.value) { [weak self] (snapshot) in
            self?.allUsers = []
            for item in snapshot.children {
                let snap = item as! DataSnapshot
                let snapValue = snap.value as! [String: AnyObject]
                let uid = snapValue["uid"] as! String
                let name = snapValue["name"] as! String
                let myUser = MyUser(uid: uid, name: name)
                if myUser.uid != self?.currentUser.uid {
                    self?.allUsers.append(myUser)
                }
            }
            self?.allUsersTableView.reloadData()
        }
        
        myUsersRef = Database.database().reference().child("users").child("list").child(currentUser.uid).child("myUsers")
        
        myUsersRef.observe(.value) { [weak self] (snapshot) in
            self?.myUsers = snapshot.value as? [String: String] ?? [:]
            self?.allUsersTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        allUsersRef.removeAllObservers()
    }
    
    private func addUsersTableView() {
        allUsersTableView = UITableView()
        allUsersTableView.translatesAutoresizingMaskIntoConstraints = false
        allUsersTableView.register(UITableViewCell.self, forCellReuseIdentifier: "usersList")
        view.addSubview(allUsersTableView)
    }
    
    private func addConstraints() {
        allUsersTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        allUsersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        allUsersTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        allUsersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension AllUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersList", for: indexPath)
        let user = allUsers[indexPath.row]
        cell.textLabel?.text = user.name
        let check = myUsers.keys.contains(allUsers[indexPath.row].uid)
        cell.accessoryType = check ? .checkmark : .none
        return cell
    }
}

extension AllUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let selectMyUser = allUsers[indexPath.row]
        if cell?.accessoryType == .checkmark {
            myUsers.removeValue(forKey: selectMyUser.uid)
        } else {
            myUsers[selectMyUser.uid] = selectMyUser.name
        }
        myUsersRef.setValue(myUsers)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

