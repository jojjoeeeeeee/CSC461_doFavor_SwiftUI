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
        NavigationView{
            
        GeometryReader{ geometry in
            ZStack{
                Image("App-BG")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                Image("NavBar-BG")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x:UIScreen.main.bounds.width/2)
                
                VStack(spacing:0){
                    HomeView()
                    TabbarView()
                    
                }            .edgesIgnoringSafeArea(.bottom)
                
            }
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        }

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
                
                addressSegment()
                    .padding(.bottom,UIScreen.main.bounds.width*0.05)
                    .padding(.top, UIScreen.main.bounds.width*0.04)
                VStack(spacing: 0){
                    HStack{
                        Card(image: "", text: "ฝากซื้อ", color: Color.darkred, favor: true)
                        Card(image: "", text: "รับฝาก", color: Color.grey, favor: false)
                        //                        Spacer()
                    }
                    
                }
            }
            
        }
    }
}

struct Card: View{
    var image: String
    var text: String
    var color: Color
    //    var isGive:Bool
    @State var favor:Bool
    @State private var showingSheet = false
    
    var body: some View{
        if #available(iOS 15.0, *) {
            VStack{
                Button(action: {
                    doFavorApp(rootView: favor ? .ReceiverView : .GiverView)
                    
                })
                {
                    if #available(iOS 15.0, *) {
                        Image("TestPic1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .overlay(content: {
                                VStack{
                                    Spacer()
                                    Text(text)
                                        .foregroundColor(Color.white)
                                        .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                                        .frame(width: 92, height: 25)
                                        .background(color)
                                        .cornerRadius(5)
                                        .padding(.bottom,10)
                                    
                                }
                                .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 3.333)
                                .contentShape(Rectangle())
                                .clipped()
                                
                            })
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .frame(width: (UIScreen.main.bounds.width - 30) / 2, height: (UIScreen.main.bounds.width - 30) / 3.333)
                .clipped()
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
                        }
                        .sheet(isPresented: $showingSheet){
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

