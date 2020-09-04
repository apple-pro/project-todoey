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
}

extension CategoryTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        addBarButton.isEnabled = !searchText.isEmpty
    }
}
