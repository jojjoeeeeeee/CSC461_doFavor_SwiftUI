//
//  ReceiverAddress.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct ReceiverAddress: View {
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
            }
            VStack{
                
            }            .edgesIgnoringSafeArea(.bottom)

        }

    }
}

struct ReceiverAddress_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverAddress()
    }
}
