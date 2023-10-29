//
//  TodoListApp.swift
//  TodoList
//
//  Created by Dax Granados on 10/22/23.
//

import SwiftUI
import FirebaseCore

@main
struct TodoListApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
