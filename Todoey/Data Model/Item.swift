//
//  Item.swift
//  Todoey
//
//  Created by Kim Chhun on 18/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
