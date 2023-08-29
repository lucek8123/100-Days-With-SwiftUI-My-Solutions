//
//  SwipeActions.swift
//  HotProspects
//
//  Created by Lucek Krzywdzinski on 20/04/2022.
//

import SwiftUI

struct SwipeActions: View {
    var body: some View {
        List {
            Text("Tylor Swift")
                .swipeActions {
                    Button {
                        print("Deleting")
                    } label: {
                        Label("Delete", systemImage: "minus.fill")
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        print("Pinning")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct SwipeActions_Previews: PreviewProvider {
    static var previews: some View {
        SwipeActions()
    }
}
