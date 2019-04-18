//
//  User.swift
//  MasterList
//
//  Created by Admin on 21.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import Firebase

struct MyUser {
    var name: String = ""
    let uid: String
    
    init(user: User) {
        uid = user.uid
    }
    
    init(uid: String, name: String) {
        self.name = name
        self.uid = uid
    }
}
