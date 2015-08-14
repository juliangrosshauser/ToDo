//
//  RealmViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 12/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class RealmViewModel {

    //MARK: Properties

    private let realm = try! Realm()
    private var realmNotificationToken: NotificationToken?
    static let modelChangedNotification = "ModelChangedNotification"

    //MARK: Initialization

    init() {
        realmNotificationToken = realm.addNotificationBlock { notification, realm in
            NSNotificationCenter.defaultCenter().postNotificationName(RealmViewModel.modelChangedNotification, object: self)
        }
    }

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

    func appendTodo(text: String, listPrimaryKey: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            let realm = try! Realm()

            let todo = Todo()
            todo.text = text

            if let list = realm.objects(List).filter("id == %@", listPrimaryKey).first {
                realm.write {
                    list.todos.append(todo)
                }
            }
        }
    }
}
