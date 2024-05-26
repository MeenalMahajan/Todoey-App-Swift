//
//  Category.swift
//  Todoey
//
//  Created by Apple on 04/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @Persisted var name : String = ""
    @Persisted var colour : String = ""
    @Persisted var items = List<Item>()
}
