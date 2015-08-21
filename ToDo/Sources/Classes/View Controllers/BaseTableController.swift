//
//  BaseTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 13/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class BaseTableController: UITableViewController {

    //MARK: Properties

    let store = Store()
    let itemType: TableItemType
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: "addItemAction:")
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: "edit:")
    let notificationCenter = NSNotificationCenter.defaultCenter()

    //MARK: Initialization

    init(itemType: TableItemType) {
        self.itemType = itemType

        super.init(style: .Plain)

        title = "\(itemType)s"
        addButton.target = self
        editButton.target = self
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: String(TableViewCell))

        notificationCenter.addObserverForName(nil, object: store, queue: NSOperationQueue.mainQueue()) { _ in
            self.editButton.enabled = self.enableEditButton()
            
            // leave editing mode after removing last item in table view
            if self.tableView.editing && self.tableView.dataSource?.tableView(self.tableView, numberOfRowsInSection: 0) ?? 0 == 0 {
                self.edit(self)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.leftItemsSupplementBackButton = true

        editButton.enabled = enableEditButton()
    }

    //MARK: Add Item

    func addItem(storeItem: String -> Void) {
        let newItemPrompt = UIAlertController(title: "New \(itemType)", message: "Please enter text for new " + String(itemType).lowercaseString, preferredStyle: .Alert)

        let addNewItemAction = UIAlertAction(title: "Add \(itemType)", style: .Default) { alert in
            storeItem(newItemPrompt.textFields!.first!.text!)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        addNewItemAction.enabled = false
        newItemPrompt.addAction(addNewItemAction)
        newItemPrompt.addAction(cancelAction)


        newItemPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = String(self.itemType)
            textField.addTarget(self, action: "newItemChanged:", forControlEvents: .EditingChanged)
        }

        presentViewController(newItemPrompt, animated: true, completion: nil)
    }

    //MARK: Text Field Actions

    @objc
    private func newItemChanged(sender: AnyObject) {
        if let newItemPrompt = presentedViewController as? UIAlertController {
            newItemPrompt.actions.first!.enabled = newItemPrompt.textFields!.first!.text!.characters.count > 0
        }
    }

    //MARK: Button Actions

    @objc
    private func edit(sender: AnyObject) {
        if tableView.editing {
            setEditing(false, animated: true)
            addButton.enabled = true
        } else {
            setEditing(true, animated: true)
            addButton.enabled = false
        }
    }

    //MARK: Helper

    func enableEditButton() -> Bool {
        let numberOfRows = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0) ?? 0

        if numberOfRows > 0 {
            return true
        }

        return false
    }
}
