//
//  CoreDataProjectApp.swift
//  CoreDataProject
//
//  Created by Lucek Krzywdzinski on 30/01/2022.
//

import SwiftUI

@main
struct CoreDataProjectApp: App {
    @StateObject private var dataControler = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataControler.container.viewContext)
        }
    }
}
