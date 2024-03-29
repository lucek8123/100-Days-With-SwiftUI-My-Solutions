//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by Lucek Krzywdzinski on 07/01/2022.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject var order: Order

    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    var body: some View {
        ScrollView {
            VStack {
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                    .frame(height: 233)
                    .accessibilityElement(children: .ignore)
                
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                    .font(.title)
                
                Button("Place Order") {
                    // more code to come
                }
                    .padding()
            }
        }
        .navigationTitle("Check out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.httpMethod = "POST"
        
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            // handle the result
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) is on the way!"
            showingConfirmation = true
        } catch {
            print("Checkout failed")
            confirmationMessage = "Uppsss... Therse a problem when sending this order to our central"
            showingConfirmation = true
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
