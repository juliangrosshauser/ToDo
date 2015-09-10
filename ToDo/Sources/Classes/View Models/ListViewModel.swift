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

    //TODO: Bind to add/delete signal instead of setting value manually
    let itemCount: MutableProperty<Int> = MutableProperty(0)

    //MARK: Initialization

    override init() {
        super.init()
        itemCount.value = store.objects(List).count
        editEnabled <~ itemCount.producer.map { $0 > 0 ? true : false }

        addItem = Action(enabledIf: addEnabled) { [unowned self] _ in
            self.addList(self.itemDescription.value)
        }
    }

    //MARK: Managing Lists

    func addList(name: String) -> SignalProducer<Int, NoError> {
        itemCount.value++
        return SignalProducer(value: store.addList(name))
    }

    func deleteList(listID: String) -> SignalProducer<(deletedIndex: Int, itemCount: Int), NoError> {
        itemCount.value--
        return SignalProducer(value: store.deleteList(listID))
    }

    func moveList(sourceIndex sourceIndex: Int, destinationIndex: Int) {
        store.moveList(sourceIndex: sourceIndex, destinationIndex: destinationIndex)
    }
}
