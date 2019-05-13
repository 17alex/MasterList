//
//  ProfileViewController.swift
//  MasterList
//
//  Created by Admin on 15.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    private enum TableLineType {
        case name
    }
    
    private var profileTableView: UITableView!
    private var userRef: DatabaseReference!
    private var myUser: People!
    private var tableData: [TableLineType] = [.name]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addProfileTableView()
        addConstraint()
    }
    
    private func addProfileTableView() {
        profileTableView = UITableView()
        profileTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileTableView)
        profileTableView.register(UITableViewCell.self, forCellReuseIdentifier: "proCell")
        profileTableView.dataSource = self
        profileTableView.delegate = self
        
        guard let currentUser = Auth.auth().currentUser else { return }
        myUser = People(user: currentUser)
        userRef = Database.database().reference(withPath: "users").child(myUser.uid)
        myUser.name = userRef.value(forKey: "name") as! String
    }
    
    private func addConstraint() {
        profileTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        profileTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        profileTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proCell", for: indexPath)
        var str: String? = ""
        switch tableData[indexPath.row] {
        case .name: str = " Name: " + myUser.name
        }
        cell.textLabel?.text = str
        return cell
    }
}

extension ProfileViewController: UITableViewDelegate {
    
}
