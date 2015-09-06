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

    //MARK: Properties

    let itemType: TableItemType
    private let viewModel: BaseViewModel

    private(set) var addItem: Action<Void, Void, NoError>!
    private(set) var edit: Action<Bool, Void, NoError>!

    let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: CocoaAction.selector)
    let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: nil, action: CocoaAction.selector)
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: CocoaAction.selector)

    //MARK: Initialization

    init(itemType: TableItemType, viewModel: BaseViewModel) {
        self.itemType = itemType
        self.viewModel = viewModel
        super.init(style: .Plain)
        title = "\(itemType)s"

        addItem = Action(enabledIf: viewModel.addEnabled) { [unowned self] _ in
            SignalProducer(value: self.getItemDescription())
        }

        edit = Action(enabledIf: viewModel.editEnabled) { [unowned self] execute in
            if execute { self.viewModel.editItems.apply(self.tableView.editing).start() }
            return SignalProducer.empty
        }

        addItem.unsafeCocoaAction = CocoaAction(addItem, input: ())
        edit.unsafeCocoaAction = CocoaAction(edit) { input in
            switch input {
            case is UIBarButtonItem:
                return true

            case let longPressGestureRecognizer as UILongPressGestureRecognizer:
                guard longPressGestureRecognizer.state == .Ended else { return false }
                return true

            default:
                return false
            }
        }

        addButton.target = addItem.unsafeCocoaAction
        editButton.target = edit.unsafeCocoaAction
        doneButton.target = edit.unsafeCocoaAction

        // couple `addEnabled` with `addButton.enabled`
        viewModel.addEnabled.producer.start(next: { [unowned self] value in
            self.addButton.enabled = value
        })

        // couple `editEnabled` with `editButton.enabled`
        viewModel.editEnabled.producer.start(next: { [unowned self] value in
            self.editButton.enabled = value
        })

        viewModel.addItem.values.observe(next: { [unowned self] in
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0), inSection: 0)], withRowAnimation: .Bottom)
        })

        viewModel.editItems.values.observe(next: { [unowned self] editing in
            self.setEditing(editing, animated: true)
            self.navigationItem.leftBarButtonItem = editing ? self.doneButton : self.editButton
        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: String(TableViewCell))
        
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = editButton
        navigationItem.leftItemsSupplementBackButton = true

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: edit.unsafeCocoaAction, action: CocoaAction.selector)
        longPressGestureRecognizer.delaysTouchesBegan = true
        tableView.addGestureRecognizer(longPressGestureRecognizer)
    }

    //MARK: Get Item Description

    func getItemDescription() {
        let newItemPrompt = UIAlertController(title: "New \(itemType)", message: "Please enter text for new " + String(itemType).lowercaseString, preferredStyle: .Alert)

        let addNewItemAction = UIAlertAction(title: "Add \(itemType)", style: .Default) { _ in
            viewModel.addItem.apply().start()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        viewModel.validItemDescription.producer.start(next: { addNewItemAction.enabled = $0 })
        newItemPrompt.addAction(addNewItemAction)
        newItemPrompt.addAction(cancelAction)

        newItemPrompt.addTextFieldWithConfigurationHandler { [unowned self] textField in
            textField.placeholder = String(self.itemType)
            self.viewModel.itemDescription <~ textField.rac_textSignal().toSignalProducer().map({ $0 as! String }).flatMapError { _ in SignalProducer.empty }
        }

        presentViewController(newItemPrompt, animated: true, completion: nil)
    }
}
