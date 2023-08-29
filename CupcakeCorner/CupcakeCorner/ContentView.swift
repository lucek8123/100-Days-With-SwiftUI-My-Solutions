//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Lucek Krzywdzinski on 06/01/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.type) {
                        ForEach(Order.types.indices) {
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cakes: \(order.quantity)", value: $order.quantity, in: 3...20)
                }
                Section {
                    Toggle("Any special requests?", isOn: $order.specialRequestEnabled.animation())
                    if order.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.extraFrosting)
                        Toggle("Add extra sprincles", isOn: $order.addSprinkles)
                    }
                }
                Section {
                    NavigationLink {
                        AddresView(order: order)
                    } label: {
                        Text("Derlivery details ")
                    }
                }
            }
            .navigationTitle("Capcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
