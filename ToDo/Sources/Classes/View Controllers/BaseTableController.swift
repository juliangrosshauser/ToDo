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

    let addEnabled: MutableProperty<Bool> = MutableProperty(true)
    var addItem: Action<StoreItem, Void, NoError>!

    let store = Store()
    let itemType: TableItemType
    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: CocoaAction.selector)
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: CocoaAction.selector)
    let notificationCenter = NSNotificationCenter.defaultCenter()

    //MARK: Initialization

    init(itemType: TableItemType) {
        self.itemType = itemType

        super.init(style: .Plain)

        title = "\(itemType)s"
        addButton.target = self
        editButton.target = self

        // couple `addEnabled` with `addButton.enabled`
        addEnabled.producer.start(next: { [unowned self] value in
            self.addButton.enabled = value
        })

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
