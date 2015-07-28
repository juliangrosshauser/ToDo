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
    private let cellIdentifier = "listCell"

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
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
