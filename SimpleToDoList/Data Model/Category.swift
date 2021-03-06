//
//  Category.swift
//  SimpleToDoList  
//
//  Created by Dima Miro on 19.08.2018.
//  Copyright © 2018 Dima Miro. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    let items = List<Item>()
}
