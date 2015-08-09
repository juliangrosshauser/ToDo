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
    
    //MARK: Initialization
    
    init() {
        realmNotificationToken = realm.addNotificationBlock { notification, realm in
            NSNotificationCenter.defaultCenter().postNotificationName(ListViewModel.listsChangedNotification, object: self)
        }
    }
    
    var lists: Results<List> {
        return realm.objects(List)
    }

    //MARK: Add List

    func addList(list: List) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            let realm = try! Realm()

            realm.write {
                realm.add(list)
            }
        }
    }
}
