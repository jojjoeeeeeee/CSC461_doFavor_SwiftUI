//
//  GiverMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct GiverMainPage: View {
    
    var body: some View {
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
                    addressSegment()
                    GiverView()
                    TabbarView()

                }            .edgesIgnoringSafeArea(.bottom)

            }
        }
        .navigationBarHidden(true)
    }
}

struct GiverMainPage_Previews: PreviewProvider {
    static var previews: some View {
        GiverMainPage()
    }
}

struct GiverView: View{
    @State private var showingSheet = false

    var body: some View{
        VStack{
            ScrollView(){
                VStack(spacing: 0){
                    searchSegment()
                    giverListCard(category: "", shopName: "", landMark: "", distance: "", note: "")
                        .onTapGesture {
                            showingSheet.toggle()
                        }
                        .sheet(isPresented: $showingSheet){
                            GiverDetailPage(showingSheet: $showingSheet)
                        }
                    
                    
                }                .frame(width:  UIScreen.main.bounds.width-30)

                .padding()
            }
        }
    }
}

struct searchSegment: View{
    @State public var search: String = ""
    @State var isPresented:Bool = false


    var body: some View{
        HStack{
            TextField("กำลังหาอะไรอยู่...",text: $search)
                .textFieldStyle(doFavTextFieldStyle(icon: "magnifyingglass", color: Color.darkest))
            Button(action: {
                isPresented.toggle()
            })
            {
                Image(systemName: "slider.vertical.3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.darkest)
                    .frame(width: 41, height: 41)
                    .background(Color.white, alignment: .center)
                    .cornerRadius(46)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }
            .halfSheet(isPresented: $isPresented) {
                ZStack{
                    VStack{
                        Text("Hi Filter")

                        Button{
                            isPresented.toggle()
                        }label: {
                            Text("Close")
                        }
                    }
                }
                    
            } onEnd:{
                isPresented.toggle()
            }

        }
    }
}

struct giverListCard: View{
    var category: String
    var shopName: String
    var landMark: String
    var distance: String
    var note: String
    
    var body: some View{
        HStack(){
            Image("TestPic1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width*0.255, height:UIScreen.main.bounds.width*0.255)
                .clipped()
                .padding(.vertical,12)
                .padding(.leading,12)

            VStack(alignment:.leading,spacing: 0){
                    Text("food")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundColor(Color.darkred)
                        .padding(.horizontal, 11)
                        .frame(height: 15)
                        .background(Color.darkred.opacity(0.15), alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20).stroke(Color.darkred, lineWidth: 1)
                        )
                
                Text("ร้านป้าต๋อย")
                
                Text("ประตู 5  |  3 km")
                    .font(Font.custom("SukhumvitSet-Bold", size: 10))
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing:2){
                    Image(systemName: "square.text.square")
                        .font(.system(size: 18, weight: .light))
                    Text("หมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อหมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อ")
                        .font(Font.custom("SukhumvitSet-Bold", size: 10))
                        .fontWeight(.medium)
                }

            }
            .padding(.vertical,12)
            .padding(.trailing,12)

            Spacer()
        }
        .foregroundColor(Color.darkest)
        .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
        .frame(width:UIScreen.main.bounds.width-30 ,height: UIScreen.main.bounds.width*0.3)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(12)
        
    }
}

