//
//  HistoryDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI

struct HistoryDetailPage: View {
    
    
    
    var body: some View {
        GeometryReader { geometry in
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
                    
                    HistoryDetail()
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }
            
            
        }
        .navigationBarHidden(true)
    }
}

struct HistoryDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryDetailPage()
    }
}

struct HistoryDetail: View{
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack{
            HStack{
                Button(action:{
                    self.presentationMode.wrappedValue.dismiss()
                }){
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                        .padding(.top,30)
                        .padding(.leading,20)
                        .padding(.bottom,10)
                    
                }
                Spacer()
            }
            
            ScrollView(){
                VStack(alignment: .leading){
                    HStack{
                        Text("ฝากซื้อ")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(Color.white)
                            .frame(height: 24)
                            .padding(.horizontal,15)
                            .background(Color.darkred)
                            .cornerRadius(5)
                        
                        Text("รายการ #A1293B23")
                            .font(Font.custom("SukhumvitSet-Bold", size: 18).weight(.bold))
                            .foregroundColor(Color.grey)
                        
                        Spacer()
                        
                        Text("5 ก.พ. 2021")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.regular))
                            .foregroundColor(Color.grey)
                        
                    }
                    
                    Divider()
                    
                    HStack{
                        Text("สถานะ :")
                            .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                            .foregroundColor(Color.black)
                        
                        Text("กำลังดำเนินการ")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(Color.darkred)
                            .frame(height: 24)
                            .padding(.horizontal,15)
                            .background(Color.darkred.opacity(0.15))
                            .cornerRadius(5)
                        
                        Spacer()
                        
                        Image(systemName: "message")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(Color.black)
                    }
                    Divider()
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text("ร้านป้าต๋อย")
                                .font(Font.custom("SukhumvitSet-Bold", size: 18))
                            HStack{
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.darkred)
                                
                                Text("ประตู 5 อาคารประดู่ไข่ดาว")
                                    .font(Font.custom("SukhumvitSet-Bold", size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkred)
                            }
                            
                        }
                        Spacer()
                        Text("รายงานปัญหา")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(Color.grey)
                            .underline()
                        
                    }
                    
                    //Note
                    HStack(alignment: .top, spacing: 2){
                        VStack(alignment:.leading){
                            Image(systemName: "square.text.square")
                                .font(.system(size: 18, weight: .light))
                                .frame(width: 34, height: 34)
                                .background(Color.white)
                                .cornerRadius(34)
                                .padding(.top,9)
                                .padding(.leading,9)
                            Text("หมูปิ้ง 2 ไม้ ")
                                .font(Font.custom("SukhumvitSet-Bold", size: 13))
                                .fontWeight(.medium)
                                .padding(.horizontal,9)
                                .padding(.bottom,9)
                            Spacer()
                        }

                        Spacer()
                    }
                    .frame(width:UIScreen.main.bounds.width-40)
                    .frame(minHeight: 190)
                    .background(Color.darkred.opacity(0.15))
                    .cornerRadius(15)
                    //Note closure
                    
                    VStack(alignment:.leading){
                        Text("จัดส่งที่ :")
                            .font(Font.custom("SukhumvitSet-Bold", size: 15))
                            .fontWeight(.bold)
                        
                        Text("อาคาร COSCI ชั้น 15 ห้อง 1503")
                            .font(Font.custom("SukhumvitSet-Bold", size: 14))
                            .foregroundColor(Color.darkred)
                            .fontWeight(.bold)

                    }
                }
                .padding(.horizontal,20)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        
    }
}
