//
//  Coordinator.swift
//  MasterList
//
//  Created by Admin on 13/05/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class Coordinator {
    
    private let storedManager = FireBaseManager.shared
    private var navConroller: UINavigationController?
    private var loginViewController: LoginViewController!
    private var frendsViewController: FrendsViewController!
    private var allUsersViewController: AllUsersViewController!
    private var chatViewController: ChatViewController!
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private lazy var logedInAction = { () -> Void in
        print("Coordinator -> logedIn clouser")
        self.frendsViewController = FrendsViewController(self.storedManager, self.addFrends, self.openFrendChat, self.signOut)
        self.navConroller?.pushViewController(self.frendsViewController, animated: true)
    }
    
    lazy var openFrendChat = { (people: People) -> Void in
        print("Coordinator -> openFrendChat")
        self.chatViewController = ChatViewController(myFrend: people, self.storedManager)
        self.navConroller?.pushViewController(self.chatViewController, animated: true)
    }
    
    lazy var addFrends = { () -> Void in
        print("Coordinator -> addMyUsersButtonClicked")
        self.allUsersViewController = AllUsersViewController(self.storedManager, self.openChat)
        self.navConroller?.pushViewController(self.allUsersViewController, animated: true)
    }
    
    lazy var signOut = { () -> Void in
        print("Coordinator -> signOut")
        self.navConroller?.popViewController(animated: true)
    }
    
    lazy var openChat = { (people: People) -> Void in
        print("Coordinator -> openChat")
        self.navConroller?.popViewController(animated: false)
        self.openFrendChat(people)
    }
    
    // add people in list
//    let selectMyUser = allUsers[indexPath.row]
//    storedManager.add(frend: selectMyUser)
    
    //remove people in list
//    let selectMyUser = allUsers[indexPath.row]
//    storedManager.remove(frend: selectMyUser)
    
    func start() {
        print("Coordinator -> start")
        loginViewController = LoginViewController(storedManager, coordinator: self, logedInAction)
        navConroller = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navConroller
        navConroller?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    }
    
}
