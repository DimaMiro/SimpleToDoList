//
//  Item.swift
//  Todoey
//
//  Created by Dima Miro on 19.08.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date?
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
