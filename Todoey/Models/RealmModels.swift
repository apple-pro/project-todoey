//
//  RealmModels.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/5/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class RItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var category = LinkingObjects(fromType: RCategory.self, property: "items")
}

class RCategory: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = UIColor.randomFlat().hexValue()
    let items = List<RItem>()
    
}
