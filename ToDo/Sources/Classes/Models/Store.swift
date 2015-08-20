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
    static let listAddedNotification = "ListAddedNotification"
    static let listDeletedNotification = "ListDeletedNotification"
    static let todoAddedNotification = "TodoAddedNotification"
    static let userInfoListIDKey = "ListID"
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

            self.notificationCenter.postNotificationName(Store.listAddedNotification, object: self)
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

                let userInfo = [Store.userInfoListIDKey: list.id]
                self.notificationCenter.postNotificationName(Store.todoAddedNotification, object: self, userInfo: userInfo)
            }
        }
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
}
