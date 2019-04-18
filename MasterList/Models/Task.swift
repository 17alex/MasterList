//
//  Task.swift
//  MasterList
//
//  Created by Admin on 21.02.2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let title: String
    var completed: Bool = false
    var ref: DatabaseReference?
    
    init(title: String) {
        self.title = title
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
}
