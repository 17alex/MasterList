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
    private var currentMyUser: People!
    private var allUsers: [People] = []
    private var myUsers: [String: String] = [:]
    private let storedManager: StoredProtocol
    private let openChat: (People) -> Void
    
    init(_ storedManager: StoredProtocol, _ openChat: @escaping (People) -> Void) {
        self.storedManager = storedManager
        self.openChat = openChat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("AllUsersViewController -> deinit")
        storedManager.removeAllUsersObserver()
        storedManager.removeFrendsObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "addChat"
        addUsersTableView()
        addConstraints()
        
        allUsersTableView.dataSource = self
        allUsersTableView.delegate = self
        
        guard let currMyUser = storedManager.currentMyUser else {
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
        storedManager.createAllUsersObserver { [weak self] (allUsers) in
            self?.allUsers = allUsers
            self?.allUsers.sort(by: { (u1, u2) -> Bool in
                return u1.name < u2.name
            })
            self?.removeLoadingView()
            self?.allUsersTableView.reloadData()
        }
        
        storedManager.createFrendsObserverDic { [weak self] (myFrends) in
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
        
        if cell?.accessoryType != .checkmark {
            storedManager.add(frend: selectMyUser)
        }
        
        openChat(selectMyUser)
    }
}

