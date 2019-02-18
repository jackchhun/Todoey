//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Kim Chhun on 18/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    // MARK: - Model Manipulation Methods
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context : \(error)")
        }
        
        tableView.reloadData()
    }

    func saveCatgories() {
        do {
            try context.save()
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
            let newCategory = Category(context: self.context)
            newCategory.name = textField?.text!
            self.categoryArray.append(newCategory)
            self.saveCatgories()
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = categoryArray[indexPath.row]
        cell.textLabel?.text = item.name
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
            controller.selectedCategory = categoryArray[indexPath.row]
        }
    }
}
