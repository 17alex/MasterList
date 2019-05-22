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
    private var searchController: UISearchController!
    private var loadingView: LoadingView!
    
    private var frends: [People] = []
    private var filterFrends: [People] = []
    private var currentPeople: People?
    private let storedManager: StoredProtocol
    private let addOrRemoveFrends: () -> Void
    private let openFrendChat: (People) -> Void
    private let signOut: () -> Void
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltered: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    init(_ storedManager: StoredProtocol, _ addOrRemoveFrends: @escaping () -> Void, _ openFrendChat: @escaping (People) -> Void, _ signOut: @escaping () -> Void) {
        self.storedManager = storedManager
        self.addOrRemoveFrends = addOrRemoveFrends
        self.openFrendChat = openFrendChat
        self.signOut = signOut
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("FrendsViewController -> deinit")
        storedManager.removeFrendsObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "Chats"
        configNavController()
        addUsersTableView()
        addConstraints()
        addSearchController()

        guard let currPeople = storedManager.currentMyUser else {
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
        storedManager.createFrendsObserver { [weak self] (myPeoples) in
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
        let rightBarButtonItem = UIBarButtonItem(title: "NewChat", style: .done, target: self, action: #selector(addRemoveFrends))
        let leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .done, target: self, action: #selector(signOutButton))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
    
    @objc
    private func signOutButton() {
        storedManager.userSignOut { [weak self] in
            self?.signOut()
        }
    }
    
    @objc
    private func addRemoveFrends() {
        addOrRemoveFrends()
    }
    
    private func addUsersTableView() {
        frendsTableView = UITableView()
        frendsTableView.translatesAutoresizingMaskIntoConstraints = false
        frendsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "proplesList")
        frendsTableView.dataSource = self
        frendsTableView.delegate = self
        view.addSubview(frendsTableView)
    }
    
    private func addConstraints() {
        frendsTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        frendsTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        frendsTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        frendsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func addSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        if isFiltered {
            return filterFrends.count
        } else {
            return frends.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proplesList", for: indexPath)
        if isFiltered {
            cell.textLabel?.text = filterFrends[indexPath.row].name
        } else {
            cell.textLabel?.text = frends[indexPath.row].name
        }
        return cell
    }
}

extension FrendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let frend: People!
        if isFiltered {
            frend = filterFrends[indexPath.row]
        } else {
            frend = frends[indexPath.row]
        }
        openFrendChat(frend)
    }
}

extension FrendsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterFrends = frends.filter({ (frend) -> Bool in
            return frend.name.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        frendsTableView.reloadData()
    }
}
