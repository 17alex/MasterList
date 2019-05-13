//
//  UsersViewController.swift
//  MasterList
//
//  Created by Admin on 16.04.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class FrendsViewController: UIViewController {

    private var frendsTableView: UITableView!
    private var loadingView: LoadingView!
    
    private var frends: [People] = []
    private var currentPeople: People?
    
    deinit {
        print("FrendsViewController -> deinit")
        FireBaseManager.shared.removeFrendsObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "myFrends"
        configNavController()
        addUsersTableView()
        addConstraints()
        frendsTableView.dataSource = self
        frendsTableView.delegate = self

        guard let currPeople = FireBaseManager.shared.currentMyUser else {
            navigationItem.title = "error"
            print("FrendsViewController not user")
            return
        }
        currentPeople = currPeople
        print("FrendsViewController user exist")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("FrendsViewController -> viewDidAppear")

        showLoadingView()
        FireBaseManager.shared.createFrendsObserver { [weak self] (myPeoples) in
            self?.frends = myPeoples
            self?.frends.sort(by: { (p1, p2) -> Bool in
                return p1.name < p2.name
            })
            self?.removeLoadingView()
            self?.frendsTableView.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("FrendsViewController -> viewDidDisappear")
    }
    
    private func configNavController() {
        let rightBarButtonItem = UIBarButtonItem(title: "Select", style: .done, target: self, action: #selector(addMyUsersButton))
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
        frendsTableView = UITableView()
        frendsTableView.translatesAutoresizingMaskIntoConstraints = false
        frendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "proplesList")
        view.addSubview(frendsTableView)
    }
    
    private func addConstraints() {
        frendsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        frendsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        frendsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        frendsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
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

extension FrendsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proplesList", for: indexPath)
        cell.textLabel?.text = frends[indexPath.row].name
        return cell
    }
}

extension FrendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let frend = frends[indexPath.row]
        navigationController?.pushViewController(ChatViewController(myFrend: frend), animated: true)
    }
}
