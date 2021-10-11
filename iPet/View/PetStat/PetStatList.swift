//
//  PetStatList.swift
//  iPet
//
//  Created by Mark Lai on 25/9/2021.
//

import SwiftUI
import CoreData

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct PetStatList: View {
    @ObservedObject var pet: Pets
    @State var activeSheet: ActiveSheet?
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showNewStat = false
    @State private var showGrapgh = false
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
    
    private func deleteStat(indexSet: IndexSet, stat: [PetStat]) {
        for index in indexSet {
            let statToDelete = stat[index]
            viewContext.delete(statToDelete)
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
        VStack{
            StatHeader(showNewStat: $showNewStat, showGrapgh:$showGrapgh, activeSheet:$activeSheet)
  //          PetStatGraph(name:pet.name)
            List{
                let stats = getStat(name: pet.name)
                ForEach(stats, id: \.self){stat in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Measure Date: ")
                            Text(stat.measureDate, formatter: Self.taskDateFormat)
                        }
                        Spacer()
                        Text("Weight: \(stat.weight, specifier: "%.2f") kg")
                        Spacer()
                        Text("Length: \(stat.length, specifier: "%.2f") cm")
                        Spacer()
                        Text("Height: \(stat.height, specifier: "%.2f") cm")

                    }
                    
                }
                .onDelete { (indexSet) in
                    deleteStat(indexSet: indexSet, stat:stats)
                }
                
            }
 //           .navigationBarItems(leading:
 //               StatHeader(showNewStat: $showNewStat))
            .sheet(item: $activeSheet) { item in
                        switch item {
                        case .first:
                            PetStatGraph(name:pet.name)
                        case .second:
                            PetStatEdit(pet:pet)
                        }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

/*struct PetStatList_Previews: PreviewProvider {

    static var previews: some View {
        PetStatList(pet: pet)
    }

}*/

struct StatHeader: View{
    @Binding var showNewStat:Bool
    @Binding var showGrapgh:Bool
    @Binding var activeSheet: ActiveSheet?

    var body: some View{
            
        VStack {
            HStack {
                Text("Your Pets Stat")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                        
                Spacer(minLength: 100)
                Image(systemName: "photo.fill")
                    .font(.largeTitle)
                    .foregroundColor(.lightBlue)
                    .onTapGesture {
                        self.activeSheet = .first
                    }
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.lightBlue)
                    .onTapGesture {
                        self.activeSheet = .second
                    }

            }
            .padding()
        }
    }
}
