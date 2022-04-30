//
//  addressSegment.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct addressSegment: View{
    
    @State var address: userLocationDataModel?
    @State var addressStr: String = ""
    
    var body: some View{
        NavigationLink(destination: ReceiverAddress()){
            
            HStack{
                Image(systemName: "house")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.leading,11)
                Text(addressStr)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .truncationMode(.tail)
                    .font(Font.custom("SukhumvitSet-SemiBold", size: 15))
                
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .foregroundColor(Color.darkest)
            .frame(width:  UIScreen.main.bounds.width-30, height: 41, alignment: .leading)
            .background(Color.white.opacity(0.3))
            .cornerRadius(9)
            .onAppear{
                address = AppUtils.getUsrAddress()
                if address != nil {
                    let room = !(address?.room?.isEmpty ?? true) ? "ห้อง \(address?.room ?? "")" : ""
                    let floor = !(address?.floor?.isEmpty ?? true) ? "ชั้น \(address?.floor ?? "") ": ""
                    let building = address?.building ?? ""
                    addressStr = "\(room) \(floor)\(building)"
                } else {
                    addressStr = "กรุณาใส่ที่อยู่ปัจจุบัน"
                }
            }
        }
        //        .padding(.top, 20)
        //        .background(.red)
    }
}

struct addressSegment_Previews: PreviewProvider {
    static var previews: some View {
        addressSegment()
    }
}
