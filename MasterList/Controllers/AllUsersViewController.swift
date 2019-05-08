//
//  AllUsersViewController.swift
//  MasterList
//
//  Created by Admin on 16.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class AllUsersViewController: UIViewController {

    private var allUsersTableView: UITableView!
    private var loadingView: LoadingView!
    
    private var currentMyUser: MyUser!
    private var allUsers: [MyUser] = []
    private var myUsers: [String: String] = [:]
    
    deinit {
        print("AllUsersViewController -> deinit")
        FireBaseManager.shared.removeAllUsersObserver()
        FireBaseManager.shared.removeFrensObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "addFrends"
        addUsersTableView()
        addConstraints()
        
        allUsersTableView.dataSource = self
        allUsersTableView.delegate = self
        
        guard let currMyUser = FireBaseManager.shared.currentMyUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
            // dismiss  // TODO: - fix dismiss
        }
        currentMyUser = currMyUser
        print("user exist = \(currentMyUser.uid)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("AllUsersViewController -> viewWillAppear")
        
        showLoadingView()
        FireBaseManager.shared.createAllUsersObserver { [weak self] (allUsers) in
            self?.allUsers = allUsers
            self?.allUsers.sort(by: { (u1, u2) -> Bool in
                return u1.name < u2.name
            })
            self?.removeLoadingView()
            self?.allUsersTableView.reloadData()
        }
        
        FireBaseManager.shared.createFrendsObserverD { [weak self] (myFrends) in
            self?.myUsers = myFrends
            self?.allUsersTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("AllUsersViewController -> viewDidDisappear")
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
    
    private func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    private func removeLoadingView() {
        loadingView.removeFromSuperview()
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
            FireBaseManager.shared.remove(frend: selectMyUser)
        } else {
            FireBaseManager.shared.add(frend: selectMyUser)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

