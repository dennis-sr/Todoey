//
//  ViewController.swift
//  Todoey
//
//  Created by Dennis Salazar on 2/19/19.
//  Copyright © 2019 Dennis Salazar. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //Saving data in UserDefaults
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let item1 = Item()
        item1.title = "Find Mike"
        
        let item2 = Item()
        item2.title = "Buy Eggs"
        
        let item3 = Item()
        item3.title = "Destroy Demogorgon"
        
        itemArray.append(item1)
        itemArray.append(item2)
        itemArray.append(item3)
        
        //get the todo list array from user defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
        
    }

    //MARK: - TableView data source methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //shows the done mark
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //set the done property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        //adds or removes the accesory check mark
        /*
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        */
        
        //flash the selected row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var newItemAddedTextField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when add item is pressed
            //print("Success!")
            //print(newItemAddedTextField.text)
            
            let newItem = Item()
            newItem.title = newItemAddedTextField.text!
            
            self.itemArray.append(newItem)
            
            //Saves the data in user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //realod the data in table view
            self.tableView.reloadData()
        }
        
        //adds the text field to the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            newItemAddedTextField = alertTextField
            
            //print(alertTextField.text)
            //print("Now")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

