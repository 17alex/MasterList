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
    private let usersRef: DatabaseReference = Database.database().reference().child("users")
    private var myFrendsRef: DatabaseReference?
    
    var currentMyUser: MyUser? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        return MyUser(user: currentUser)
    }
    
    func onFrendsObserve(completion: @escaping ([MyUser]) -> Void) {
        var myUsers: [MyUser] = []
        if let currUser = currentMyUser {
            myFrendsRef = usersRef.child("list").child(currUser.uid).child("frends")
            myFrendsRef!.observe(.value) { (snapshot) in
                let dict = snapshot.value as? [String: Any] ?? [:]
                for item in dict {
                    let dic = item.value as? [String: Any] ?? [:]
                    let id = dic["uid"] as! String
                    let name = dic["name"] as! String
                    let myUser = MyUser(uid: id, name: name)
                    myUsers.append(myUser)
                }
            }
        }
        completion(myUsers)
    }
    
    func onChatObserve(forUser: MyUser, complete: @escaping ([Post]) -> Void) {
        var myPosts: [Post] = []
        if let currUser = currentMyUser {
            usersRef.child("list").child(currUser.uid).child("frends").child(forUser.uid).child("posts").observe(.value) { (snapshot) in
                
                if let dict = snapshot.value as? [String: String] {
                    for item in dict {
                        myPosts.append(Post(time: TimeInterval(Int(item.key)!) , text: item.value))
                    }
                }
            }
        }
        complete(myPosts)
    }
    
    func setValue(dict: [String: String], forUser: MyUser) {
        if let currUser = currentMyUser {
            usersRef.child("list").child(currUser.uid).child("frends").child(forUser.uid).child("posts").setValue(dict)
        }
    }
    
    func offFrensObserve() {
        if let currUser = currentMyUser {
            myFrendsRef = usersRef.child("list").child(currUser.uid).child("frends")
            myFrendsRef!.removeAllObservers()
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
            usersRef.child("list").child(currUser.uid).setValue(["name": userName, "uid": currUser.uid])
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
