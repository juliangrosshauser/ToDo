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
        
        addButton.addTarget(self, action: "addTodo:", forControlEvents: .TouchUpInside)
        
        view.addSubview(addButton)
    }
    
    //MARK: Button Actions
    
    @objc
    private func addTodo(sender: UIButton) {
        let newTodoPrompt = UIAlertController(title: "New Todo", message: "Please enter a todo", preferredStyle: .Alert)
        
        let addNewTodoAction = UIAlertAction(title: "Add Todo", style: .Default) { alert in
            let newTodo = Todo()
            newTodo.text = newTodoPrompt.textFields!.first!.text!
            
            self.viewModel.addTodo(newTodo, toList: self.list!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        addNewTodoAction.enabled = false
        newTodoPrompt.addAction(addNewTodoAction)
        newTodoPrompt.addAction(cancelAction)
        
        
        newTodoPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Todo"
            textField.addTarget(self, action: "newTodoChanged:", forControlEvents: .EditingChanged)
        }
        
        presentViewController(newTodoPrompt, animated: true, completion: nil)
    }
    
    //MARK: Text Field Actions
    
    @objc
    private func newTodoChanged(sender: UITextField) {
        if let newTodoPrompt = presentedViewController as? UIAlertController {
            newTodoPrompt.actions.first!.enabled = newTodoPrompt.textFields!.first!.text!.characters.count > 0
        }
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
