//
//  ViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        cell.textLabel?.text = "Test: \(indexPath.row)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
        }
        
    }

}

