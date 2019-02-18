//
//  ViewController.swift
//  Todoey
//
//  Created by Kim Chhun on 16/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    let todoListArrayKey = "TodoListArray"
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var itemArray = [Item]()

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadItems()
    }

    // MARK: - Add new item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        var textField: UITextField!

        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField?.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
        }

        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Model Manipulation Methods
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let searchPredicate = request.predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
            
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context : \(error)")
        }
        
        tableView.reloadData()
    }

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context !")
        }
        self.tableView.reloadData()
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
        
//        context.delete(item)
//        itemArray.remove(at: indexPath.row)
        
        item.done = !item.done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - SearchBar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()    // Dismiss the search and keyboard
            }
            
        }
    }
}

