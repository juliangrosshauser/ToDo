//
//  TodoController.swift
//  ToDo
//
//  Created by Julian Grosshauser on 21/07/15.
//  Copyright © 2015 Julian Grosshauser. All rights reserved.
//

import UIKit

class TodoController: UIViewController, ListControllerDelegate {

    //MARK: Properties

    private let tableView = UITableView()
    private let cellIdentifier = "todoCell"
    
    //MARK: ListControllerDelegate
    
    var list: List? {
        didSet {
            if let list = list {
                title = list.name
            }
        }
    }

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        title = "Todos"
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
