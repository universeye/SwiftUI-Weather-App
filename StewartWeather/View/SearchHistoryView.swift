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
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Items.entity(), sortDescriptors: [NSSortDescriptor(key: "city", ascending: true)]) var itmes: FetchedResults<Items>
    
    @State private var isAlerting = false
    
    @State var itemArray = [Items]()
    
    var body: some View {
        NavigationView {
            List (itmes, id:\.self) { item in
                Text("\(item.city ?? "Unknown")")
            }
            .navigationTitle("Search History")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    
                    Button(action: {
                        isAlerting = true
                    }, label: {
                        SFSymbols.add
                    })
                    
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                            .bold()
                    })
                    
                    
                }
            }
        }
        .alert(isPresented: $isAlerting, content: {
            Alert(title: Text("Add Tainan to search history"), message: Text("for real"), primaryButton: .default(Text("add"), action: {
                
                let newItem = Items(context: managedObjectContext)
                newItem.city = "Tainan"
                self.itemArray.append(newItem)
                PersistanceController.shared.save()
                
               print("added")
            }), secondaryButton: .default(Text("cancel"), action: {
               print("cancel")
            }))
        })
    }
}

struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView(isShowingSheet: .constant(false))
    }
}
