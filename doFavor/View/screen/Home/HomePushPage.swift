//
//  HomePushPage.swift
//  doFavor
//
//  Created by Khing Thananut on 22/3/2565 BE.
//

import SwiftUI

struct HomePushPage: View {
    @Binding var showingSheet: Bool
    @Binding var favor: Bool

    
    var body: some View {
        VStack(spacing: 23){
            HStack{
                Button(action: {
                    showingSheet = false
                })
                {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                        .padding(.top,30)
                }
                
                Spacer()
            }
            if favor{
                Image("Receiver-pic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width-60, height: (UIScreen.main.bounds.width-60)*0.57)
                    .cornerRadius(10)
                    
                Text("บริการฝากซื้อ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 20))

                Text("บริการหาคนรับฝากซื้ออาหาร ของจิปาถะ และเครื่องดื่มตามคำขอ สามารถฝากซื้อได้ทั้งร้านอาหารภายในมหาวิทยาลัยศรีนครินทรวิโรฒหรือโดยรอบ มีระบบแชทให้คุณสามารถติดต่อกับผู้รับฝากได้อย่างสะดวก!")
                    .font(Font.custom("SukhumvitSet-Medium", size: 14))
                    .multilineTextAlignment(.center)
            }else{
                Image("Giver-pic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width-60, height: (UIScreen.main.bounds.width-60)*0.57)
                    .cornerRadius(10)
                    
                    
                Text("บริการรับฝาก")
                    .font(Font.custom("SukhumvitSet-Bold", size: 20))

                Text("บริการรับฝากซื้อตามคำร้องขอของนิสิตหรือเจ้าหน้าที่ภายในมหาวิทยาลัยศรีนครินทรวิโรฒ สามารถรับคำร้องที่มีผู้ร้องขอเข้ามาได้และรับค่าตอบแทนเป็นรางวัล!")
                    .font(Font.custom("SukhumvitSet-Medium", size: 14))
                    .multilineTextAlignment(.center)
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width-60, alignment: .center)
    }
}

struct HomePushPage_Previews: PreviewProvider {
    static var previews: some View {
        HomePushPage(showingSheet: .constant(true), favor: .constant(true))
    }
}
