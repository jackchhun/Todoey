//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kim Chhun on 18/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    lazy var realm: Realm! = {
        try! Realm()
    }()

    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        loadCategories()
    }
    
    // MARK: - Model Manipulation Methods
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context !")
        }
        self.tableView.reloadData()
    }

    //MARK: - Add new category
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        var textField: UITextField!
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(category: newCategory)
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
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categories?[indexPath.row]
        cell.textLabel?.text = item?.name ?? "No categories added yet"
        return cell
    }
    
}


// MARK: - Tableview Delegate Methods
extension CategoryViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            controller.selectedCategory = categories?[indexPath.row]
        }
    }
}
