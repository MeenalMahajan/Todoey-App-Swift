//
//  Item.swift
//  Todoey
//
//  Created by Apple on 04/05/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    
    @Persisted var title : String = ""
    @Persisted var done : Bool = false
    @Persisted var dateCreated : Date?
    
    
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>
    
    //var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
