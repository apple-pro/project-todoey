//
//  ViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/2/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var category: RCategory? {
        didSet {
            loadItems()
            view.backgroundColor = UIColor(hexString: category!.color)
        }
    }
    
    let realm = try! Realm()
    var items: Results<RItem>?
    
    var todoToAdd = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none

        //if you wanna check your sqlite db
        //cd <this>
        //then: "open ."
        //go to: Application Support
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //this if for realm
        print("Realm Location: \(Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? "Unknown")")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let safeCat = category {
            title = safeCat.name
            navigationController?.navigationBar.backgroundColor = UIColor(hexString: safeCat.color)
        } else {
            title = "Todoey"
            navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        }
        
        searchBar.barTintColor = navigationController?.navigationBar.backgroundColor
        navigationController?.navigationBar.tintColor = ContrastColorOf(navigationController?.navigationBar.backgroundColor ?? UIColor.systemBackground, returnFlat: true)
    }
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add", message: "Enter a Task Name", preferredStyle: .alert)
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            if !self.todoToAdd.isEmpty {
                
                let item = RItem()
                item.title = self.todoToAdd
                item.done = false
                
                self.save(item: item)
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

    func save(item: RItem) {
        try! realm.write {
            self.category?.items.append(item)
            realm.add(item)
        }
    }
    
    func loadItems(with predicate: NSPredicate? = nil) {
        items = category?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        if let safePred = predicate {
            items = items?.filter(safePred)
        }
        
        tableView.reloadData()
    }
}

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let item = items![indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        if let safeCat = category {
            let bgColor = computeColor(color: UIColor(hexString: safeCat.color)!, forIndex: indexPath)
            cell.backgroundColor = bgColor
            cell.textLabel?.textColor = ContrastColorOf(bgColor, returnFlat: true)
        } else {
            cell.backgroundColor = FlatBlue()
        }
        
        
        return cell
    }
    
    private func computeColor(color: UIColor, forIndex indexPath: IndexPath) -> UIColor {

        let percent = CGFloat(indexPath.row) / CGFloat((items?.count ?? 0) + 10)
        
        print("Darken: \(percent)")
        
        return color.darken(byPercentage: percent)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items![indexPath.row]
        
        try! realm.write {
            item.done = !item.done
        }
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            try! self.realm.write {
                self.realm.delete(self.items![indexPath.row])
            }
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
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", safeText)
                loadItems(with: predicate)
            }
        }
    }
    
}
