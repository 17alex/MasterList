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
    
    var currentUser: MyUser {
        return MyUser(uid: "123", name: "123")
    }
    
    
    
}
