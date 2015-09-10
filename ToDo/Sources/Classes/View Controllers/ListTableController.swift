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

    private let listViewModel = ListViewModel()
    weak var delegate: ListControllerDelegate?
    private let itemCount: MutableProperty<Int> = MutableProperty(0)

    //MARK: Initialization

    init() {
        super.init(itemType: .List, viewModel: listViewModel)
        itemCount <~ listViewModel.itemCount
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//MARK: UITableViewDataSource

extension ListTableController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.objects(List).count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(TableViewCell)) as! TableViewCell

        cell.configure(listViewModel.item(indexPath.row))
        cell.accessoryType = .DisclosureIndicator

        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = Color.lightBlue.colorWithAlphaComponent(0.3)
        cell.selectedBackgroundView = selectedBackgroundView

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! TableViewCell
            listViewModel.deleteList(cell.id)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        listViewModel.moveList(sourceIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
}

//MARK: UITableViewDelegate

extension ListTableController {
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.listChanged(listViewModel.item(indexPath.row))
        
        guard let splitViewController = splitViewController, detailViewController = delegate as? UIViewController else { return }

        if splitViewController.collapsed {
            splitViewController.showDetailViewController(detailViewController, sender: nil)
        } else {
            guard splitViewController.displayMode == .PrimaryOverlay else { return }
            UIView.animateWithDuration(0.3) { splitViewController.preferredDisplayMode = .PrimaryHidden }
            splitViewController.preferredDisplayMode = .Automatic
        }
    }
}

//MARK: UISplitViewControllerDelegate

extension ListTableController: UISplitViewControllerDelegate {

    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        // if detail view controller contains a `TodoTableController` and it's `list` property isn't set, show master view controller first, because the `TodoTableController` doesn't yet know what todos to show
        if let navigationController = secondaryViewController as? UINavigationController, todoTableController = navigationController.topViewController as? TodoTableController where todoTableController.list.value == nil {
            return true
        }

        return false
    }
}
