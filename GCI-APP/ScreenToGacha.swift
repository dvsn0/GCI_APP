//
//  ScreenToGacha.swift
//  GCI-APP
//
//  Created by Brent Matthew Ortizo on 10/26/24.
//

import SwiftUI

struct ScreenToGacha: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Team Focus GCI-200")
                    .font(.largeTitle)
                    .padding()
                
                NavigationLink(destination: GachaScreen()) {
                    Text("Go to Gacha")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
