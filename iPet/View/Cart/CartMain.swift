//
//  CartMain.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import SwiftUI
import CoreData

struct CartMain: View {
    let widthRatio:CGFloat = 0.5
    @Environment(\.presentationMode) var presentationMode

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
      entity: Carts.entity(),
      sortDescriptors: [
        NSSortDescriptor(keyPath: \Carts.item_name, ascending: true),
      ]
    ) var carts: FetchedResults<Carts>
    
    private func deleteCart(indexSet: IndexSet) {
        for index in indexSet {
            let cartToDelete = carts[index]
            viewContext.delete(cartToDelete)
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func removeCart() {
        for cart in carts {
            viewContext.delete(cart)
            do {
                try viewContext.save()
            }catch{
                
            }
        }
        
    }
    

    private func AddStore() {
        
        
        for cart in carts {
            
            let stores = StoreExists(name: cart.item_name)
            if stores.count > 0 {
                let list = stores.first
                list?.volume = cart.volume + list!.volume
                list?.quantity = cart.quantity + list!.quantity
            }
            else{
                let newStore = Stores(context: viewContext)
                newStore.id = UUID()
                newStore.name = cart.item_name
                newStore.quantity = cart.quantity
                newStore.image = cart.image
                newStore.volume = cart.volume
                newStore.volume_type = cart.volume_type
                newStore.type = cart.type
                newStore.category = cart.category
            }

            do {
                try viewContext.save()
            }catch{
                
            }
            
            // Store to History as well
            let history = PurchaseHistory(context: viewContext)
            history.id = UUID()
            history.name = cart.item_name
            history.image = cart.image
            history.quantity = cart.quantity
            history.volume = cart.volume
            history.volume_type = cart.volume_type
            history.type = cart.type
            history.category = cart.category
            history.purchaseDate = Date()
            history.amount = cart.amount
            
            do {
                try viewContext.save()
            }catch{
                
            }
            
        }
    }
    
    
    private func StoreExists(name: String) -> [Stores]  {
        let fetchRequest = NSFetchRequest<Stores>(entityName: "Stores")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)

        var results: [Stores] = []

        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                ZStack {
                    NavigationView {
                        
                        List{

                            ForEach(carts, id: \.self) { cart in
         
                                HStack {
                                    Image(cart.image)
                                        .resizable()
                                        .cornerRadius(20)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: geometry.size.width/3)
                                    Spacer().frame(width:20)
                                    VStack(alignment:.leading) {
                                        Text("Item: \(cart.item_name)")
                                                .contentTextStyle()
                                        Text("Quantity: \(cart.quantity)")
                                            .contentTextStyle()
                                        Text("Amount: $ \(cart.amount, specifier: "%.2f")")
                                            .contentHeadTextStyle()
                                    }
                                }.padding()
                                        
                                }
                                .onDelete { (indexSet) in
                                    deleteCart(indexSet: indexSet)
                                }
                            
                        }
                        .navigationTitle("Carts")
                    }
                    if carts.count == 0 {
                        NoCartView()
                            .offset(y:geometry.size.height/8)
                    }
                }
                
                Button(action: {
                    // Proceed to the next screen
                    AddStore()
                    removeCart()
                    do {
                        try viewContext.save()
                    }catch{
                                     
                    }
                   
                    
                }) {
                    Text("Check out")
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

struct CartMain_Previews: PreviewProvider {
    static var previews: some View {
        CartMain()
    }
}


struct NoCartView: View{
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
                                    Text("No items in the Cart" )
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


