//
//  Models.swift
//  Accounts Manager
//
//  Created by Родион Сприкут on 23.12.2020.
//

import Foundation

struct RatesExample: Codable {
    var GBP: Double
    var USD: Double
    var EUR: Double
    var CAD: Double
    var PLN: Double
    var UAH: Double
    var JPY: Double
}

struct ParsedCurrencies: Codable {
    var rates: RatesExample
}

extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
