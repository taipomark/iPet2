//
//  ManageMain.swift
//  iPet
//
//  Created by Mark Lai on 12/9/2021.
//

import SwiftUI

struct ManageMain: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var isStockPresented:Bool = false
    @State var isStatPresented:Bool = false
    
    var body: some View {
        VStack {
            Text("Manage")
                .font(.system(size: 40, weight: .black, design: .rounded))
            ManageList(title: "Stock List", titleImage: "stock_list")
                .onTapGesture {
                    self.isStockPresented.toggle()
                }
            ManageList(title: "Your Pet Stat", titleImage: "pet_stat")
                .onTapGesture {
                    self.isStatPresented.toggle()
                }
        }
        .fullScreenCover(isPresented: self.$isStockPresented){
            StockList()
        }
        .sheet(isPresented: self.$isStatPresented){
            PetStatMain()
        }
        
    }
}

struct ManageMain_Previews: PreviewProvider {
    static var previews: some View {
        ManageMain()
    }
}

struct ManageList: View{
    var title:String
    var titleImage:String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack{
                    Image(titleImage)
                        .resizable()
                        .cornerRadius(40)
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width*9/10)
             //           .opacity(0.8)
                        .overlay(
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(title)
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
