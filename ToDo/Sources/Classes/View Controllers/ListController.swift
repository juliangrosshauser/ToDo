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

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)

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
    }
}
