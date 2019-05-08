//
//  UsersViewController.swift
//  MasterList
//
//  Created by Admin on 16.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MyUsersViewController: UIViewController {

    private var myUsersTableView: UITableView!
    private var loadingView: LoadingView!
    
    private var myUsers: [MyUser] = []
    private var currentMyUser: MyUser?
    
    deinit {
        print("MyUsersViewController -> deinit")
        FireBaseManager.shared.removeFrensObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "myFrends"
        configNavController()
        addUsersTableView()
        addConstraints()
        myUsersTableView.dataSource = self
        myUsersTableView.delegate = self

        guard let currMyUser = FireBaseManager.shared.currentMyUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
        }
        currentMyUser = currMyUser
        print("MyUsersViewController user exist")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MyUsersViewController -> viewDidAppear")

        showLoadingView()
        FireBaseManager.shared.createFrendsObserver { [weak self] (myUsers) in
            self?.myUsers = myUsers
            self?.myUsers.sort(by: { (u1, u2) -> Bool in
                return u1.name < u2.name
            })
            self?.removeLoadingView()
            self?.myUsersTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("MyUsersViewController -> viewDidDisappear")
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
        
        FireBaseManager.shared.userSignOut {
            navigationController?.popViewController(animated: true)
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
    
    private func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    private func removeLoadingView() {
        loadingView.removeFromSuperview()
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
        tableView.deselectRow(at: indexPath, animated: true)
        let frend = myUsers[indexPath.row]
        navigationController?.pushViewController(ChatViewController(myFrend: frend), animated: true)
    }
}
