//
//  CustomTextFieldStyles.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI

struct doFavTextFieldStyle: TextFieldStyle{
    var icon: String
    var color: Color
    
    func _body(configuration: TextField<_Label>) -> some View {
        HStack{
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .frame(alignment: .center)
                .foregroundColor(color)
                .offset(x: 14, y: 0)
            configuration
                .padding()
//                .frame(width: 293, height: 41, alignment: .center)
                .frame( height: 41, alignment: .center)

                .font(Font.custom("SukhumvitSet-Bold", size: 15))
        }
            .background(Color.white, alignment: .center)
            .cornerRadius(46)
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
    }
}
