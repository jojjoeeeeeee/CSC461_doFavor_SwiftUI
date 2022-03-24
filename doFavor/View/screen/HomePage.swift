//
//  HomePage.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI
import RealmSwift

struct HomePage: View {
    
    var body: some View {
        
        ZStack{
            Image("App-BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
                .overlay(
                    Image("NavBar-BG")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .edgesIgnoringSafeArea(.bottom)
                        .position(x:UIScreen.main.bounds.width/2,y:60)
                )
            VStack{
                HomeView()
                TabbarView()
            }
        }
        .navigationBarHidden(true)
        
    } //body closure
    
} //HomePage closure

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

struct HomeView: View{
    //    @State var showingSheet = false
    //    @State var favor = true
    
    var body: some View{
        VStack{
            
            ScrollView(){
                addressSegment().padding(.top,60)
                VStack(spacing: 0){
                    HStack{
                        Card(image: "", text: "ฝากซื้อ", color: Color.darkred, favor: true)
                        Card(image: "", text: "รับฝาก", color: Color.grey, favor: false)
                        //                        Spacer()
                    }
                    
                }
                .padding()
            }
        }
    }
}

struct Card: View{
    var image: String
    var text: String
    var color: Color
    @State var favor:Bool
    @State private var showingSheet = false
    
    var body: some View{
        if #available(iOS 15.0, *) {
            VStack{
                Button(action: {
                    doFavorApp(rootView: .GiverView)
                }){
                    
                    if #available(iOS 15.0, *) {
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(content: {
                                VStack{
                                    Spacer()
                                    Text(text)
                                        .foregroundColor(Color.white)
                                    //                            .font(Font.)
                                        .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                                        .frame(width: 92, height: 25)
                                        .background(color)
                                        .cornerRadius(5)
                                        .padding(.bottom,10)
                                    
                                }
                                .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 3.333)
                                
                            })
                    } else {
                        // Fallback on earlier versions
                    }
                }.clipped()
                //== ขาดแก้ไม่ให้คลิกตรง shadow ได้ == edit in needed
                
            }
            .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 3.333)
            .background(Color.white)
            .clipped()
            .cornerRadius(10)
            .overlay(content: {
                VStack{
                    HStack{
                        Spacer()
                        
                        
                        Button(action: {
                            showingSheet.toggle()
                        })
                        {
                            Image(systemName: "info.circle")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.darkred)
                                .frame(alignment: .trailing)
                                .padding(10)
                        }.sheet(isPresented: $showingSheet){
                            HomePushPage(showingSheet: $showingSheet, favor: $favor)
                        }
                        
                    }
                    Spacer()
                }
            })
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        } else {
            // Fallback on earlier versions
        }
    }
    
}

