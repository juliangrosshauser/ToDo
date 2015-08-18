//
//  TodoTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class TodoTableController: BaseTableController, ListControllerDelegate {

    //MARK: ListControllerDelegate
    
    var list: List? {
        didSet {
            if list != oldValue {
                tableView.reloadData()
                editButton.enabled = enableEditButton()
                
                if let list = list {
                    title = list.name
                    
                    if (!addButton.enabled) {
                        addButton.enabled = true
                    }
                } else {
                    title = "\(itemType)s"
                    
                    if (addButton.enabled) {
                        addButton.enabled = false
                    }
                }
            }
        }
    }

    //MARK: Initialization

    init() {
        super.init(itemType: .Todo)

        notificationCenter.addObserverForName(Store.todoAddedNotification, object: store, queue: NSOperationQueue.mainQueue()) { _ in
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: .Bottom)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if list == nil {
            if let splitViewController = splitViewController where splitViewController.displayMode == .PrimaryHidden  {
                splitViewController.preferredDisplayMode = .PrimaryOverlay
                splitViewController.preferredDisplayMode = .Automatic
            }
        }
    }
    
    //MARK: Button Actions
    
    @objc
    private func addItemAction(sender: UIButton) {
        let storeTodo: String -> Void = { text in
            self.store.appendTodo(text, list: self.list!)
        }

        addItem(storeTodo)
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
}
