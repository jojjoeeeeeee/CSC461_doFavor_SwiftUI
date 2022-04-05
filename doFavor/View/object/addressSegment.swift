//
//  addressSegment.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct addressSegment: View{
    var body: some View{
        NavigationLink(destination: ReceiverAddress()){
            
            HStack{
                Image(systemName: "house")
                    .font(.system(size: 17, weight: .semibold))
                    .padding(.leading,11)
                Text("ห้อง 1204 อาคารเรียนรวม ตึกไข่ดาว")
                    .font(Font.custom("SukhumvitSet-SemiBold", size: 15))
            }
            .edgesIgnoringSafeArea(.top)
            .edgesIgnoringSafeArea(.bottom)
            .foregroundColor(Color.darkest)
            .frame(width:  UIScreen.main.bounds.width-30, height: 41, alignment: .leading)
            .background(Color.white.opacity(0.3))
            .cornerRadius(9)
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
