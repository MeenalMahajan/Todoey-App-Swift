//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    
    var itemArray = ["buy fruits", "Make cake", "water plants"]
    
    let defaulta = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = defaulta.array(forKey: "ToDoListItemArray") as? [String]{
            
            itemArray = item
        }
    
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            self.itemArray.append(textfield.text!)
            
            self.defaulta.set(self.itemArray, forKey: "ToDoListItemArray")
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alerttextfield in
            alerttextfield.placeholder = "Create new item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

