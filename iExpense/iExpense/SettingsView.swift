//
//  SettingsView.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 21/11/2021.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var types: Types
    
    @State var name = Values().name
    @State var Codes = Values().Codes
    
    @State var alertShowing = false
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        NavigationView{
            Form {
                Picker("Select Value", selection: $name) {
                    List {
                        ForEach(0..<Codes.count) { item in
                            Text(Codes[item])
                        }
                    }
                }
                .pickerStyle(.inline)
                .animation(.spring(), value: name)
            }
            .toolbar {
                Button("Save") {
                    
                    UserDefaults.standard.set(name, forKey: "value")
                    alertShowing = true
                }
            }
            .alert("Restart the app", isPresented: $alertShowing, actions: {
                Button("OK") {
                    dismiss()
                }
            }, message: {
                Text("To enable new value restart the app")
            })
            .navigationTitle("Settings")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(types: Types())
    }
}
