//
//  SwiftResultType.swift
//  HotProspects
//
//  Created by Lucek Krzywdzinski on 16/04/2022.
//

import SwiftUI

struct SwiftResultType: View {
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }
    
    func fetchReadings() async {
        let fechTask = Task { () -> String in
            let url = URL(string: "https://hws.dev/reading.js")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings."
        }
        
        let result = await fechTask.result
        
        switch result {
        case .success(let str):
            output = str
        case .failure(let error):
            print("Download error: \(error.localizedDescription)")
        }
    }
}

struct SwiftResultType_Previews: PreviewProvider {
    static var previews: some View {
        SwiftResultType()
    }
}
