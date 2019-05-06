//
//  Post.swift
//  MasterList
//
//  Created by Admin on 29/04/2019.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation

struct Post {
    let time: TimeInterval
    let text: String
}

func dateToString(format: String, timeInterval: TimeInterval?) -> String {
    guard let timeInt = timeInterval else { return "--/--/----  --:--:--" }
    let date: Date = Date(timeIntervalSince1970: Double(timeInt))
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: date)
}
