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
    private var realmNotificationToken = NotificationToken()
    static let modelChangedNotification = "ModelChangedNotification"

    //MARK: Initialization

    init() {
        realmNotificationToken = realm.addNotificationBlock { notification, realm in
            NSNotificationCenter.defaultCenter().postNotificationName(RealmViewModel.modelChangedNotification, object: self)
        }
    }
}
