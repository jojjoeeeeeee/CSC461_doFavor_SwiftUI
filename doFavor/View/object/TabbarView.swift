//
//  TabbarView.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct TabbarView: View {
    var body: some View{
        HStack(){
//            Spacer(minLength: 2)
            Button(action: {
                doFavorApp(rootView: .HistoryView)
            }){
                VStack{
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
                .frame(width: UIScreen.main.bounds.width/3.5)
            }
            
//            Spacer(minLength: 2)
            Button(action: {
                doFavorApp(rootView: .MainAppView)
            }){
                VStack{
                    Image(systemName: "house")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
                .frame(width: UIScreen.main.bounds.width/3.5)
            }

            Button(action: {
                doFavorApp(rootView: .SettingView)
            }){
                VStack{
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(Color.darkest)
                }
                 .frame(width: UIScreen.main.bounds.width/3.5)
            }
//            Spacer(minLength: 2)
        }
        .frame(width: UIScreen.main.bounds.width, alignment: .center)
//        .padding(.horizontal, 35)
        .padding(.top, 12)
        .padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom)! + 15)
        .background(Color.white.opacity(0.5))
        //        .shadow(color: Color.black.opacity(0.04), radius: 0, x: 0, y: -6)
        
    }}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
