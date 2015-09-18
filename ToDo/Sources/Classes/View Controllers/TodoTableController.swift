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

        todoViewModel.toggleDoneOnTodo.values.observeNext { [unowned self] row in
            guard let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: 0)) else { return }

            if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
            } else {
                cell.accessoryType = .Checkmark
            }
        }
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
        return todoViewModel.itemCount.value
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TableViewCell)) as! TableViewCell
        cell.configure(todoViewModel.item(indexPath.row))
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            todoViewModel.deleteItem.apply(cell.id).start()
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        todoViewModel.moveItem.apply((sourceIndexPath.row, destinationIndexPath.row)).start()
    }
}

//MARK: UITableViewDelegate

extension TodoTableController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        todoViewModel.toggleDoneOnTodo.apply(indexPath.row).start()
    }
}
