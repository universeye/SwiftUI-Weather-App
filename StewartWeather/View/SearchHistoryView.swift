//
//  SearchHistoryView.swift
//  StewartWeather
//
//  Created by Terry Kuo on 2021/4/19.
//

import SwiftUI

struct SearchHistoryView: View {
    
    //MARK: - Properties

    
    //@Binding var isShowingSheet: Bool
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(entity: Items.entity(), sortDescriptors: [NSSortDescriptor(key: "city", ascending: true)]) var itmes: FetchedResults<Items>
    
    @State private var isAlerting = false
    //@State var itemArray = [Items]()
    
    @EnvironmentObject var forecastListVM: ForecastListViewModel
    //MARK: - Body

    
    var body: some View {
        NavigationView {
            List {
                ForEach(itmes, id:\.self) { item in
                    Text("\(item.city ?? "Unknown")")
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                            
                            print(item.city ?? "Unknown2")
                            forecastListVM.location = item.city!
                            forecastListVM.getWeatherForecast()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                }
                .onDelete(perform: removeItem)
            }
            
            .navigationTitle("Search History")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        isAlerting = true
                        
                        print(itmes)
                    }, label: {
                        SFSymbols.add
                    })
                    .disabled(true)
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
        .alert(isPresented: $isAlerting, content: {
            Alert(title: Text("Add Tainan to search history"), message: Text("for real"), primaryButton: .default(Text("add"), action: {
                
                let newItem = Items(context: managedObjectContext)
                newItem.city = "New York"
                //self.itemArray.append(newItem)
                PersistanceController.shared.save()
                
               print("added")
            }), secondaryButton: .default(Text("cancel"), action: {
               print("cancel")
            }))
        })
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = itmes[index]
            PersistanceController.shared.delete(item)
        }
    }
}



//MARK: - Preview


struct SearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SearchHistoryView()
    }
}
