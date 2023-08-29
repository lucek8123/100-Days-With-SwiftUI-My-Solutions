//
//  ContentView.swift
//  WeSplit
//
//  Created by Lucek Krzywdzinski on 13/10/2021.
//

import SwiftUI
struct ContentView: View {
    @State private var peoplestr = "0"
    @State private var checkAmount = "1"
    @State private var tipprecentages = [5, 10, 15, 20, 25, 0]
    @State private var tipPercentage = 5
    @State private var tipNumber = "0"
    @FocusState private var amountIsFocused: Bool
    private var tipChange = ["Procentage", "Value", "Null" ]
    @State private var tipChangeNumber = 0
    private var redText: Bool {
        let OrderAmount = Double(tipNumber) ?? 0
        if tipPercentage == 5 && tipChangeNumber == 0{
            return true
        }else if tipChangeNumber ==  1 &&  OrderAmount == 0{
            return true
        }else if tipChangeNumber == 2{
            return true
        }else {
            return false
        }
    }
    
    var totalperperson: Double {
        // CAlculate cost per person heare
        let peopleCount = Double(peoplestr) ?? 0
        let tipselection = Double(tipprecentages[tipPercentage])
        let OrderAmount = Double(checkAmount) ?? 0
        var tipValue: Double
        var groundTotal: Double
        var total: Double = 0
        if tipChangeNumber == 0{
            tipValue = OrderAmount / 100 * tipselection
            groundTotal = tipValue + OrderAmount
            total = groundTotal / peopleCount
        }else if tipChangeNumber == 1{
            tipValue = Double(tipNumber) ?? 0
            groundTotal = tipValue + OrderAmount
            total = groundTotal / peopleCount
        }else {
            total = OrderAmount / peopleCount
        }
        if peoplestr == "" || Int(checkAmount) ?? 0 <= 0 || Int(peoplestr) ?? 0 <= 0 {
            return 0
        }else{
            return total
        }
        }
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Amount", text: $checkAmount).keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                }
                Section(header: Text("Write number of people")){
                    TextField("Number of people", text: $peoplestr).keyboardType(.numberPad)
                        .focused($amountIsFocused)
                }
                Section(header: Text("Chose type of tip")){
                    Picker("Chose type of yor tip", selection: $tipChangeNumber){
                        ForEach(0 ..< tipChange.count){
                            Text("\(tipChange[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("How much tip you want to leave")){
                    // Chose what procentage do you spent for tip
                    if tipChangeNumber == 0 {
                        Picker("Chose procage", selection: $tipPercentage){
                            ForEach(0 ..< tipprecentages.count){
                                Text("\(self.tipprecentages[$0])%")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }else if tipChangeNumber == 1{
                        TextField("Write value of tip", text: $tipNumber).keyboardType(.decimalPad)
                            .focused($amountIsFocused)
                    }else {
                        Text("You dont chose tip :)")
                        
                    }
                }
                Section( header: Text("Coast per person")){
                    
                    Text("$\(totalperperson, specifier: "%.2f")")
                        .foregroundColor(redText ? .red : .black)
                    
                }
            }
            .navigationBarTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard){
                    Spacer()
                    Button("Done"){
                        amountIsFocused = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
