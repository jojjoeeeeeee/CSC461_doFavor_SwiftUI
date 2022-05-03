//
//  PaymentPage.swift
//  doFavor
//
//  Created by Khing Thananut on 4/5/2565 BE.
//

import SwiftUI

struct PaymentPage: View {
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
                    Button(action: {
                        doFavorApp(rootView: .HistoryView)
                    }){
                        Text("จ่ายตังจ้า")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                    }
                    .frame(width:UIScreen.main.bounds.width-40, height: 50)
                    .background(Color.darkred)
                    .cornerRadius(15)
                    .padding(.bottom)
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }
        }
    }
}

struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPage()
    }
}
