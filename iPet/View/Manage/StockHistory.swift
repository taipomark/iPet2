//
//  PurchaseHistory.swift
//  iPet
//
//  Created by Mark Lai on 23/9/2021.
//

import SwiftUI

struct StockHistory: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var isHistoryPresented:Bool = false
    @State private var data:[Double] = []
    @State private var label:[String] = []
    
    
    
  //  @State var isHistoryPresented:Bool = false

    @FetchRequest(
      entity: PurchaseHistory.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \PurchaseHistory.name, ascending: true),
      ]
    ) var histories: FetchedResults<PurchaseHistory>
    
    func group(_ result : FetchedResults<PurchaseHistory>)-> [[PurchaseHistory]] {
            
        return  Dictionary(grouping: result){ (element : PurchaseHistory)  in
            StockHistory.taskDateFormat.string(from: element.purchaseDate)
        }.values.sorted() { $0[0].purchaseDate > $1[0].purchaseDate }
            
    }

    
    
    private func deleteHistory(indexSet: IndexSet) {
        for index in indexSet {
            let historyToDelete = histories[index]
            viewContext.delete(historyToDelete)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List {
                    HStack {
                        Button(action: {
                            
                            isHistoryPresented.toggle()

                        }) {
                            Text("Purchase Proportion")
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
                    ForEach(group(histories), id: \.self) { history in
                        Section(header: Text(history[0].purchaseDate, formatter: Self.taskDateFormat)) {
                            
                            ForEach(history, id: \.self){ realHistory in
                                VStack(alignment: .leading){
                                    //        Text("Item Name: \(realHistory.name)")
                                    //        Spacer()
                                    Text("Item: \(realHistory.name)")
                                    Spacer()
                                    Text("Quantity: \(realHistory.quantity)")
                                    Spacer()
                                    Text("Volume: \(realHistory.volume) \(realHistory.volume_type)")
                                    Spacer()
                                    Text("Amount: $ \(realHistory.amount, specifier: "%.2f")")
                                }
                            }
                            .onDelete { (indexSet) in
                                deleteHistory(indexSet: indexSet)
                            }

                        }
                        
                    }
                    
                }
                .sheet(isPresented: self.$isHistoryPresented){
                    PurchaseProportionPiechart()
              //      PurchaseProportionPiechart(pieChart:pie)
                }
                .navigationTitle("Purchase History")
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
            if histories.count == 0 {
                NoStockView()
                    .offset(y:geometry.size.height/4)
            }
        }
        
    }

}

struct StockHistory_Previews: PreviewProvider {
    static var previews: some View {
        StockHistory()
    }
}


struct NoStockView: View{
    let noCarts = "pet_stat"
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack{
                    Image(noCarts)
                        .resizable()
                        .cornerRadius(40)
             //           .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: geometry.size.height/3)
                        .opacity(0.8)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("No Purchase History" )
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.black)
                                        .foregroundColor(.black)
                                        .padding()
                                        .background(Color.white)
                                        .opacity(0.7)
                                        .cornerRadius(10)
                                    Spacer()
                                }
                                .padding()
                                Spacer()
                            }
                        )
                }
                Spacer()
            }
        }.padding()
    }
}
