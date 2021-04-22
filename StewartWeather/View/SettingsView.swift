//
//  SettingsView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/20.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var isShowGreeting = false
    
    var body: some View {
        NavigationView {
            VStack {
                Toggle("Show Greeting", isOn: $isShowGreeting)
                    .padding()
                List {
                    if isShowGreeting {
                        ForEach(0 ..< 5) { index in
                            Text("haha: \(index)")
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Settings")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
