//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var toDoItems : Results<Item>?
   
    var selectedCategory : Category?{
        
        didSet{
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//         print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let colourHex = selectedCategory?.colour{
           
            title = selectedCategory!.name
            
            guard let navbar = navigationController?.navigationBar else{fatalError("navigation controller does not exists")
            }
            
            
            if let navBarColor = UIColor(hexString: colourHex){
                
                navbar.subviews[0].backgroundColor = navBarColor
                navbar.backgroundColor = navBarColor.darken(byPercentage: 1.0)
               
                //navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchBar.barTintColor = navBarColor
            }
           
            searchBar.searchTextField.backgroundColor = FlatWhite()
           
            
        }
    
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(toDoItems!.count)){
                
                cell.backgroundColor = colour
                
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
        
            //Ternary Operator -> value = condition ? valueTrue : valurFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            
            cell.textLabel?.text = "No Item added"
        }
       
        
        return cell
    }
    
    
    // MARK: - TableView Delegate methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row]{
          
            do{
                
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch{
                print("Error saving data status \(error)")
            }
        }
        
        let selectedIndexPath = IndexPath(item: indexPath.row , section: 0)
        self.tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        let newitem = Item()
                        newitem.title = textfield.text!
                        newitem.dateCreated = Date()
                        currentCategory.items.append(newitem)
                    }
                }catch{
                    
                    print("Error while saving data \(error)")
                }
               
            }
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alerttextfield in
            alerttextfield.placeholder = "Create new item"
            textfield = alerttextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
                                                        
    func loadItems(){
        

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.toDoItems?[indexPath.row]{
      
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("error deleting category \(error)")
            }
        }
    }
    
}

 //MARK: - SearchBar Delegate methods

extension ToDoListViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    
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
