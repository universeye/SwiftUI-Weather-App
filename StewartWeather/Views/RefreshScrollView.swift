//
//  RefreshScrollView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/22.
//

import UIKit
import SwiftUI

struct RefreshScrollView: UIViewRepresentable {
    
    var width: CGFloat
    var height: CGFloat
    
    @EnvironmentObject var forecastListVM: ForecastListViewModel
    
    
    func makeUIView(context: Context) -> UIView {
        let scrollView = UIScrollView()
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(context.coordinator, action: #selector(Coordinator.handleRefreshControl(sender:)), for: .valueChanged)
        
        let refreshVC = UIHostingController(rootView: ListDataView(forecastListVM: _forecastListVM))
        refreshVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        scrollView.addSubview(refreshVC.view)
        return scrollView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var refreshScrollView: RefreshScrollView
        @EnvironmentObject var forecastListVM: ForecastListViewModel
        
        init(_ refreshScrollView: RefreshScrollView) {
            self.refreshScrollView = refreshScrollView
        }
        
        @objc func handleRefreshControl(sender: UIRefreshControl) { //handle what to do when pull is released
            sender.endRefreshing()
            print("refreshing...")
        }
        
    }
}
