//
//  Data.swift
//  Todoey
//
//  Created by Kim Chhun on 18/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import Foundation
import RealmSwift


class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
