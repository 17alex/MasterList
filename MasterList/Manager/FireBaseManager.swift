//
//  FireBaseManager.swift
//  MasterList
//
//  Created by Admin on 07/05/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import Firebase

class FireBaseManager: StoredProtocol {
    
    static let shared = FireBaseManager()
    private init() {}
    
    private let ref: DatabaseReference = Database.database().reference()
   
    var currentPeople: People?
    
    var currentMyUser: People? {
        guard let currentUser = Auth.auth().currentUser else {
            currentPeople = nil
            return nil
        }
        
        if currentPeople?.uid == currentUser.uid {
            return currentPeople
        } else {
            return People(user: currentUser)
        }
    }
    
    func createAllUsersObserver(completion: @escaping ([People]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list").observe(.value) { [weak self] (snapshot) in
                var allUsers: [People] = []
                for item in snapshot.children {
                    let snap = item as! DataSnapshot
                    let snapValue = snap.value as! [String: AnyObject]
                    let uid = snapValue["uid"] as! String
                    let name = snapValue["name"] as! String
                    let myUser = People(uid: uid, name: name)
                    if myUser.uid != currUser.uid {
                        allUsers.append(myUser)
                    } else {
                        self?.currentPeople = myUser
                    }
                }
                completion(allUsers)
            }
        }
    }
    
    func removeAllUsersObserver() {
            ref.child("users/list").removeAllObservers()
    }
    
    func createFrendsObserver(completion: @escaping ([People]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends").observe(.value) { (snapshot) in
                var myUsers: [People] = []
                let dict = snapshot.value as? [String: AnyObject] ?? [:]
                for item in dict {
                    let dic = item.value as? [String: AnyObject] ?? [:]
                    let id = dic["uid"] as! String
                    let name = dic["name"] as! String
                    let myUser = People(uid: id, name: name)
                    myUsers.append(myUser)
                }
                completion(myUsers)
            }
        }
    }
    
    func createFrendsObserverDic(completion: @escaping ([String: String]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends").observe(.value) { (snapshot) in
                var myUsers: [String: String] = [:]
                for item in snapshot.children {
                    let snap = item as! DataSnapshot
                    let snapValue = snap.value as! [String: AnyObject]
                    let uid = snapValue["uid"] as! String
                    let name = snapValue["name"] as! String
                    myUsers[uid] = name
                }
                completion(myUsers)
            }
        }
    }
    
    func removeFrendsObserver() {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends").removeAllObservers()
        }
    }
    
    func createChatObserverFor(people: People, complete: @escaping ([Post]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(people.uid)/posts").observe(.value) { (snapshot) in
                var posts: [Post] = []
                if let dict = snapshot.value as? [String: String] {
                    for item in dict {
                        posts.append(Post(time: TimeInterval(Int(item.key)!) , text: item.value, people: currUser))
                    }
                }
                complete(posts)
            }
        }
    }
    
    func createChatObserverFrom(people: People, complete: @escaping ([Post]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(people.uid)/frends/\(currUser.uid)/posts").observe(.value) { (snapshot) in
                var posts: [Post] = []
                if let dict = snapshot.value as? [String: String] {
                    for item in dict {
                        posts.append(Post(time: TimeInterval(Int(item.key)!) , text: item.value, people: people))
                    }
                }
                complete(posts)
            }
        }
    }
    
    func removeChatObserver(forUser: People) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(forUser.uid)/posts").removeAllObservers()
        }
    }
    
    func set(posts: [String: String], forUser: People) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(forUser.uid)/posts").setValue(posts)
        }
    }
    
    func add(frend: People) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(frend.uid)").setValue(["name": frend.name, "uid": frend.uid])
            ref.child("users/list/\(frend.uid)/frends/\(currUser.uid)").setValue(["name": currUser.name, "uid": currUser.uid])
        }
    }
    
    func remove(frend: People) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(frend.uid)").removeValue()
        }
    }
    
    func userSignIn(withEmail login: String, password pass: String, completion: @escaping (FirebaseResult) -> Void) {
        
        Auth.auth().signIn(withEmail: login, password: pass) { (result, error) in
            if let error = error {
                completion(.error(error.localizedDescription))
            } else if result?.user == nil {
                completion(.error("User or password not correct"))
            } else {
                completion(.success)
            }
        }
    }
    
    func userSignUp(withEmail login: String, password pass: String, completion: @escaping (FirebaseResult) -> Void) {
        
        Auth.auth().createUser(withEmail: login, password: pass) { (result, error) in
            if let error = error {
                completion(.error(error.localizedDescription))
            } else if result?.user != nil {
                completion(.success)
            }
        }
    }
    
    func save(userName: String) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)").setValue(["name": userName, "uid": currUser.uid])
        }
    }
    
    func userSignOut(completion: () -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            print("error = \(error.localizedDescription)")
        }
    }
}
