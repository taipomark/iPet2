//
//  ConsumptionHistory.swift
//  iPet
//
//  Created by Mark Lai on 24/9/2021.
//

import SwiftUI

struct PetConsumeHistory: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @FetchRequest(
      entity: ConsumptionHistory.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \ConsumptionHistory.name, ascending: true),
      ]
    ) var histories: FetchedResults<ConsumptionHistory>
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    func group(_ result : FetchedResults<ConsumptionHistory>)-> [[ConsumptionHistory]] {
            
        return Dictionary(grouping: result) { $0.name }
                .sorted(by: {$0.key < $1.key})
                .map {$0.value}
            
    }
    
    private func deleteConsumption(indexSet: IndexSet) {
        for index in indexSet {
            let storeToDelete = histories[index]
            viewContext.delete(storeToDelete)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    

    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                
                List {
                    Text("Consumption History")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                    ForEach(group(histories), id: \.self) { history in
                        Section(header: Text(history[0].name)) {

                            ForEach(history, id: \.self){ realHistory in
                                VStack(alignment: .leading){
                                    //        Text("Item Name: \(realHistory.name)")
                                    //        Spacer()
                                    Text("Consumption Date: ")
                                    Text(realHistory.deductionDate, formatter: Self.taskDateFormat)
                                    Spacer()
                                    Text("Consumption: \(realHistory.deduction)")
                                }
                            }
                            .onDelete { (indexSet) in
                                deleteConsumption(indexSet: indexSet)
                            }

                        }
                        
                    }
                }
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                
            }
            if histories.count == 0 {
                NoConsumptionView()
                    .offset(y:geometry.size.height/8)
            }
        }
    }
}

struct PetConsumeHistory_Previews: PreviewProvider {
    static var previews: some View {
        PetConsumeHistory()
    }
}

struct NoConsumptionView: View{
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
                                    Text("No Consumption History" )
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
