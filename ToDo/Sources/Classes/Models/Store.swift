//
//  Store.swift
//  ToDo
//
//  Created by Julian Grosshauser on 12/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveCocoa

class Store {

    //MARK: Properties

    private let realm = try! Realm()
    static let listDeletedNotification = "ListDeletedNotification"
    static let todoDeletedNotification = "TodoDeletedNotification"
    static let userInfoListIDKey = "ListID"
    private let notificationCenter = NSNotificationCenter.defaultCenter()

    //MARK: Get Objects

    func objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }

    //MARK: Add List

    func addList(name: String) -> SignalProducer<Void, NoError> {
        let list = List()
        list.name = name

        realm.write { [unowned self] in
            self.realm.add(list)
        }

        return SignalProducer(value: ())
    }

    //MARK: Append Todo To List

    func appendTodo(text: String, list: List) -> SignalProducer<Void, NoError> {
        let todo = Todo()
        todo.text = text

        realm.write {
            list.todos.append(todo)
        }

        return SignalProducer(value: ())
    }

    //MARK: Delete List

    func deleteList(listID: String) {
        if let list = realm.objects(List).filter("id == %@", listID).first {
            realm.write {
                self.realm.delete(list)
            }

            self.notificationCenter.postNotificationName(Store.listDeletedNotification, object: self)
        }
    }
    
    //MARK: Remove Todo From List
    
    func removeTodo(todoID: String, list: List) {
        if let index = list.todos.indexOf("id == %@", todoID) {
            let todo = list.todos[index]
            
            realm.write {
                list.todos.removeAtIndex(index)
                self.realm.delete(todo)
            }
            
            let userInfo = [Store.userInfoListIDKey: list.id]
            self.notificationCenter.postNotificationName(Store.todoDeletedNotification, object: self, userInfo: userInfo)
        }
    }
}
