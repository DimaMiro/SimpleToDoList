//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dima Miro on 11.08.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    lazy var realm:Realm = {
        return try! Realm()
    }()

    
    var categories: Results<Category>?
    
    
    override func viewWillAppear(_ animated: Bool) {
        // This must to be added for reloading this tableView once Back button in items is pressed.
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Remove line on bottom of navitaionBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        // Get the path to realm db file
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
        
        //Set tableView backgroundImage
        let backgroundImage = UIImageView(image: UIImage(named: "backgroundImage"))
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        self.tableView.backgroundView = backgroundImage
        
        
        
        self.tableView.tableFooterView = UIView()
    }
    
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        if let containedItems = categories?[indexPath.row].items.count {
            if containedItems != 0 {
                cell.detailTextLabel?.text = "\(containedItems) items"
            } else {
                cell.detailTextLabel?.text = ""
            }
        }
        
        
        return cell
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()

    }
    
    //MARK: - Delete Data From Swipe
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            guard let categoryForDeletion = self.categories?[indexPath.row] else {fatalError()}
            do {
                try self.realm.write {
                    
                    self.realm.delete(categoryForDeletion.items)
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - Add New Category Method
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if textField.text != " " &&  textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.dateCreated = Date()
                self.save(category: newCategory)
                
                
            } else {
                
                let errorAlert = UIAlertController(title: "Error", message: "Please name a category", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(errorAlert, animated: true, completion: nil)
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Name new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }

    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
}














