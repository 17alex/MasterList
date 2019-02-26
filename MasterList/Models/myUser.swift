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
    let uid: String
    let email: String?
    
    init(user: User) {
        uid = user.uid
        email = user.email
    }
}
