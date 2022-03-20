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
//                .overlay(
//                    Image("NavBar-BG")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .position(x:UIScreen.main.bounds.width/2,y:0)
//                )
            
//            NavigationLink(destination: SignUpPage()){
//                    Text("Submit")
//                        .foregroundColor(Color.white)
//                        .frame(width: 140, height: 41, alignment: .center)
//                        .background(Color.darkred)
//                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
//                        .cornerRadius(15)
//                        .padding(.top, 21)
//            }

                VStack{
                    NavigationLink(destination: SignUpPage()){

                HStack{
                    Image(systemName: "house")
                        .font(.system(size: 17, weight: .semibold))
                        .padding(.leading,11)
                    Text("ห้อง 1204 อาคารเรียนรวม ตึกไข่ดาว")
                        .font(Font.custom("SukhumvitSet-SemiBold", size: 15))
                }
                    .foregroundColor(Color.darkest)
                    .frame(width:  UIScreen.main.bounds.width-30, height: 41, alignment: .leading)
                    .background(Color.white)
                    .opacity(0.3)
                    .cornerRadius(9)
                    }
                }
                .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height,alignment: .top)
                .position(x:UIScreen.main.bounds.width/2,y:30)
                

            }.navigationBarBackButtonHidden(true)
        }
    }


struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
