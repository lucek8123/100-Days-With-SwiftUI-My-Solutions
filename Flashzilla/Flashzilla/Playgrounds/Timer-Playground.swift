//
//  Timer-Playground.swift
//  Flashzilla
//
//  Created by Lucek Krzywdzinski on 07/05/2022.
//

import SwiftUI

struct Timer_Playground: View {
    // @Published
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State private var counter = 0
    
    
    var body: some View {
        Text("Hello, World!")
            .padding()
            .onReceive(timer) { time in
                if counter == 5 {
                    timer.upstream.connect().cancel()
                } else {
                    print("Time is now \(time)")
                }
                counter += 1
            }
    }
}

struct Timer_Playground_Previews: PreviewProvider {
    static var previews: some View {
        Timer_Playground()
    }
}
