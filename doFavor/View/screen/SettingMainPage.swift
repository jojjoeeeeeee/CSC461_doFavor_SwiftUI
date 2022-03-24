//
//  SettingMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct SettingMainPage: View {
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
            VStack(spacing:0){
                SettingView().padding(.top,60)
                TabbarView()
            }
            
            
        }
        .navigationBarHidden(true)
    }
}

struct SettingMainPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingMainPage()
    }
}

struct SettingView: View{
    var body: some View{
        VStack{
            ScrollView(){
                VStack{
                    Spacer()
                    Button(action: {
                        //
                    }){
                        Text("ออกจากระบบ")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

                    }
                    .frame(width:UIScreen.main.bounds.width-40, height: 50)
                    .background(Color.grey)
                    .cornerRadius(15)
                    .padding(.bottom)

                }
            }

        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
//        .cornerRadius(20)

    }
}
