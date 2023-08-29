//
//  ManuallyObservableObject.swift
//  HotProspects
//
//  Created by Lucek Krzywdzinski on 16/04/2022.
//

import SwiftUI

@MainActor class DelayedUdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ManuallyObservableObject: View {
    @StateObject private var updater = DelayedUdater()
    
    var body: some View {
        Text("The value is \(updater.value)")
    }
}

struct ManuallyObservableObject_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
