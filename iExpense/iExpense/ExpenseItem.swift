//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 15/11/2021.
//

import Foundation

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
