//
//  HomePushPage.swift
//  doFavor
//
//  Created by Khing Thananut on 22/3/2565 BE.
//

import SwiftUI

struct HomePushPage: View {
    @Binding var showingSheet: Bool
    var body: some View {
        VStack{
            HStack{
                Button("close"){self.showingSheet = false}
                Spacer()
            }
            Image("noname")
            Text("บริการฝากซื้อ")
            Text("สไปเดอร์เซ็นเซอร์ฟลุคคอนแทค วอเตอร์ เทคโนแครต อุตสาหการกัมมันตะ แจ๊กพ็อตนายแบบเซรามิกแยมโรล เซลส์แมนรามเทพ อิออน พล็อตทัวริสต์ แดรี่ สคริปต์ สเต็ป ฮาลาลสตรอเบอรีกีวีเดอะ เนิร์สเซอรี่ฟอร์มยูวีต่อยอดบ็อกซ์ พฤหัสตุ๊กตุ๊กมอบตัว เปปเปอร์มินต์ เหมยตรวจทาน")
        }
    }
}

//struct HomePushPage_Previews: PreviewProvider {
//    static var previews: some View {
//        HomePushPage()
//    }
//}
