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
    private let viewModel = TodoViewModel()
    
    private let addButton: UIButton = {
        let addButton = UIButton(type: .Custom)
        
        addButton.setImage(UIImage(named: "Plus"), forState: .Normal)
        addButton.setImage(UIImage(named: "Plus"), forState: .Highlighted)
        addButton.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin]
        addButton.backgroundColor = UIColor(red:0.14, green:0.82, blue:0.99, alpha:1)
        
        return addButton
    }()
    
    //MARK: ListControllerDelegate
    
    var list: List? {
        didSet {
            if list != oldValue {
                tableView.reloadData()
                
                if let list = list {
                    title = list.name
                }
            }
        }
    }

    //MARK: Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.dataSource = self
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
        
        let addButtonSize: CGFloat = 100
        
        addButton.frame = CGRect(x: 0, y: view.bounds.size.height - addButtonSize - 30, width: addButtonSize, height: addButtonSize)
        addButton.center.x = view.center.x
        addButton.layer.cornerRadius = addButtonSize / 2
        
        view.addSubview(addButton)
    }
}

//MARK: UITableViewDataSource

extension TodoController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.todos.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        cell.textLabel?.text = list!.todos[indexPath.row].text
        
        return cell
    }
}
