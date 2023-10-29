//
//  User.swift
//  TodoList
//
//  Created by Dax Granados on 10/22/23.
//

import Foundation
struct User: Codable {
    let id: String
    let fullname: String
    let email: String
    let joined: TimeInterval
}
