//
//  ListController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class ListController: UIViewController {

    //MARK: Properties

    private let tableView = UITableView()
    private let store = Store()
    weak var delegate: ListControllerDelegate?
    private let cellIdentifier = "listCell"

    private let addButton: UIButton = {
        let addButton = UIButton(type: .Custom)

        addButton.setImage(UIImage(named: "Plus"), forState: .Normal)
        addButton.setImage(UIImage(named: "Plus"), forState: .Highlighted)
        addButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        addButton.backgroundColor = Color.lightBlue

        return addButton
    }()

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        title = "Lists"
        
        NSNotificationCenter.defaultCenter().addObserverForName(Store.modelChangedNotification, object: store, queue: NSOperationQueue.mainQueue()) { _ in
            self.tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.frame = view.bounds
        view.addSubview(tableView)

        let addButtonSize: CGFloat = 100

        addButton.frame = CGRect(x: 0, y: view.bounds.size.height - addButtonSize - 30, width: addButtonSize, height: addButtonSize)
        addButton.center.x = view.center.x
        addButton.layer.cornerRadius = addButtonSize / 2

        addButton.addTarget(self, action: "transformButton:", forControlEvents: .TouchDown)
        addButton.addTarget(self, action: "addList:", forControlEvents: .TouchUpInside)

        view.addSubview(addButton)
    }

    //MARK: Button Actions

    @objc
    private func addList(sender: UIButton) {
        resetTransformOfButton(sender)
        
        let newListPrompt = UIAlertController(title: "New List", message: "Please enter a list name", preferredStyle: .Alert)

        let addNewListAction = UIAlertAction(title: "Add List", style: .Default) { alert in
            self.store.addList(newListPrompt.textFields!.first!.text!)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)

        addNewListAction.enabled = false
        newListPrompt.addAction(addNewListAction)
        newListPrompt.addAction(cancelAction)


        newListPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "List Name"
            textField.addTarget(self, action: "newListNameChanged:", forControlEvents: .EditingChanged)
        }

        presentViewController(newListPrompt, animated: true, completion: nil)
    }

    //MARK: Text Field Actions

    @objc
    private func newListNameChanged(sender: UITextField) {
        if let newListPrompt = presentedViewController as? UIAlertController {
            newListPrompt.actions.first!.enabled = newListPrompt.textFields!.first!.text!.characters.count > 0
        }
    }

    //MARK: Button Transform

    @objc
    private func transformButton(button: UIButton) {
        UIView.animateWithDuration(0.1) {
            button.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1.0)
        }
    }

    private func resetTransformOfButton(button: UIButton) {
        UIView.animateWithDuration(0.2, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 1.0, options: .CurveEaseInOut, animations: {
            button.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }
}

//MARK: UITableViewDataSource

extension ListController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.objects(List).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        cell.textLabel?.text = store.objects(List)[indexPath.row].name
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.lightBlue.colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension ListController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.list = store.objects(List)[indexPath.row]
        
        if let splitViewController = splitViewController, detailViewController = delegate as? UIViewController {
            if splitViewController.collapsed {
                splitViewController.showDetailViewController(detailViewController, sender: nil)
            } else {
                if splitViewController.displayMode == .PrimaryOverlay {
                    UIView.animateWithDuration(0.3) {
                        splitViewController.preferredDisplayMode = .PrimaryHidden
                    }
                    
                    splitViewController.preferredDisplayMode = .Automatic
                }
            }
        }
    }
}

//MARK: UISplitViewControllerDelegate

extension ListController: UISplitViewControllerDelegate {

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // if detail view controller contains a `TodoController` and it's `list` property isn't set, show master view controller first, because the `TodoController` doesn't yet know what todos to show
        if let navigationController = secondaryViewController as? UINavigationController, todoController = navigationController.topViewController as? TodoController where todoController.list == nil {
            return true
        }

        return false
    }
}
