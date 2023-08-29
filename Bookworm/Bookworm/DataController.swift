//
//  DataController.swift
//  Bookworm
//
//  Created by Lucek Krzywdzinski on 14/01/2022.
//

import CoreData
import Foundation


class DataController: ObservableObject {
     let container = NSPersistentContainer(name: "Bookworm")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load:  \(error.localizedDescription)")
            }
        }
    }
}
