//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/4/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension CategoryTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = "Cell \(indexPath.row)"
        
        
        return cell
    }
}
