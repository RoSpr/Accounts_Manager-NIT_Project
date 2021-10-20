//
//  AccountChange.swift
//  Accounts Manager
//
//  Created by Rodion on 19.10.2021.
//

import Foundation
import RealmSwift

class AccountChange: Object {
    @objc dynamic var cellOwner: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var expense: Int = 0
    @objc dynamic var receipt: Int = 0
}
