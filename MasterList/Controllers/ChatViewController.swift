//
//  ChatViewController.swift
//  MasterList
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    private var chatTableView: UITableView!
    private var chatSendButton: UIButton!
    private var searchController: UISearchController!
    private var chatTextView: UITextView!
    private var loadingView: LoadingView!
    
    private var myFrend: People!
    private var currentMyUser: People!
    private var allPosts: [Post] = []
    private var filterAllPosts: [Post] = []
    private var myPosts: [Post] = []
    private var frendPosts: [Post] = []
    private let storedManager: StoredProtocol
    private var kbIsShow: Bool = false
    private var myPostIsLoaded = false
    private var frendsPostIsLoaded = false
    private var isSendMessageScroll = false
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltered: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    init(myFrend: People, _ storedManager: StoredProtocol) {
        self.myFrend = myFrend
        self.storedManager = storedManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        storedManager.removeChatObserver(forUser: myFrend)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard let currMyUser = storedManager.currentMyUser else {
            navigationItem.title = "error"
            print("MyUsersViewController not user")
            return
            // TODO: - Dissmis
        }
        currentMyUser = currMyUser
        
        addChatTableView()
//        addChatTextField()
        addChatTextView()
        addChatSendButton()
        addConstraints()
        addSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        showLoadingView()
        storedManager.createChatObserverFor(people: myFrend) { [weak self] (posts) in
            self?.myPosts = posts
            self?.myPostIsLoaded = true
            mergeAndSortPosts()
        }
        
        storedManager.createChatObserverFrom(people: myFrend) { [weak self] (posts) in
            self?.frendPosts = posts
            self?.frendsPostIsLoaded = true
            mergeAndSortPosts()
        }
        
        func mergeAndSortPosts() {
            if myPostIsLoaded && frendsPostIsLoaded {
                allPosts = myPosts
                allPosts.append(contentsOf: frendPosts)
                removeLoadingView()
                allPosts.sort(by: { (m1, m2) -> Bool in
                    return m1.time < m2.time
                })
                chatTableView.reloadData()
                let scrollRow = allPosts.count == 0 ? 0 : allPosts.count - 1
                if scrollRow > 0 {
                    chatTableView.scrollToRow(at: IndexPath(row: scrollRow , section: 0), at: .middle, animated: isSendMessageScroll)
                }
            }
        }
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc
    private func keyboardShow(notification: NSNotification) {
        if kbIsShow == true { return }
        kbIsShow = true
        print("keyboardShow")
        guard let userInfo = notification.userInfo else { return }
        //        print("userInfo = \(userInfo)")
        let kbFrameSize = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
        //        print("showKeyboard kbFrameSize = \(kbFrameSize)")
        let offset = kbFrameSize.height
        //        print("offset = \(offset)")
        
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            
            self?.view.frame.size.height = UIScreen.main.bounds.height - offset
        }) { [weak self] (_) in
            if let numberRows = self?.allPosts.count {
                let scrollRow = numberRows == 0 ? 0 : numberRows - 1
                if scrollRow > 0 {
                    self?.chatTableView.scrollToRow(at: IndexPath(row: scrollRow , section: 0), at: .middle, animated: true)
                }
            }
        }
    }
    
    @objc
    private func keyboardHide() {
        if kbIsShow == false { return }
        kbIsShow = false
        print("keyboardHide")
        UIView.animate(withDuration: 0.5) { [weak self] in
//            self?.view.frame.origin.y = 0
            self?.view.frame.size.height = UIScreen.main.bounds.height
        }
    }
    
    @objc
    private func chatSendButtonPress() {
        
        guard let messageText = chatTextView.text, !messageText.isEmpty else { return }
        let timeInterval = Date().timeIntervalSince1970
        myPosts.append(Post(time: timeInterval, text: messageText, people: currentMyUser))
        chatTextView.text = ""
        var dict: [String: String] = [:]
        for item in myPosts {
            dict[Int(item.time).description] = item.text
        }
        storedManager.set(posts: dict, forUser: myFrend)
        isSendMessageScroll = true
    }
    
    private func addChatTableView() {
        chatTableView = UITableView()
        chatTableView.backgroundColor = .white
        chatTableView.separatorStyle = .none
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
        view.addSubview(chatTableView)
        chatTableView.dataSource = self
        chatTableView.delegate = self
//        chatTableView.estimatedRowHeight = 150
//        chatTableView.rowHeight = UITableView.automaticDimension
    }
    
    private func addChatTextView() {
        chatTextView = UITextView()
        chatTextView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatTextView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        chatTextView.isScrollEnabled = false
        chatTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatTextView)
    }
    
    private func addChatSendButton() {
        chatSendButton = UIButton()
        chatSendButton.setTitle("Send", for: .normal)
        chatSendButton.setTitleColor(.red, for: .normal)
        chatSendButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        chatSendButton.addTarget(self, action: #selector(chatSendButtonPress), for: .touchUpInside)
        chatSendButton.layer.cornerRadius = 5
//        chatSendButton.layer.borderColor = UIColor.darkGray.cgColor
//        chatSendButton.layer.borderWidth = 1
        chatSendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatSendButton)
    }
    
    private func addSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search text"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func addConstraints() {
        chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        chatTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        chatTableView.bottomAnchor.constraint(equalTo: chatTextView.topAnchor, constant: -8).isActive = true
        
        chatTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        chatTextView.rightAnchor.constraint(equalTo: chatSendButton.leftAnchor, constant: -8).isActive = true
        chatTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true

        
        chatSendButton.topAnchor.constraint(equalTo: chatTextView.topAnchor).isActive = true
        chatSendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        chatSendButton.bottomAnchor.constraint(equalTo: chatTextView.bottomAnchor).isActive = true
        chatSendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        chatSendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    private func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.center = view.center
    }
    
    private func removeLoadingView() {
        if loadingView != nil { loadingView.removeFromSuperview() }
    }
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered   { return filterAllPosts.count }
        else            { return allPosts.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        let post: Post!
        if isFiltered   { post = filterAllPosts[indexPath.row] }
        else            { post = allPosts[indexPath.row] }
        cell.messText = post.text
        cell.messTime = post.time
        let messUser = post.people
        
        if messUser.uid == currentMyUser.uid    { cell.messIsMyText = true }
        else                                    { cell.messIsMyText = false }
        
        return cell
    }
}

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        tableView.deselectRow(at: indexPath, animated: false)
        chatTextView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let h = UITableView.automaticDimension
//        print("cell height = \(h)")
//        return h
        
        let messTextLabel = UILabel()
        messTextLabel.text = allPosts[indexPath.row].text
        messTextLabel.numberOfLines = 0
        messTextLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        messTextLabel.frame.size.width = tableView.bounds.width - 106
        messTextLabel.sizeToFit()
        let height = messTextLabel.bounds.height
//        print("Height = \(height)")
        return height + 35
    }

//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        print("estimatedHeightForRowAt")
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if allPosts[indexPath.row].people.uid == currentMyUser.uid { return true }
        else                                                       { return false }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            
            let deletePost = self.allPosts[indexPath.row]
            
            self.allPosts.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            
            var nember = 0
            
            for (i, post) in self.myPosts.enumerated() {
                if post == deletePost {
                    nember = i
                }
            }
            
            self.myPosts.remove(at: nember)
            
            var dict: [String: String] = [:]
            for item in self.myPosts {
                dict[Int(item.time).description] = item.text
            }
            
            self.storedManager.set(posts: dict, forUser: self.myFrend)
        }
        
        return [deleteAction]
    }
}

extension ChatViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterAllPosts = allPosts.filter({ (post) -> Bool in
            return post.text.lowercased().contains(searchController.searchBar.text!.lowercased())
        })
        chatTableView.reloadData()
    }
}
