//
//  SearchHistoryView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/19.
//

import SwiftUI

struct SearchHistoryView: View {
    
    
    @Binding var isShowingSheet: Bool
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: Items.entity(), sortDescriptors: [NSSortDescriptor(key: "city", ascending: true)]) var itmes: FetchedResults<Items>
    
    var body: some View {
        NavigationView {
            List {
                
            }
            .navigationTitle("Search History")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingSheet = false
                    }, label: {
                        Text("Done")
                            .bold()
                    })
                }
            }
        }
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(isShowingSheet: .constant(false))
    }
}
