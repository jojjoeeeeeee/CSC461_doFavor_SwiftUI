//
//  ReceiverRequestPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct ReceiverRequestPage: View {
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
                RequestView(shopName: "").padding(.top,60)
                TabbarView()
            }
            
            
        }
        .navigationBarHidden(true)
    }
}

struct ReceiverRequestPage_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverRequestPage()
    }
}

struct RequestView: View{
    @State public var shopName: String
    
    var body: some View{
        VStack{
            ScrollView(){
                VStack(alignment:.leading, spacing: 10){
                    //back button
                    HStack{
                        Button(action: {
        //                    showingSheet = false
                        })
                        {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                                .padding(.top,30)
                        }
                        
                        Spacer()
                    }
                    
                    //
                    Text("ที่อยู่ของฉัน")
                        .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                    addressSegment().border(Color.darkred)
                    
                    Text("บริการที่ต้องการฝาก")
                        .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                    HStack{
                        Button(action: {
                            
                        })
                        {
                            Text("food")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(Color.darkred)
                                .padding(.horizontal, 21)
                                .frame(height: 33)
                                .background(Color.darkred.opacity(0.15), alignment: .center)
                                .cornerRadius(33)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 33).stroke(Color.darkred, lineWidth: 1)
                                )
                        }

                    }
                    
                    HStack{
                        Text("ชื่อร้าน")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                        TextField("ระบุชื่อร้าน..",text: $shopName)
                            .frame(height:36)
                            .border(Color.darkred.opacity(0.5),width: 2)
                    }

                }
                .padding(.horizontal,20)
//                .frame(width: UIScreen.main.bounds.width-40)
                .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))
            }
            
            //button
            Button(action: {
            }){
                Text("ยืนยัน")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)
            .padding(.bottom)

        }
        .frame(width: UIScreen.main.bounds.width,height: .infinity)
        .background(Color.white)
        .cornerRadius(20)

    }
}


