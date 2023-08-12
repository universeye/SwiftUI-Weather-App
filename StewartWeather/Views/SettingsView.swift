//
//  SettingsView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/20.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var forecastListVM: ForecastListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General"), footer: Text("Version 0.01")) {
                    Picker(selection: $forecastListVM.system, label: Text("Temperature units")) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 320)
                }
                
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        SFSymbols.xmark.bold()
                    }) // Location Button
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ForecastListViewModel())
    }
}
