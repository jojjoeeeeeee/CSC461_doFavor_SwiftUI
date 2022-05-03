//
//  HistoryReportRequest.swift
//  doFavor
//
//  Created by Khing Thananut on 4/5/2565 BE.
//

import SwiftUI

struct HistoryReportRequest: View {
    @State var transactionID:String

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
                
                VStack(spacing:0){
                    ReportView( transactionID: transactionID)
                    TabbarView()
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }
        }
    }
}

//struct HistoryReportRequest_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryReportRequest()
//    }
//}

struct ReportView:View{
    @State var email: String = AppUtils.getUsrEmail() ?? ""
    @State var transactionID:String
    @State var detail = ""
    @State var detailPlaceholder: String = "แจ้งให้เราทราบถึงปัญหาของรายการนี้"

    var body: some View{
        VStack{
            ScrollView(){
                Text("แจ้งปัญหาการใช้งาน/ติดต่อแอดมิน")
                    .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                    .padding()
                
                Text("รายการ #\(transactionID ?? "")")

                HStack{
                    Text("อีเมล์ติดต่อ")
                    
                    Text(email)
                        .textContentType(.none)
                        .frame(height: 24)
                        .padding(.horizontal,15)
                        .background(Color.grey.opacity(0.15))
                        .cornerRadius(5)
                }
                
                VStack{
                    Text("รายงานปัญหา")

                    ZStack {
                        if detail.isEmpty {
                            TextEditor(text: $detailPlaceholder)
                                .foregroundColor(Color(UIColor.placeholderText))
                                .frame(height:89,alignment: .topLeading)
                                .disabled(true)
                        }
                        TextEditor(text: $detail)
                            .foregroundColor(.primary)
                            .frame(height:89,alignment: .topLeading)
                            .opacity(detail.isEmpty ? 0.25 : 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                            )
                    }
                }
                
                
            }
            Button(action: {
                AppUtils.eraseAllUsrData()
                                doFavorApp(rootView: .LoginView)
            }){
                Text("รายงาน")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)
            .padding(.bottom)

        }
        .frame(width: UIScreen.main.bounds.width-40)
        .background(Color.white)
        
    }
}