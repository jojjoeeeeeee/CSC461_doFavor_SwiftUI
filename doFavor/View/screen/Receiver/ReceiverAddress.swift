//
//  ReceiverAddress.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI
import MapKit

struct ReceiverAddress: View {
    @State var kwAddress: String = ""

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        GeometryReader{ geometry in
            ZStack{
//        Image("App-BG")
//            .resizable()
//            .aspectRatio(geometry.size, contentMode: .fill)
//            .edgesIgnoringSafeArea(.all)
//        Image("NavBar-BG")
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .position(x:UIScreen.main.bounds.width/2)
                
                VStack(spacing:0){
//                    VStack{
//
//                    }
//                    .frame(height:60)
//                        .background(Color.white)
                    MapView()
                    AddressView()
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)

            }
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading:
                HStack{
                Button(action:{
                self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName:"arrow.left")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(Color.darkest)
                }
                    TextField("ค้นหาที่อยู่...", text: self.$kwAddress)
                    .font(Font.custom("SukhumvitSet-Bold", size: 15))

                }
//                 .background(Color.white)

            )

        }

    }
}

struct AddressView: View{
    @State var lmRoom: String = "" //landmark room
    @State var lmFloor: String = ""
    @State var lmBuilding: String = ""
    @State var addNote: String = ""

    var body: some View{
        VStack(spacing:20){
            HStack{
                Text("ห้อง")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("หมายเลขห้อง..",text: $lmRoom)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )
            }
            HStack{
                Text("อาคาร")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("เลือกอาคาร",text: $lmBuilding)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )
            }
            HStack{
                Text("อื่นๆ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))

                TextField("หมายเหตุ  ระบุตำแหน่งเพิ่มเติม",text: $addNote)
                    .frame(height:36)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                    )
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
        .padding(.top,20)
        .padding(.horizontal,20)
        .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))


    }
}

struct MapView: UIViewRepresentable{
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

struct ReceiverAddress_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverAddress()
    }
}
