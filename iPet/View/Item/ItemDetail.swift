//
//  ItemDetail.swift
//  iPet
//
//  Created by Mark Lai on 18/9/2021.
//

import SwiftUI
import CoreData

struct ItemDetail: View {
    var item:Items
    @Environment(\.presentationMode) var presentationMode
    @State private var maxPurchase = 0
    @State private var item_name = ""
    @Environment(\.managedObjectContext) private var viewContext
    
    private func CartsExists(name: String) -> [Carts] {
        let fetchRequest = NSFetchRequest<Carts>(entityName: "Carts")
        fetchRequest.predicate = NSPredicate(format: "item_name == %@", name)

        var results = [Carts]()

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        


        return results
    }
    
    var body: some View {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.black)
                        .foregroundColor(.black)
                    Image(item.image)
                        .resizable()
                        .cornerRadius(20)
                        .aspectRatio(contentMode: .fit)
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Item Type: \(item.type)")
                            .contentHeadTextStyle()
                        Text("Item Category: \(item.category)")
                            .contentHeadTextStyle()
                        Text("Volume: \(item.volume) \(item.volumeType)")
                            .contentHeadTextStyle()
                        Text("Amount: $ \(item.amount, specifier: "%.2f")")
                            .contentHeadTextStyle()
                        Text("Description:")
                            .contentHeadTextStyle()
                        Text(item.description)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.black)
                    }
                    
                   //Spacer()
                    Stepper(onIncrement: {
                        self.maxPurchase += 1
                        
                        if self.maxPurchase > 10 {
                            self.maxPurchase = 10
                        }
                    }, onDecrement: {
                        self.maxPurchase -= 1
                        
                        if self.maxPurchase < 0 {
                            self.maxPurchase = 0
                        }
                    }) {
                        Text("Add \(String(maxPurchase)) items")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.black)
                    }
                    .padding()
                    
                    Button(action: {
                        if maxPurchase > 0 {
                            let carts = CartsExists(name: item.name)
                            if carts.count > 0 {
                                let list = carts.first
                                list?.volume = item.volume + list!.volume
                                list?.quantity = maxPurchase + list!.quantity
                                list?.amount = (item.amount * Double(maxPurchase)) + list!.amount
                            }
                            else{
                                let newCart = Carts(context: viewContext)
                                newCart.id = UUID()
                                newCart.item_name = item.name
                                newCart.quantity = maxPurchase
                                newCart.image = item.image
                                newCart.volume = item.volume
                                newCart.volume_type = item.volumeType
                                newCart.type = item.type
                                newCart.category = item.category
                                newCart.amount = Double(maxPurchase) * item.amount
                            }
                            
                            
                            do {
                                try viewContext.save()
                            }catch{
                                             
                            }
                            presentationMode.wrappedValue.dismiss()
                            maxPurchase = 0
                        }
                        // Proceed to the next screen
                    }) {
                        Text("Add to Cart")
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(.white)
                            .bold()
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 251/255, green: 128/255, blue: 128/255), Color(red: 253/255, green: 193/255, blue: 104/255)]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            
                    }
                }.padding()
            }
        }
}

struct ItemDetail_Previews: PreviewProvider {
    static let item = Items(name: "Momi Grass (M)", image: "momi_m", type: "Rabbit", volume: 500, volumeType: "gram", description: "Grass for Rabbit", category: "Food", amount: 55)
    
    static var previews: some View {
        ItemDetail(item:item)
    }
}
