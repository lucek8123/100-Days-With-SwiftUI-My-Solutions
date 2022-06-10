//
//  ContentView.swift
//  BetterRest
//
//  Created by Lucek Krzywdzinski on 26/10/2021.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var sleepAmount = 8.0
    static var defaultTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    @State var wakeUp = defaultTime
    @State var coffeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    var body: some View {
        VStack{
            
        NavigationView{
            
        Form{
            
            Section("Plese select weak up date"){
                HStack{
                    Text("Wake up:")
                    Spacer()
                    DatePicker("Select wake up date", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
            }
            
            Section("Decired amount of sleep"){
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
            }
            Section("Dayly coffe intake"){
            Stepper(coffeAmount == 1 ? "1 cup" : "\(coffeAmount) cups", value: $coffeAmount, in: 1...20)
            }
            
        }
        .font(.system(size: 20))
        .navigationTitle("BetterRest")
        .alert(alertTitle, isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
            
        }
            Button(action: {
                calculateBedTime()
            }, label: {
                Text("Calculate")
                    .font(.title.bold())
                    .foregroundColor(.white)
                    .padding()
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 10)
                    
            })
                .buttonBorderShape(.roundedRectangle(radius: 10))
                
        }
    }
    func calculateBedTime(){
    do {
        let configuration = MLModelConfiguration()
        let model =   try sleepCalculator(configuration: configuration)
        
        let compoments = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = compoments.hour ?? 0
        let minutes = compoments.minute ?? 0
        let secunds = (hour * 60  * 60) + (minutes * 60)
        let prediction = try model.prediction(wake: Double(secunds), estimatedSleep: sleepAmount, coffee: Double(coffeAmount))

        let sleepTime = wakeUp - prediction.actualSleep
        alertTitle = "Your ideal bedtime is…"
        alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
        showingAlert = true
    } catch {
        alertTitle = "Error"
        alertMessage = "Sorry, there was a problem calculating your bedtime."
        showingAlert = true
    }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
