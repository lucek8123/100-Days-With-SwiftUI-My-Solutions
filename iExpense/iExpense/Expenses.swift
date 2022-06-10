//
//  Expenses.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 15/11/2021.
//

import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
                print(encoded)
            }
        }
    }

    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                print("decoded Items!")
                print(items)
                return
            }
        }
    items = []
    }
}
