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
    
    var list: List? {
        didSet {
            guard list != oldValue else { return }
            tableView.reloadData()
            viewModel.editEnabled.value = enableEditButton()
            
            if let list = list {
                title = list.name
                
                if (!viewModel.addEnabled.value) {
                    viewModel.addEnabled.value = true
                }
            } else {
                title = "\(itemType)s"
                
                if (viewModel.addEnabled.value) {
                    viewModel.addEnabled.value = false
                }
            }
        }
    }

    //MARK: Initialization

    init() {
        super.init(itemType: .Todo, viewModel: TodoViewModel())
        viewModel.addEnabled.value = false

        let storeItem: StoreItem = { [unowned self] text in
            guard let viewModel = self.viewModel as? TodoViewModel else { return SignalProducer.never }
            return viewModel.appendTodo(text, list: self.list!)
        }

        addItem.unsafeCocoaAction = CocoaAction(addItem, input: storeItem)
        addButton.target = addItem.unsafeCocoaAction
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: UIViewController

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        guard list == nil else { return }
        guard let splitViewController = splitViewController where splitViewController.displayMode == .PrimaryHidden else { return }
        splitViewController.preferredDisplayMode = .PrimaryOverlay
        splitViewController.preferredDisplayMode = .Automatic
    }
}

//MARK: UITableViewDataSource

extension TodoTableController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.todos.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TableViewCell)) as! TableViewCell
        
        cell.configure(list!.todos[indexPath.row])
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            guard let viewModel = viewModel as? TodoViewModel else { return }
            viewModel.removeTodo(cell.id, list: self.list!)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}
