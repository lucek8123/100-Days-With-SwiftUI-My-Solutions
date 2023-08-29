//
//  loadDocument.swift
//  BucketList
//
//  Created by Lucek Krzywdzinski on 09/03/2022.
//

import Foundation

extension Bundle {
    func loadDocument<T: Codable>(from url: URL) -> T{
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Cant load a data from url")
        }
        
        let decoder = JSONDecoder()
        let formater = DateFormatter()
        formater.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formater)
        
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Filed to decode data \(data) from bundle")
        }
        
        return loaded
    }
}
