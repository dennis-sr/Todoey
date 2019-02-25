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
    
    //Creating a file path
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //Note: - now using NSCoder
    //Saving data in UserDefaults
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get the todo list array from user defaults
        /*Now using NSCoder
         if let items = defaults.array(forKey: "TodoListArray") as? [Item]{
            itemArray = items
        }
         */
        loadItems()
        
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
        
        saveItems()
        
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
            
            /* Now using NSEncoder
            //Saves the data in user defaults
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            */
            self.saveItems()
            
            
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
    
    //MARK: - Model Manipulation Data
    func saveItems() {
        
        //NSEncoder
        let encoder = PropertyListEncoder()
        
        do{
            
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
            
        }
        catch{
            print ("Error enconfing item array: \(error)")
        }
        
        //realod the data in table view
        tableView.reloadData()
        
    }
    
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            
            let decoder = PropertyListDecoder()
            
            do{
            
                itemArray = try decoder.decode([Item].self, from: data)
                
            }
            catch{
                print("Error decoding items array: \(error)")
            }
            
        }
        
    }
    

}

