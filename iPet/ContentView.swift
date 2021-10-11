//
//  ContentView.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext



    var body: some View {
        TabView {
            PetMain().tabItem {
                Image(systemName:"hare.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.black)
                Text("Pet")

            }
            ManageMain().tabItem {
                    Label("Manage", systemImage: "doc.richtext")
            }
            ItemList().tabItem {
                    Label("Item", systemImage: "square.grid.2x2")
            }
            CartMain().tabItem {
                    Label("Cart", systemImage: "cart")
            }
        
                    
        }
        
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
