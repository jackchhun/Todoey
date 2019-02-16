//
//  Item.swift
//  Todoey
//
//  Created by Kim Chhun on 16/02/2019.
//  Copyright © 2019 Kim Chhun. All rights reserved.
//

import Foundation

// Encodable, Decodable is useable with standard class property only, not custum class property
// Encodable, Decodable = Codable
class Item: Codable {
    var title: String = ""
    var done: Bool = false
}
