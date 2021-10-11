//
//  StockList.swift
//  iPet
//
//  Created by Mark Lai on 19/9/2021.
//
import SwiftUI


struct StockList: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var isHistoryPresented:Bool = false

    @FetchRequest(
      entity: Stores.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Stores.name, ascending: true),
      ]
    ) var stores: FetchedResults<Stores>
    
    private func deleteStore(indexSet: IndexSet) {
        for index in indexSet {
            let storeToDelete = stores[index]
            viewContext.delete(storeToDelete)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    var body: some View {
            NavigationView {
                List {
                    HStack {
                        Button(action: {
                            isHistoryPresented.toggle()

                        }) {
                            Text("View History")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                        }
                        
                    }
                    ForEach(stores, id: \.self) { store in
                        StockRow(store: store)
                    }
                    .onDelete { (indexSet) in
                        deleteStore(indexSet: indexSet)
                    }
                }
                .fullScreenCover(isPresented: self.$isHistoryPresented){
                    StockHistory()
                }
                .navigationTitle("Stock List")
                
           //     .navigationBarTitle("")
           //     .navigationBarHidden(true)
            }
            .overlay(

                HStack {
                    Spacer()

                    VStack {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "clear.fill")
                                .font(.largeTitle)
                                .foregroundColor(.black)
                        })
                        .padding(.trailing, 20)
                        .padding(.top, 40)

                        Spacer()
                    }
                }
            )
        
        
        
    }
}

struct StockList_Previews: PreviewProvider {

    static var previews: some View {
        StockList()
    }
}

struct StockRow: View{
    @Environment(\.managedObjectContext) private var viewContext
    @State private var deduction = 0
    var store:Stores
    var body: some View{
        VStack(alignment: .leading) {
     //       GeometryReader { geometry in
                HStack {
                    Image(store.image)
                        .resizable()
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 100)
                    Spacer().frame(width:20)
                    VStack(alignment: .leading) {
                        Text("Item: \(store.name)")
                            .contentTextStyle()
                        HStack {
                            Text("volume: \(store.volume)")
                                .contentTextStyle()
                            Text(store.volume_type)
                                .contentTextStyle()
                        }
                        Text("\(String(store.quantity)) items in stock")
                            .contentTextStyle()
                        Stepper(onIncrement: {
                            self.deduction += 1
                            
                            if self.deduction > store.quantity {
                                self.deduction = store.quantity
                            }
                        }, onDecrement: {
                            self.deduction -= 1
                            
                            if self.deduction < 0 {
                                self.deduction = 0
                            }
                        }) {
                            Text((String(deduction)))
                                .contentTextStyle()
                        }
                        .padding()
                        
                        Button(action: {
                            if self.deduction > 0{
                                store.quantity = store.quantity - self.deduction
                                
                                // Store every deduction to history
                                let history = ConsumptionHistory(context: viewContext)
                                history.id = UUID()
                                history.name = store.name
                                history.deduction = self.deduction
                                history.deductionDate = Date()
                                
                                do {
                                    try viewContext.save()
                                }catch{
                                                     
                                }
                                self.deduction = 0
                            }

                        }) {
                            Text("Update Stock")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.white)
                                .bold()
                                .padding()
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                                .cornerRadius(10)
                                .padding(.horizontal)
                                
                        }
                    }
                }
        //    }
        }
    }
}
