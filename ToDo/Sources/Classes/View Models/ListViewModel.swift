//
//  ListViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 28/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import Foundation
import RealmSwift

class ListViewModel {
    
    //MARK: Properties
    
    private let realm = try! Realm()
    private var realmNotificationToken = NotificationToken()
    static let listsChangedNotification = "ListsChangedNotification"
    
    var lists: Results<List> {
        return realm.objects(List)
    }

    //MARK: Add List

    func addList(list: List) {
        realm.write {
            self.realm.add(list)
        }
    }
}
