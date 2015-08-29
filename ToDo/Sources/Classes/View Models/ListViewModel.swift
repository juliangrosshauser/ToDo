//
//  ListViewModel.swift
//  ToDo
//
//  Created by Julian Grosshauser on 30/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import ReactiveCocoa

class ListViewModel: BaseViewModel {

    //MARK: Managing Lists

    func addList(name: String) -> SignalProducer<Void, NoError> {
        return SignalProducer(value: store.addList(name))
    }

    func deleteList(listID: String) {
        store.deleteList(listID)
    }
}
