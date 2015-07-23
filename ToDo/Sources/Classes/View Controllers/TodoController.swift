//
//  TodoController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class TodoController: UIViewController {

    private let tableView = UITableView()

    init() {
        super.init(nibName: nil, bundle: nil)

        title = "Todos"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
