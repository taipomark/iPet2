//
//  PetStatEdit.swift
//  iPet
//
//  Created by Mark Lai on 25/9/2021.
//

import SwiftUI
import Combine

struct PetStatEdit: View {
    @ObservedObject var pet: Pets
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var petStatCreateViewModel = PetStatCreateViewModel()
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
      entity: PetStat.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \PetStat.petName, ascending: true),
      ]
    ) var history: FetchedResults<PetStat>
    
    private func deleteStat() {
        let count = 0...history.count
        for number in count {
            if number > 20 {
                let statToDelete = history[number]
                viewContext.delete(statToDelete)
                // save the context
                try? viewContext.save()
            }

        }
        
 
    }
 
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Weight in kg")) {
                    HStack {
                        StatFormField(fieldName: "Weight", fieldValue: $petStatCreateViewModel.weight, isSecure: false)
                        Text("KG")
                    }
                }
                Section(header: Text("Height in cm")) {
                    HStack {
                        StatFormField(fieldName: "Height", fieldValue: $petStatCreateViewModel.height, isSecure: false)
                        Text("CM")
                    }
                }
                Section(header: Text("Length in cm")) {
                    HStack {
                        StatFormField(fieldName: "Length", fieldValue: $petStatCreateViewModel.length, isSecure: false)
                        Text("CM")
                    }
                }
                

            }
            .navigationTitle("Add New Pet Stat")
            .navigationBarItems(leading:
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Cancel")
                        .foregroundColor(.black)
                })
                
                , trailing:

                Button(action: {

                
                deleteStat()
                
                    let newStat = PetStat(context: viewContext)
                    newStat.id = UUID()
                    newStat.petName = pet.name
                    newStat.weight = Double(self.petStatCreateViewModel.weight) ?? 0.00
                    newStat.height = Double(self.petStatCreateViewModel.height) ?? 0.00
                    newStat.length = Double(self.petStatCreateViewModel.length) ?? 0.00
                    newStat.measureDate = Date()

                    do {
                        try viewContext.save()
                    }catch{
                                    
                    }
                    presentationMode.wrappedValue.dismiss()
                    
                }, label: {
                    Text("Save")
                        .foregroundColor(.black)
                })
            )
        }
    }
}

/*struct PetStatEdit_Previews: PreviewProvider {
    static var previews: some View {
        PetStatEdit()
    }
}
 */
     

struct StatFormField: View {
    var fieldName = ""
    @Binding var fieldValue: String
    
    var isSecure = false
    
    var body: some View {
        
        VStack {
            if isSecure {
                SecureField(fieldName, text: $fieldValue)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
                
            } else {
                TextField(fieldName, text: $fieldValue)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal)
                    .onReceive(Just(fieldValue)) { newValue in
                                    let filtered = newValue.filter { "0123456789".contains($0) }
                                    if filtered != newValue {
                                        fieldValue = filtered
                                    }
                    }
                
                
            }

            Divider()
                .frame(height: 1)
                .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                .padding(.horizontal)
            
        }
    }
}
