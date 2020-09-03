//
//  ViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    var todos: [Item] = [
        Item(withTitle: "Test")
    ]
    var todoToAdd = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Enter a Task Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            if !self.todoToAdd.isEmpty {
                self.todos.append(Item(withTitle: self.todoToAdd))
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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = todos[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = todos[indexPath.row]
        item.done = !item.done
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        todoToAdd = textField.text!
    }

}

