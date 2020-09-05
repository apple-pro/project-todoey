//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/4/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    @IBOutlet weak var textInput: UISearchBar!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categories = [TodoeyCategory]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }

    @IBAction func add(_ sender: UIBarButtonItem) {
        if let safeText = textInput.text, !safeText.isEmpty {
            let category = TodoeyCategory(context: self.context)
            category.name = safeText
            textInput.text = ""
            categories.append(category)
            
            saveItems()
            loadItems()
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadItems(with predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<TodoeyCategory> = TodoeyCategory.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories[indexPath.row].name
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            self.context.delete(self.categories[indexPath.row])
            self.categories.remove(at: indexPath.row)
            self.saveItems()
            self.tableView.reloadData()
            completionHandler(true)
        }

        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        return swipeActionConfig
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToTodo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let todoVC = segue.destination as? TodoListViewController {
            todoVC.category = categories[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        addBarButton.isEnabled = !searchText.isEmpty
    }
}
