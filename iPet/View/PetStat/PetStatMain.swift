//
//  PetStatMain.swift
//  iPet
//
//  Created by Mark Lai on 23/9/2021.
//

import SwiftUI

struct PetStatMain: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
//    @State var isHistoryPresented:Bool = false
    @FetchRequest(
      entity: Pets.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Pets.name, ascending: true),
      ]
    ) var pets: FetchedResults<Pets>
    
    var body: some View {
        NavigationView {
            List {
                Text("Consumption Stat")
             //   Spacer()
                NavigationLink(destination: PetConsumeHistory()) {
                    HStack {
                        Image(systemName: "doc.plaintext")
                        Text("Pet Consumption")
                        Spacer()
                    }
                    .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                NavigationLink(destination: PetConsumeHistory()) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Pet Consumption Graph")
                        Spacer()
                    }
                    .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                NavigationLink(destination: PurchaseTrend()) {
                    HStack {
                        Image(systemName: "photo")
                        Text("Purchase Trend")
                        Spacer()
                    }
                    .font(.title2)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Text("Pet Stat")
                Spacer()
                ForEach(pets, id: \.self) { pet in
                    NavigationLink(destination: PetStatList(pet: pet)) {
                        HStack {
                        //    Image(systemName: "book")
                            Text(pet.name)
                            Spacer()
                        }
                        .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Pet Stat")
            .navigationBarItems(leading:
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Return")
                        .foregroundColor(.black)
                })
            )
        }
   /*     .overlay(

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
    */
    }
}

struct PetStatMain_Previews: PreviewProvider {
    static var previews: some View {
        PetStatMain()
    }
}
