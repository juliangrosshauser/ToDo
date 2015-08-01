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
    private let viewModel = ListViewModel()
    weak var delegate: ListControllerDelegate?
    private let cellIdentifier = "listCell"

    private let addButton: UIButton = {
        let addButton = UIButton(type: .Custom)

        addButton.setImage(UIImage(named: "Plus"), forState: .Normal)
        addButton.setImage(UIImage(named: "Plus"), forState: .Highlighted)
        addButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        addButton.backgroundColor = UIColor(red:0.14, green:0.82, blue:0.99, alpha:1)

        return addButton
    }()

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        title = "Lists"
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

        view.addSubview(addButton)
    }
}

//MARK: UITableViewDataSource

extension ListController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.lists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        cell.textLabel?.text = viewModel.lists[indexPath.row].name
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension ListController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.list = viewModel.lists[indexPath.row]
        
        if let detailViewController = delegate as? UIViewController {
            splitViewController?.showDetailViewController(detailViewController, sender: nil)
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
