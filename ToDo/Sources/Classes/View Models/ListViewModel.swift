//
//  ListViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 30/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import ReactiveCocoa

class ListViewModel: BaseViewModel {

    //MARK: Properties

    let itemCount: MutableProperty<Int> = MutableProperty(0)

    //MARK: Initialization

    override init() {
        super.init()
        itemCount.value = store.objects(List).count
    }

    //MARK: Managing Lists

    func addList(name: String) -> SignalProducer<Void, NoError> {
        return SignalProducer(value: store.addList(name))
    }

    func deleteList(listID: String) {
        store.deleteList(listID)
    }
}
