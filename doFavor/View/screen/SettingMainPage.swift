//
//  SettingMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct SettingMainPage: View {
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
                    SettingView()
                    TabbarView()

                }
                .edgesIgnoringSafeArea(.bottom)

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
//                    Text("ree")
                    Spacer()
                    Button(action: {
                        AppUtils.eraseAllUsrData()
                                        doFavorApp(rootView: .LoginView)
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
