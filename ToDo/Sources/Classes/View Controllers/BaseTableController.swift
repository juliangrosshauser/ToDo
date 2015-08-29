//
//  BaseTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 13/08/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit
import ReactiveCocoa

class BaseTableController: UITableViewController {

    typealias StoreItem = (description: String) -> SignalProducer<Void, NoError>

    //MARK: Properties

    let itemType: TableItemType
    let store = Store()

    let addEnabled: MutableProperty<Bool> = MutableProperty(true)
    var addItem: Action<StoreItem, Void, NoError>!
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: CocoaAction.selector)

    let editEnabled: MutableProperty<Bool> = MutableProperty(true)
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: CocoaAction.selector)

    //MARK: Initialization

    init(itemType: TableItemType) {
        self.itemType = itemType
        super.init(style: .Plain)
        title = "\(itemType)s"
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: String(TableViewCell))

        addItem = Action(enabledIf: addEnabled) { [unowned self] storeItem in
            let itemDescription: SignalProducer<String, NoError> = SignalProducer { observer, _ in
                self.getItemDescription(observer)
            }

            return itemDescription.takeLast(1).flatMap(.Concat) { description in
                storeItem(description: description)
            }
        }

        // couple `addEnabled` with `addButton.enabled`
        addEnabled.producer.start(next: { [unowned self] value in
            self.addButton.enabled = value
        })


        addItem.values.observe(next: { [unowned self] in
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: .Bottom)
        })
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

    //MARK: Get Item Description

    func getItemDescription(observer: Signal<String, NoError>.Observer) {
        let newItemPrompt = UIAlertController(title: "New \(itemType)", message: "Please enter text for new " + String(itemType).lowercaseString, preferredStyle: .Alert)

        let addNewItemAction = UIAlertAction(title: "Add \(itemType)", style: .Default) { _ in
            sendCompleted(observer)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { _ in
            sendInterrupted(observer)
        }

        addNewItemAction.enabled = false
        newItemPrompt.addAction(addNewItemAction)
        newItemPrompt.addAction(cancelAction)

        newItemPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = String(self.itemType)

            let description = textField.rac_textSignal()

            description.subscribeNext { input in
                let text = input as! String
                sendNext(observer, text)
                newItemPrompt.actions.first!.enabled = text.characters.count > 0
            }
        }

        presentViewController(newItemPrompt, animated: true, completion: nil)
    }

    //MARK: Button Actions

    @objc
    private func edit(sender: AnyObject) {
        if tableView.editing {
            setEditing(false, animated: true)
            addEnabled.value = true
        } else {
            setEditing(true, animated: true)
            addEnabled.value = false
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
