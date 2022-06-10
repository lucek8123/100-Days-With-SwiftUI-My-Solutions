//
//  TypeItem.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 20/11/2021.
//

import Foundation


struct TypeItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
}
