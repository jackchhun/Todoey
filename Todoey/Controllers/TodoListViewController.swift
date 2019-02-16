//
//  ViewController.swift
//  Todoey
//
//  Created by Kim Chhun on 16/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let todoListArrayKey = "TodoListArray"
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            let newItem = Item()
            newItem.title = "Find Mike"
            itemArray.append(newItem)
        }
        
        do {
            let newItem = Item()
            newItem.title = "Buy Eggos"
            itemArray.append(newItem)
        }
        
        do {
            let newItem = Item()
            newItem.title = "Destroy Demogorgon"
            itemArray.append(newItem)
        }
        
        if let items = defaults.array(forKey: todoListArrayKey) as? [Item] {
            itemArray = items
        }
    }

    // MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        var textField: UITextField!
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen with the user clicks the Add Item button on our Alert
            let newItem = Item()
            newItem.title = textField?.text! ?? ""
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: self.todoListArrayKey)
            self.tableView.reloadData()
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    

}

// MARK: - Tableview Datasource Methods
extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
    }
    
}

// MARK: - Tableview Delegate Methods
extension TodoListViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = itemArray[indexPath.row]
        
        item.done = !item.done
        if !item.done {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
}
