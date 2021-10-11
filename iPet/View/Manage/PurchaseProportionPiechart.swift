//
//  PurchaseProportionPiechart.swift
//  iPet
//
//  Created by Mark Lai on 26/9/2021.
//

import SwiftUI
import CoreData

enum TransactionDisplayType {
    case All
    case Six
    case Today
}

struct PurchaseProportionPiechart: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @State private var pieChart:[PurchasePieChart] = []
    @State private var CatAmount:Double = 0.00
    @State private var pieStartAngle:Double = 0.00
    @State private var pieEndAngle:Double = 0.00
    @State private var proportion:Double = 0.00
    @State private var pieText:String = ""
    @State private var pieCat:[String] = []
    @State private var catColor = [PieCatColor(category: "Food", color: Color.lightBlue),PieCatColor(category: "Bedding", color: Color.darkOrange),PieCatColor(category: "Snack", color: Color.darkGreen),PieCatColor(category: "Toy", color: Color.darkRed) ]
    @State private var filterDate:Date = Date()
    @State private var listType: TransactionDisplayType = .All
    @State private var isLoading = true
  //  @State var isHistoryPresented:Bool = false

    @FetchRequest(
      entity: PurchaseHistory.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \PurchaseHistory.name, ascending: true),
      ]
    ) var histories: FetchedResults<PurchaseHistory>
    
    func getStat(name: String) -> [PurchaseHistory] {
        let fetchRequest = NSFetchRequest<PurchaseHistory>(entityName: "PurchaseHistory")
        let namePredicate = NSPredicate(
            format: "category == %@", name
        )

        let datePredicate = NSPredicate(
            format: "purchaseDate => %@", filterDate as NSDate
        )
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                namePredicate,
                datePredicate
            ]
        )
   //     fetchRequest.predicate = NSPredicate(format: "category == %@", name)

        var results: [PurchaseHistory] = []

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results
    }
    
    func allStat() -> [PurchaseHistory] {
        let fetchRequest = NSFetchRequest<PurchaseHistory>(entityName: "PurchaseHistory")
        fetchRequest.predicate = NSPredicate(format: "purchaseDate => %@", filterDate as NSDate)
        var results: [PurchaseHistory] = []

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results
    }
    
    private func getSum(histories: FetchedResults<PurchaseHistory>) -> Double {
        
        for pie in histories {
            CatAmount += pie.amount
        }
        return CatAmount
    }
    
    private func getGroupSum(histories: [PurchaseHistory]) -> Double {
        CatAmount = 0.00
        for pie in histories {
            CatAmount += pie.amount
        }
        return CatAmount
    }
    
    func group(_ result : FetchedResults<PurchaseHistory>)-> [[PurchaseHistory]] {
            
        return  Dictionary(grouping: result){ (element : PurchaseHistory)  in
            StockHistory.taskDateFormat.string(from: element.purchaseDate)
        }.values.sorted() { $0[0].purchaseDate > $1[0].purchaseDate }
            
    }
    
    func groupCat(_ result : FetchedResults<PurchaseHistory>)-> [[PurchaseHistory]] {
            
        return Dictionary(grouping: result) { $0.category }
                .sorted(by: {$0.key < $1.key})
                .map {$0.value}
            
    }
    
    private func cal(total:Double, catTotal:Double){

        proportion = (catTotal/total) * 100
        if proportion == 0.00{
            pieText = ""
        }
        else{
            pieText = String(proportion.rounded()) + "%"
        }
        pieStartAngle = pieEndAngle
        pieEndAngle = pieEndAngle + (proportion/100 * 360)
    }
    
    private func setDefaultDate(){
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.year = -1
        filterDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
    }
    
    private func loadPieChartList() {
        
 
        pieChart.removeAll()
        let allStat = allStat()
        let total = getGroupSum(histories:allStat)
        for number in 0..<catColor.count {
            let groupCat = getStat(name:catColor[number].category)
            if groupCat.count > 0 {
                let sumCat = getGroupSum(histories: groupCat)
                cal(total: total, catTotal: sumCat)
                pieChart.append(PurchasePieChart(category: catColor[number].category, amount: sumCat, color: catColor[number].color, start: pieStartAngle, end:pieEndAngle, Proportion: pieText))
            }
            
        }
                
    }
    
    private func loadDefaultPieChartList() {
        
        setDefaultDate()
        pieChart.removeAll()
        let allStat = allStat()
        let total = getGroupSum(histories:allStat)
        for number in 0..<catColor.count {
            let groupCat = getStat(name:catColor[number].category)
            if groupCat.count > 0 {
                let sumCat = getGroupSum(histories: groupCat)
                cal(total: total, catTotal: sumCat)
                pieChart.append(PurchasePieChart(category: catColor[number].category, amount: sumCat, color: catColor[number].color, start: pieStartAngle, end:pieEndAngle, Proportion: pieText))
            }
            
        }
                
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                Spacer()
                .frame(height: 70)
                Text("Expense Proportion")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                VStack {

                    HStack {
                        Group {
                            Text("All")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .All ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    isLoading.toggle()
                                    self.listType = .All
                                    let currentDate = Date()
                                    var dateComponent = DateComponents()
                                     
                                    dateComponent.year = -1
                                    filterDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                                    loadPieChartList()
                                    isLoading.toggle()
                                }
                            
                            Text("Last 6 months")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .Six ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    isLoading.toggle()
                                    self.listType = .Six
                                    let currentDate = Date()
                                    var dateComponent = DateComponents()
                                     
                                    dateComponent.month = -6
                                    filterDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                                    loadPieChartList()
                                    isLoading.toggle()
                                }
                            
                            Text("Today")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .Today ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    isLoading.toggle()
                                    self.listType = .Today
                                    let currentDate = Date()
                                    var dateComponent = DateComponents()
                                     
                                    dateComponent.day = -1
                                    filterDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
                                    loadPieChartList()
                                    isLoading.toggle()
                                }
                        }
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                }
                ZStack{
                    Circle()
                        .stroke(Color(.systemGray6), lineWidth: 40)
                    ForEach(pieChart, id: \.self){pie in
                        PurchaseProportionPie(startAngle: pie.start, endAngle: pie.end, color: pie.color, text: pie.Proportion)

                    }

                }
                .padding()
                Spacer()
                    .frame(height: 80)
                ForEach(pieChart, id: \.self){pie in
                    ProportionRow(color: pie.color, category: pie.category, amount: pie.amount, proportion: pie.Proportion)
       
                }
                
                
            }
            .padding()

        }
        .onAppear(perform: loadDefaultPieChartList)
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

struct PurchaseProportionPiechart_Previews: PreviewProvider {
    static let pie = [PurchasePieChart(category: "Food", amount: 50, color: Color.lightBlue, start: 0, end: 72, Proportion: "20%"),PurchasePieChart(category: "Bedding", amount: 200, color: Color.darkOrange, start: 72, end: 360, Proportion: "80%")]
    
    static var previews: some View {
        PurchaseProportionPiechart()
    }
}

struct ProportionRow: View{
    var color:Color
    var category: String
    var amount: Double
    var proportion: String
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 5.0)
                .fill(color)
            .frame(width: 20, height: 20)
            Text(category)
            Spacer()
            VStack(alignment: .trailing) {
                Text("$ \(amount, specifier: "%.2f")")
                Text(proportion)
                    .foregroundColor(Color.gray)
            }
        }
        
    }
}
