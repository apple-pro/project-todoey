//
//  ViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController, UITextFieldDelegate {
    
    var todos = ["Run", "Bitch", "Run"]
    var todoToAdd = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Enter a Task Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            if !self.todoToAdd.isEmpty {
                self.todos.append(self.todoToAdd)
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
        cell.textLabel?.text = todos[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        todoToAdd = textField.text!
    }

}

