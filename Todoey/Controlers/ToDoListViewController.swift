//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Dima Miro on 28.07.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var toDoArray = [Item]()
    
    var selectedCategory : Category?{
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = toDoArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.isDone ? .checkmark : .none

        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        toDoArray[indexPath.row].isDone = !toDoArray[indexPath.row].isDone
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != " " {
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.isDone = false
                newItem.parentCategory = self.selectedCategory
                self.toDoArray.append(newItem)
                self.saveItems()
            } else {
                let errorAlert = UIAlertController(title: "Error", message: "Please name the item", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = compoundPredicate
        do {
            toDoArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

















