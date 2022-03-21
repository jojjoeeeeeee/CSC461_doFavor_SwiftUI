//
//  HomePage.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI

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
                HomeContent()
        }.onAppear(perform: {
//            print(UIFont.famil)

        })
//            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .navigationTitle("")
//        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)

        } //body closure

    } //HomePage closure

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

struct addressSegment: View{
    var body: some View{
        NavigationLink(destination: SignUpPage()){

        HStack{
            Image(systemName: "house")
                .font(.system(size: 17, weight: .semibold))
                .padding(.leading,11)
            Text("ห้อง 1204 อาคารเรียนรวม ตึกไข่ดาว")
                .font(Font.custom("SukhumvitSet-SemiBold", size: 15))
        }
        .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.bottom)
            .foregroundColor(Color.darkest)
            .frame(width:  UIScreen.main.bounds.width-30, height: 41, alignment: .leading)
            .background(Color.white.opacity(0.3))
            .cornerRadius(9)
        }
//        .padding(.top, 20)
//        .background(.red)
    }
}

struct HomeContent: View {
    
    var body: some View{
        VStack(spacing: 0){
            HomeView()
            TabBar()
        }
//        .background(Color.black.opacity(0.06).edgesIgnoringSafeArea(.top))
//        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView: View{
    var body: some View{
        VStack{
            
            ScrollView(){
                addressSegment().padding(.top,60)
                VStack(spacing: 0){
                    HStack{
                        Card(image: "", text: "ฝากซื้อ", color: Color.darkred)
                        Card(image: "", text: "รับฝาก", color: Color.grey)
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

    var body: some View{
        if #available(iOS 15.0, *) {
            VStack{
                NavigationLink(destination: {}){
                    
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
                            print("info press")
                        }){
                            Image(systemName: "info.circle")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.darkred)
                                .frame(alignment: .trailing)
                                .padding(10)
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

struct TabBar: View {
    
    var body: some View{
        HStack{
            Spacer(minLength: 2)
            Button(action: {
                
            }){
                VStack{
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
            }
            
            Spacer(minLength: 2)
            Button(action: {
                
            }){
                VStack{
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
            }

            Spacer(minLength: 2)
            Button(action: {
                
            }){
                VStack{
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
            }
            Spacer(minLength: 2)
        }
        .padding(.horizontal, 35)
        .padding(.top, 12)
        .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 15)
        .background(Color.white.opacity(0.5))
//        .shadow(color: Color.black.opacity(0.04), radius: 0, x: 0, y: -6)

    }
}
