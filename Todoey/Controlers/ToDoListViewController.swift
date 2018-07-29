//
//  ToDoListViewController.swift
//  Todoey
//
//  Created by Dima Miro on 28.07.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var toDoArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.toDoArray.append(newItem)
            self.saveItems()
            
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
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(toDoArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                toDoArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
}

