//
//  Item.swift
//  Todoey
//
//  Created by StartupBuilder.INFO on 9/3/20.
//  Copyright © 2020 StartupBuilder.INFO. All rights reserved.
//

import Foundation

class Item {
    var title: String = ""
    var done: Bool = false
    
    init(withTitle title: String) {
        self.title = title
    }
}
