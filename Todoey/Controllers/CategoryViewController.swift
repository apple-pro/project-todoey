//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/4/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var textInput: UISearchBar!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let realm = try! Realm()
    var categories: Results<RCategory>? //this is like context and arrray combined, autorefresh included

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        if let safeText = textInput.text, !safeText.isEmpty {
            
            let category = RCategory()
            category.name = safeText
            
            textInput.text = ""
            
            transact {
                realm.add(category)
            }
            
            tableView.reloadData()
        }
    }
    
    func loadCategories(with predicate: NSPredicate? = nil) {
        categories = realm.objects(RCategory.self).sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
    func transact(_ action: () -> Void) {
        try! realm.write(action)
    }
}

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            let bgColor = UIColor(hexString: category.color)
            cell.textLabel?.textColor = ContrastColorOf(bgColor!, returnFlat: true)
            cell.backgroundColor = bgColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.transact {
                if let toDelete = self.categories?[indexPath.row] {
                    self.realm.delete(toDelete)
                }
            }
            self.tableView.reloadData()
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let todoVC = segue.destination as? TodoListViewController {
            if let selectedCategory = categories?[tableView.indexPathForSelectedRow!.row] {
                todoVC.category = selectedCategory
            }
        }
    }
}

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        addBarButton.isEnabled = !searchText.isEmpty
    }
}
