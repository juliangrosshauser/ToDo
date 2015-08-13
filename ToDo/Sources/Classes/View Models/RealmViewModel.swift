//
//  RealmViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 12/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import RealmSwift

class RealmViewModel {

    //MARK: Properties

    private let realm = try! Realm()
    private var realmNotificationToken = NotificationToken()
    static let modelChangedNotification = "ModelChangedNotification"
}
