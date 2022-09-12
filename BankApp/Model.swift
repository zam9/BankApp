//
//  Model.swift
//  BankApp
//
//  Created by Zam on 10.09.2022.
//

import RealmSwift

class Model: Object {
    @objc dynamic var timeAndDate: Date = Date()
    @objc dynamic var operation: String = ""
    @objc dynamic var target: String = ""
    @objc dynamic var sum: Double = 0
    @objc dynamic var type: String = ""
}
