//
//  FireBaseManager.swift
//  MasterList
//
//  Created by Admin on 07/05/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import Firebase

class FireBaseManager {
    
    static let shared = FireBaseManager()
    private init() {}
    
    private let ref: DatabaseReference = Database.database().reference()
   
    var currentMyUser: MyUser? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return MyUser(user: currentUser)
    }
    
    func createAllUsersObserver(completion: @escaping ([MyUser]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list").observe(.value) { (snapshot) in
                var allUsers: [MyUser] = []
                for item in snapshot.children {
                    let snap = item as! DataSnapshot
                    let snapValue = snap.value as! [String: AnyObject]
                    let uid = snapValue["uid"] as! String
                    let name = snapValue["name"] as! String
                    let myUser = MyUser(uid: uid, name: name)
                    if myUser.uid != currUser.uid {
                        allUsers.append(myUser)
                    }
                }
                completion(allUsers)
            }
        }
    }
    
    func removeAllUsersObserver() {
            ref.child("users/list").removeAllObservers()
    }
    
    func createFrendsObserver(completion: @escaping ([MyUser]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends").observe(.value) { (snapshot) in
                var myUsers: [MyUser] = []
                let dict = snapshot.value as? [String: AnyObject] ?? [:]
                for item in dict {
                    let dic = item.value as? [String: AnyObject] ?? [:]
                    let id = dic["uid"] as! String
                    let name = dic["name"] as! String
                    let myUser = MyUser(uid: id, name: name)
                    myUsers.append(myUser)
                }
                completion(myUsers)
            }
        }
    }
    
    func createFrendsObserverD(completion: @escaping ([String: String]) -> Void) {
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
    
    func removeFrensObserver() {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends").removeAllObservers()
        }
    }
    
    func createChatObserver(forUser: MyUser, complete: @escaping ([Post]) -> Void) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(forUser.uid)/posts").observe(.value) { (snapshot) in
                var myPosts: [Post] = []
                if let dict = snapshot.value as? [String: String] {
                    for item in dict {
                        myPosts.append(Post(time: TimeInterval(Int(item.key)!) , text: item.value))
                    }
                }
                complete(myPosts)
            }
        }
    }
    
    func removeChatObserver(forUser: MyUser) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(forUser.uid)/posts").removeAllObservers()
        }
    }
    
    func set(posts: [String: String], forUser: MyUser) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(forUser.uid)/posts").setValue(posts)
        }
    }
    
    func add(frend: MyUser) {
        if let currUser = currentMyUser {
            ref.child("users/list/\(currUser.uid)/frends/\(frend.uid)").setValue(["name": frend.name, "uid": frend.uid])
        }
    }
    
    func remove(frend: MyUser) {
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
