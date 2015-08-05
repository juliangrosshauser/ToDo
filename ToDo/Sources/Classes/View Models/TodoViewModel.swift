//
//  TodoViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 05/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class TodoViewModel {
    
    //MARK: Properties
    
    private let realm = try! Realm()
    private var realmNotificationToken = NotificationToken()
    static let todosChangedNotification = "TodosChangedNotification"
    
    //MARK: Add Todo
    
    func addTodo(todo: Todo, toList list: List) {
        realm.write {
            list.todos.append(todo)
        }
    }
}

