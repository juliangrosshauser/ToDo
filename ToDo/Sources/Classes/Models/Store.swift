//
//  Store.swift
//  ToDo
//
//  Created by Julian Grosshauser on 12/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class Store {

    //MARK: Properties

    private let realm = try! Realm()
    private var realmNotificationToken: NotificationToken?
    private let notificationCenter = NSNotificationCenter.defaultCenter()

    //MARK: Get Objects

    func objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }

    //MARK: Add List

    func addList(name: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            let realm = try! Realm()

            let list = List()
            list.name = name

            realm.write {
                realm.add(list)
            }
        }
    }

    //MARK: Append Todo To List

    func appendTodo(text: String, list: List) {
        let primaryKey = list.id

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            let realm = try! Realm()

            let todo = Todo()
            todo.text = text

            if let list = realm.objects(List).filter("id == %@", primaryKey).first {
                realm.write {
                    list.todos.append(todo)
                }
            }
        }
    }
}
