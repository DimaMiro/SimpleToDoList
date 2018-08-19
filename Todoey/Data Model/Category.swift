//
//  Category.swift
//  Todoey
//
//  Created by Dima Miro on 19.08.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
