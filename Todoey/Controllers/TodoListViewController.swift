//
//  ViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var category: TodoeyCategory? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var todoToAdd = ""
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = category?.name
        
        //if you wanna check your sqlite db
        //cd <this>
        //then: "open ."
        //go to: Application Support
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Enter a Task Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            if !self.todoToAdd.isEmpty {
                
                let item = Item(context: self.context)
                item.category = self.category
                item.title = self.todoToAdd
                item.done = false
                
                self.saveItems()
                self.loadItems()
                
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Task"
            alertTextField.delegate = self
        }
        
        todoToAdd = ""
        present(alert, animated: true, completion: nil)
    }

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadItems(with predicate: NSPredicate? = nil) {
        let finalPred = predicate ?? NSPredicate(format: "category.name == %@", category!.name!)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = finalPred
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            items = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        item.done = !item.done
        saveItems()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.context.delete(self.items[indexPath.row])
            self.items.remove(at: indexPath.row)
            self.saveItems()
            self.tableView.reloadData()
            completionHandler(true)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
}

extension TodoListViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.todoToAdd = textField.text!
    }
}

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search: \(searchBar.text!)")
    
        if let safeText = searchBar.text {
            if safeText.isEmpty {
                loadItems()
                
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
            } else {
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@ and category.name == %@", safeText, category!.name!)
                loadItems(with: predicate)
            }
        }
    }
    
}
