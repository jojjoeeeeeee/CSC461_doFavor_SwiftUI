//
//  HistoryMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct HistoryMainPage: View {
    var body: some View {
        NavigationView{
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
                    HistoryView()
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)

            }
        }
        .navigationBarHidden(true)
    }
    }
}

struct HistoryMainPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMainPage()
    }
}

struct HistoryView: View{
    
    var body: some View{
        
        VStack(alignment:.leading,spacing:0){
            Text("ประวัติการทำรายการ")
                .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                .padding()

            ScrollView(){
                VStack(alignment:.leading,spacing: 0){
                        transactionHistory()
                    transactionHistory()


                }
                .padding(.horizontal,20)


            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)


    }
}

struct transactionHistory: View{
    
    var body: some View{
        NavigationLink(destination: HistoryDetailPage()){
        HStack{
            VStack{
                Text("ฝากซื้อ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(height: 24)
                    .padding(.horizontal,15)
                    .background(Color.darkred)
                    .cornerRadius(5)
                Text("5 ก.พ. 2021")
                    .font(Font.custom("SukhumvitSet-Bold", size: 9.6).weight(.regular))
                    .foregroundColor(Color.grey)

            }
            VStack(alignment: .leading){
                Text("ร้านป้าต๋อย")
                    .font(Font.custom("SukhumvitSet-Bold", size: 18).weight(.bold))
                Text("หมูปิ้ง 2 ไม้ ข้าวเหนียว 1 ห่อ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.medium))

            }
            Spacer()
            VStack{
                Text("กำลังดำเนินการ")
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                    .foregroundColor(Color.darkred)
                    .frame(height: 24)
                    .padding(.horizontal,15)
                    .background(Color.darkred.opacity(0.15))
                    .cornerRadius(5)

                Button(action: {
                    
                }){
                    Text("รายงานปัญหา")
                        .font(Font.custom("SukhumvitSet-Bold", size: 11).weight(.bold))
                        .underline()
                        .foregroundColor(Color.grey)
                }
            }
        }
        .padding(.vertical,25)
        .foregroundColor(Color.black)
        }
        Divider()
    }
}
