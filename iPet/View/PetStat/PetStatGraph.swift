//
//  PetStatGraph.swift
//  iPet
//
//  Created by Mark Lai on 25/9/2021.
//

import SwiftUI
import CoreData

enum PetStatDisplayType {
    case All
    case Weight
    case Height
    case Length
}

struct PetStatGraph: View {
    @State private var listType: PetStatDisplayType = .All
    @Environment(\.presentationMode) var presentationMode

    @Environment(\.managedObjectContext) private var viewContext
    var name:String
    @State private var chartWeight:[Double] = []
    @State private var chartHeight:[Double] = []
    @State private var chartLength:[Double] = []
    
    func getStat(name: String) -> [PetStat] {
        let fetchRequest = NSFetchRequest<PetStat>(entityName: "PetStat")
        fetchRequest.predicate = NSPredicate(format: "petName == %@", name)

        var results: [PetStat] = []

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results
    }
    
    private func loadLineChartList() {
 
        chartWeight.removeAll()
        chartHeight.removeAll()
        chartLength.removeAll()
        let allStat = getStat(name:name)
        for number in 0..<allStat.count {
            chartWeight.append(allStat[number].weight)
            chartHeight.append(allStat[number].height)
            chartLength.append(allStat[number].length)
        }
                
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
              .frame(height: 70)
                Text("Pet Stat Trend")
                    .font(.system(size: 30, weight: .black, design: .rounded))
                VStack {

                    HStack(alignment:.top) {
                        Group {
                            Text("All")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .All ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    self.listType = .All
                                }
                            
                            Text("Weight")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .Weight ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    self.listType = .Weight

                                }
                            
                            Text("Height")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .Height ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    self.listType = .Height
                                }
                            Text("Length")
                                .padding(3)
                                .padding(.horizontal, 10)
                                .background(listType == .Length ? Color("PrimaryButton") : Color("SecondaryButton"))
                                .onTapGesture {
                                    self.listType = .Length
                                }
                        }
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        
                        Spacer()
                    }
                    Spacer().frame(height:10)
                    HStack {
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.green)
                                .frame(width: 20, height: 20)
                                Text("Weight")
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.darkYellow)
                                .frame(width: 20, height: 20)
                                Text("Height")
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(Color.darkBlue)
                                .frame(width: 20, height: 20)
                                Text("Length")
                        
                        Spacer()
                    }
                }.padding()
                
                ZStack {
                    LineChart(data: [], title: "", price: "", color: Color.green)
                    switch self.listType{
                    case .All:
                        LineChart(data:chartWeight, title: "", price: "", color: Color.green)
                        LineChart(data:chartHeight, title: "", price: "", color: Color.darkYellow)
                        LineChart(data:chartLength, title: "", price: "", color: Color.darkBlue)
                    case .Weight:
                        LineChart(data:chartWeight, title: "", price: "", color: Color.green)
                    case .Height:
                        LineChart(data:chartHeight, title: "", price: "", color: Color.darkYellow)
                    case .Length:
                        LineChart(data:chartLength, title: "", price: "", color: Color.darkBlue)
                    
                    }

                  
                }.padding()
                
            }.overlay(
                
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
        }.onAppear(perform:loadLineChartList)
    }
}

struct PetStatGraph_Previews: PreviewProvider {
    static var previews: some View {
        PetStatGraph(name:"Kim San")
    }
}
