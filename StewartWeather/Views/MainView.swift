//
//  MainView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2023/8/15.
//

import SwiftUI

struct MainView: View {
    let persistenceController = PersistanceController.shared
    init() {
        
        let standardAppearance = UITabBarAppearance()
        standardAppearance.configureWithTransparentBackground()
        standardAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        UITabBar.appearance().standardAppearance = standardAppearance
    }
    var body: some View {
        TabView {
            ContentView()
                .environmentObject(ForecastListViewModel())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .tabItem {
                    Label("Home", systemImage: "tornado")
                }
            Text("Hello, World!")
                .tabItem {
                    Label("Chart", systemImage: "chart.xyaxis.line")
                }
        }.tint(Color("button"))
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
