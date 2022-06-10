//
//  SaveView.swift
//  iExpense
//
//  Created by Lucek Krzywdzinski on 17/11/2021.
//

import SwiftUI

struct SaveView: View {
    @ObservedObject var expenses: Expenses
    @ObservedObject var types: Types
    
    @State var currencyCode = Values().Codes[Values().name]
    
    @State var name: String = ""
    @State var typeNum: Int = 0 {
        didSet{
            print("\(types.items.count >= typeNum), \(typeNum)")
        }
    }
    @State var amount: Double = 0
    @State var newType = ""
    @FocusState var expenseisfocused: Bool
    @FocusState var typeFieldIsFocused: Bool
    @FocusState var amountISFocused: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView{
            VStack{
                Form {
                    TextField("Name of expense", text: $name)
                        .focused($expenseisfocused)
                    Section("Type"){
                        Picker("Type", selection: $typeNum, content: {
                            ForEach(types.items){ item in
                                Text(item.name).tag(types.items.firstIndex(of: item)!)
                                
                            }
                            
                            HStack{
                                TextField("New type", text: $newType)
                                    .foregroundColor(.blue)
                                    .focused($typeFieldIsFocused)
                                Spacer()
                                Button(action: {
                                    typeNum = types.items.count
                                    types.items.append(TypeItem(name: "\(newType)"))
                                    newType = ""
                                }, label: {
                                    Text("ADD")
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                })
                            }
                        })
                            .labelsHidden()
                        TextField("Amount", value: $amount, format: .currency(code: currencyCode))
                            .keyboardType(.decimalPad)
                            .focused($amountISFocused)
                        .navigationTitle("Add new expense")
                        
                        .toolbar {
                            Button("Save") {
                                let item = ExpenseItem(name: name, type: types.items[typeNum].name, amount: amount)
                                Expenses().items.append(item)
                                dismiss()
                            }
                        }
                        
                        .toolbar(content: {
                            ToolbarItemGroup(placement: .keyboard, content: {
                                Spacer()
                                Button(action: {
                                    expenseisfocused = false
                                    typeFieldIsFocused = false
                                    amountISFocused = false
                                }, label: {
                                    Text("Done")
                                })
                            })
                        })
                }
                    
                }
            }
        }

    }
}

struct SaveView_Previews: PreviewProvider {
    static var previews: some View {
        SaveView(expenses: Expenses(), types: Types())
    }
}
