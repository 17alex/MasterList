//
//  Protocol.swift
//  MasterList
//
//  Created by Admin on 13/05/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

protocol StoredProtocol {
    var currentMyUser: People? { get }
    func createAllUsersObserver(completion: @escaping ([People]) -> Void)
    func removeAllUsersObserver()
    func createFrendsObserver(completion: @escaping ([People]) -> Void)
    func createFrendsObserverDic(completion: @escaping ([String: String]) -> Void)
    func removeFrendsObserver()
    func createChatObserver(forUser: People, complete: @escaping ([Post]) -> Void)
    func removeChatObserver(forUser: People)
    func set(posts: [String: String], forUser: People)
    func add(frend: People)
    func remove(frend: People)
    func userSignIn(withEmail login: String, password pass: String, completion: @escaping (FirebaseResult) -> Void)
    func userSignUp(withEmail login: String, password pass: String, completion: @escaping (FirebaseResult) -> Void)
    func save(userName: String)
    func userSignOut(completion: () -> Void)
}
