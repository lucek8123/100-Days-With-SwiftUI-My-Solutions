//
//  Card.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 10/05/2022.
//

import Foundation

struct Card: Codable, Identifiable {
    var promt: String
    var answer: String
    let id = UUID()
    
    static let example = Card(promt: "Who played the 13rd Doctor in Doctor Who", answer: " Jodie Whittaker")
    static let empty = Card(promt: "", answer: "")
}

class Cards: ObservableObject {
    @Published var objects = [Card]()
    
    let saveKey = "cards"
    
    static let shared: Cards = {
        let entity = Cards()
        
        return entity
    }()
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let decodedData = try? JSONDecoder().decode([Card].self, from: data) {
                objects = decodedData
            }
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(objects) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
}
