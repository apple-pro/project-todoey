//
//  RealmModels.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/5/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import Foundation
import RealmSwift

class RItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var category = LinkingObjects(fromType: RCategory.self, property: "items")
}

class RCategory: Object {
    
    @objc dynamic var name: String = ""
    let items = List<RItem>()
    
}
