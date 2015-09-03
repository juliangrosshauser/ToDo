//
//  ListTableController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit
import RealmSwift
import ReactiveCocoa

class ListTableController: BaseTableController {

    //MARK: Properties

    weak var delegate: ListControllerDelegate?

    //MARK: Initialization

    init() {
        super.init(itemType: .List, viewModel: ListViewModel())

        let storeItem: StoreItem = { [unowned self] name in
            guard let viewModel = self.viewModel as? ListViewModel else { return SignalProducer.never }
            return viewModel.addList(name)
        }

        addItem.unsafeCocoaAction = CocoaAction(addItem, input: storeItem)
        addButton.target = addItem.unsafeCocoaAction
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: UITableViewDataSource

extension ListTableController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.objects(List).count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TableViewCell)) as! TableViewCell

        cell.configure(viewModel.objects(List)[indexPath.row])
        cell.accessoryType = .DisclosureIndicator

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.lightBlue.colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            guard let viewModel = viewModel as? ListViewModel else { return }
            viewModel.deleteList(cell.id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
}

//MARK: UITableViewDelegate

extension ListTableController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.list = viewModel.objects(List)[indexPath.row]
        
        guard let splitViewController = splitViewController, detailViewController = delegate as? UIViewController else { return }

        if splitViewController.collapsed {
            splitViewController.showDetailViewController(detailViewController, sender: nil)
        } else {
            guard splitViewController.displayMode == .PrimaryOverlay else { return }
            
            UIView.animateWithDuration(0.3) {
                splitViewController.preferredDisplayMode = .PrimaryHidden
            }
            
            splitViewController.preferredDisplayMode = .Automatic
        }
    }
}

//MARK: UISplitViewControllerDelegate

extension ListTableController: UISplitViewControllerDelegate {

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // if detail view controller contains a `TodoTableController` and it's `list` property isn't set, show master view controller first, because the `TodoTableController` doesn't yet know what todos to show
        if let navigationController = secondaryViewController as? UINavigationController, todoTableController = navigationController.topViewController as? TodoTableController where todoTableController.list == nil {
            return true
        }

        return false
    }
}
