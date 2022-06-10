//
//  ContentView.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 11/11/2021.
//

import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @StateObject var types = Types()
    
    @State var currencyCode = { () -> String in
        if Values().Codes[Values().name] == "USD" {
            return "USD"
        }else if Values().Codes[Values().name] == "PLN" {
            return "PLN"
        }
        return "EUR"
    }
    @State private var saveViewOpen = false
    @State private var settingsViewOpen = false
    
    func  removeItems(at offsetses: IndexSet) {
        Expenses().items.remove(atOffsets: offsetses)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Expenses().items) { item in
                    HStack{
                        VStack{
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        Spacer()
                        Text(item.amount, format: .currency(code: currencyCode()))
                    }
                    .accessibilityElement()
                    .accessibilityLabel("\(item.name) costs \(item.amount, format: .currency(code: currencyCode()))")
                    .accessibilityHint("\(item.type)")
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar(content: {
                Button(action: {
                    saveViewOpen = true
                }, label: {
                    Image(systemName: "plus")
                })
            })
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading, content: {
                    Button(action: {
                        settingsViewOpen = true
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                })
            })
            .sheet(isPresented: $saveViewOpen) {
                SaveView(expenses: expenses, types: types)
            }
            .sheet(isPresented: $settingsViewOpen, content: {
                SettingsView(types: types)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
