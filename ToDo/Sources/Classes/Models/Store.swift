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

    //MARK: Get Objects

    func objects<T: Object>(type: T.Type) -> Results<T> {
        return realm.objects(type)
    }

    //MARK: Managing Lists

    func addList(name: String) {
        let list = List(name: name)
        list.index = objects(List.self).count

        realm.write { [unowned self] in
            self.realm.add(list)
        }
    }

    func appendTodo(text: String, list: List) {
        let todo = Todo(text: text)

        realm.write {
            list.todos.append(todo)
        }
    }

    func moveList(sourceIndex sourceIndex: Int, destinationIndex: Int) {
        guard let sourceList = realm.objects(List).filter("index == %@", sourceIndex).first else { return }
        guard let destinationList = realm.objects(List).filter("index == %@", destinationIndex).first else { return }

        realm.write {
            sourceList.index = destinationIndex
            destinationList.index = sourceIndex
        }
    }

    //MARK: Managing Todos

    func deleteList(listID: String) {
        guard let list = realm.objects(List).filter("id == %@", listID).first else { return }

        realm.write { [unowned self] in
            self.realm.delete(list)
        }
    }
    
    func removeTodo(todoID: String, list: List) {
        guard let index = list.todos.indexOf("id == %@", todoID) else { return }
        let todo = list.todos[index]
        
        realm.write { [unowned self] in
            list.todos.removeAtIndex(index)
            self.realm.delete(todo)
        }
    }

    func moveTodo(sourceIndex sourceIndex: Int, destinationIndex: Int, list: List) {
        realm.write {
            list.todos.swap(sourceIndex, destinationIndex)
        }
    }
}
