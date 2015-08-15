//
//  ListTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit
import RealmSwift

class ListTableController: BaseTableController {

    //MARK: Properties

    weak var delegate: ListControllerDelegate?

    //MARK: Initialization

    init() {
        super.init(itemType: .List)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    //MARK: Button Actions

    @objc
    private func addItemAction(sender: AnyObject) {
        let storeList: String -> Void = { name in
            self.store.addList(name)
        }

        addItem(storeList)
    }
}

//MARK: UITableViewDataSource

extension ListTableController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.objects(List).count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!

        cell.textLabel?.text = store.objects(List)[indexPath.row].name

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.lightBlue.colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }
}

//MARK: UITableViewDelegate

extension ListTableController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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

extension ListTableController: UISplitViewControllerDelegate {

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // if detail view controller contains a `TodoTableController` and it's `list` property isn't set, show master view controller first, because the `TodoTableController` doesn't yet know what todos to show
        if let navigationController = secondaryViewController as? UINavigationController, todoController = navigationController.topViewController as? TodoController where todoController.list == nil {
            return true
        }

        return false
    }
}
