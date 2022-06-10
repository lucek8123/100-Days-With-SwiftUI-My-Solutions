//
//  Types.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 20/11/2021.
//

import Foundation

class Types: ObservableObject {
    @Published var items = [TypeItem(name: "Haven't name")] {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Types")
                print(encoded)
            }
        }
    }
    init() {
        if let savedTypes = UserDefaults.standard.data(forKey: "Types") {
            if let decodedTypes = try? JSONDecoder().decode([TypeItem].self, from: savedTypes) {
                items = decodedTypes
                print("decoded types!")
                return
            }
        }
        items = [TypeItem(name: "Haven't name")]
        print("dont encode")
    }
}
