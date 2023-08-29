//
//  AddresView.swift
//  CupcakeCorner
//
//  Created by Lucek Krzywdzinski on 07/01/2022.
//

import SwiftUI

struct AddresView: View {
    @StateObject var order: Order

    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.name)
                TextField("Street Adress", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip code", text: $order.zip)
            }
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.hasValidAddress == false)
        }
        .navigationTitle("Address Details")
        .navigationBarTitleDisplayMode(.inline )
    }
}

struct AddresView_Previews: PreviewProvider {
    static var previews: some View {
        AddresView(order: Order())
    }
}
