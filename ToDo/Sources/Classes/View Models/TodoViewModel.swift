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
    
    //MARK: Initialization
    
    init() {
        realmNotificationToken = realm.addNotificationBlock { notification, realm in
            NSNotificationCenter.defaultCenter().postNotificationName(TodoViewModel.todosChangedNotification, object: self)
        }
    }
    
    //MARK: Add Todo
    
    func addTodoWithText(text: String, toListWithPrimaryKey primaryKey: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            let realm = try! Realm()
            
            let todo = Todo()
            todo.id = NSUUID().UUIDString
            todo.text = text

            if let list = realm.objects(List).filter("id == %@", primaryKey).first {
                realm.write {
                    list.todos.append(todo)
                }
            }
        }
    }
}

