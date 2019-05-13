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
    
    private lazy var logedInAction = {
        print("Coordinator -> logedIn clouser")
        self.frendsViewController = FrendsViewController(self.storedManager, self.addOrRemoveFrends, self.openFrendChat)
        self.navConroller?.pushViewController(self.frendsViewController, animated: true)
    }
    
    lazy var openFrendChat: (People) -> Void = {
        print("Coordinator -> openFrendChat")
        self.chatViewController = ChatViewController(myFrend: $0, self.storedManager)
        self.navConroller?.pushViewController(self.chatViewController, animated: true)
    }
    
    lazy var addOrRemoveFrends = {
        print("Coordinator -> addMyUsersButtonClicked")
        self.allUsersViewController = AllUsersViewController(storedManager: self.storedManager)
        self.navConroller?.pushViewController(self.allUsersViewController, animated: true)
    }
    
    func start() {
        print("Coordinator -> start")
        loginViewController = LoginViewController(storedManager, coordinator: self, logedInAction)
        navConroller = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController = navConroller
        navConroller?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    }
    
}