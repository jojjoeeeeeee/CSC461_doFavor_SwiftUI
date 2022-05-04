//
//  AboutPage.swift
//  doFavor
//
//  Created by Khing Thananut on 5/5/2565 BE.
//

import SwiftUI

struct AboutPage: View {
    @Environment(\.presentationMode) var presentationMode

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
                    VStack{
                        HStack{
                            Button(action:{
                                self.presentationMode.wrappedValue.dismiss()
                            }){
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                                    .padding(.top,30)
                                    .padding(.leading,20)
                                    .padding(.bottom,10)
                                
                            }
                            Spacer()
                        }

                        Spacer()
                        Image("app-icon-1")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width*0.45, height: UIScreen.main.bounds.width*0.45)
                            .aspectRatio(contentMode: .fit)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                        Text("doFavor")
                            .font(Font.custom("SukhumvitSet-Bold", size: 20))

                        Text("Give&Take Services")
                        
                        Text("Version 1.0.0")
                            .foregroundColor(Color.grey)
                            .padding()

//                        Text("Made by:")
//                            .foregroundColor(Color.grey)

                        
                        

                        Spacer()
                    }
                    .font(Font.custom("SukhumvitSet-Medium", size: 15))
                    .frame(width: UIScreen.main.bounds.width)
                    .background(Color.white)

                    TabbarView()

                }
                .edgesIgnoringSafeArea(.bottom)

            }
        }
        .navigationBarHidden(true)

    }
}

struct AboutPage_Previews: PreviewProvider {
    static var previews: some View {
        AboutPage()
    }
}
