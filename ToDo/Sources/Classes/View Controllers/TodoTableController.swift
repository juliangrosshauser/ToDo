//
//  TodoTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit
import ReactiveCocoa

class TodoTableController: BaseTableController, ListControllerDelegate {

    //MARK: ListControllerDelegate

    private let todoViewModel = TodoViewModel()
    let list: MutableProperty<List?> = MutableProperty(nil)

    //MARK: Initialization

    init() {
        super.init(itemType: .Todo, viewModel: todoViewModel)

        list <~ todoViewModel.list.producer.on(next: { [unowned self] list in
            guard list != self.list.value else { return }
            self.list.value = list
            self.tableView.reloadData()
            self.title = list?.name ?? "\(self.itemType)s"
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard list.value == nil else { return }
        guard let splitViewController = splitViewController where splitViewController.displayMode == .PrimaryHidden else { return }
        splitViewController.preferredDisplayMode = .PrimaryOverlay
        splitViewController.preferredDisplayMode = .Automatic
    }

    //MARK: ListControllerDelegate

    func listChanged(list: List?) {
        todoViewModel.list.value = list
    }
}

//MARK: UITableViewDataSource

extension TodoTableController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.value?.todos.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TableViewCell)) as! TableViewCell
        cell.configure(list.value!.todos[indexPath.row])
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            todoViewModel.removeTodo(cell.id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        todoViewModel.moveTodo(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
}
