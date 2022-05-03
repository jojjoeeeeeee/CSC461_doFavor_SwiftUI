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
                Image("noname")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width-60, height: (UIScreen.main.bounds.width-60)*0.57)
                    
                    
                Text("บริการฝากซื้อ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 20))

                Text("สไปเดอร์เซ็นเซอร์ฟลุคคอนแทค วอเตอร์ เทคโนแครต อุตสาหการกัมมันตะ แจ๊กพ็อตนายแบบเซรามิกแยมโรล เซลส์แมนรามเทพ อิออน พล็อตทัวริสต์ แดรี่ สคริปต์ สเต็ป ฮาลาลสตรอเบอรีกีวีเดอะ เนิร์สเซอรี่ฟอร์มยูวีต่อยอดบ็อกซ์ พฤหัสตุ๊กตุ๊กมอบตัว เปปเปอร์มินต์ เหมยตรวจทาน")
                    .font(Font.custom("SukhumvitSet-Medium", size: 14))
                    .multilineTextAlignment(.center)
            }else{
                Image("noname")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width-60, height: (UIScreen.main.bounds.width-60)*0.57)
                    
                    
                Text("บริการรับฝาก")
                    .font(Font.custom("SukhumvitSet-Bold", size: 20))

                Text("สไปเดอร์เซ็นเซอร์ฟลุคคอนแทค วอเตอร์ เทคโนแครต อุตสาหการกัมมันตะ แจ๊กพ็อตนายแบบเซรามิกแยมโรล เซลส์แมนรามเทพ อิออน พล็อตทัวริสต์ แดรี่ สคริปต์ สเต็ป ฮาลาลสตรอเบอรีกีวีเดอะ เนิร์สเซอรี่ฟอร์มยูวีต่อยอดบ็อกซ์ พฤหัสตุ๊กตุ๊กมอบตัว เปปเปอร์มินต์ เหมยตรวจทาน")
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
