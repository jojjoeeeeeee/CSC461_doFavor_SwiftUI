//
//  HistoryDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI

struct HistoryDetailPage: View {
    
    public var transactionData:TSCTDataModel?
    
    @State var dateData = ""
    @State var statusData = ""
    
    func getDetail() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        let date = dateFormat().stringToDate(date: transactionData?.created ?? "")
        let dateString = dateFormatter.string(from: date)
        dateData = dateString
        
        let status = transactionData?.status ?? ""
        if status == "pending"{
            statusData = ("รอการตอบรับ")
        }
        else if status == "accept" {
            statusData = ("กำลังดำเนินการ")
        }
        else if status == "p_cancel" || status == "a_cancel" {
            statusData = ("ยกเลิก")
        }
        else if status == "success" {
            statusData = ("เสร็จสิ้น")
        }
        else {
            statusData = ("")
        }
        
    }

    
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
                    
                    HistoryDetail(transactionData: transactionData, dateData: $dateData, statusData: $statusData)
                    TabbarView()
                }.onAppear{ getDetail() }
                .edgesIgnoringSafeArea(.bottom)
                
            }
            
            
        }
        .navigationBarHidden(true)
    }
}

//struct HistoryDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryDetailPage()
//    }
//}

struct HistoryDetail: View{
    
    @Environment(\.presentationMode) var presentationMode
    @State var transactionData:TSCTDataModel?
    @Binding var dateData:String
    @Binding var statusData:String
    let userId = AppUtils.getUsrId()

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
                        Text(transactionData?.petitioner?.id == userId ? "ฝากซื้อ":"รับฝาก")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(Color.white)
                            .frame(height: 24)
                            .padding(.horizontal,15)
                            .background(Color.darkred)
                            .cornerRadius(5)
//                        รายการ #A1293B23
                        Text("รายการ #\(transactionData?.id ?? "")")
                            .font(Font.custom("SukhumvitSet-Bold", size: 18).weight(.bold))
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                            .truncationMode(.tail)
                            .foregroundColor(Color.grey)
                        
                        Spacer()
                        
                        Text(dateData)
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.regular))
                            .foregroundColor(Color.grey)
                        
                    }
                    
                    Divider()
                    
                    HStack{
                        Text("สถานะ :")
                            .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                            .foregroundColor(Color.black)
                        
                        Text(statusData)
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(statusData == "รอการตอบรับ" ? Color.darkred : (statusData == "กำลังดำเนินการ" ? Color.darkred : Color.grey))
                            .frame(height: 24)
                            .padding(.horizontal,15)
                            .background(statusData == "รอการตอบรับ" ?  Color.darkred.opacity(0.15) : (statusData == "กำลังดำเนินการ" ? Color.darkred.opacity(0.15) : Color.grey.opacity(0.15)))
                            .cornerRadius(5)
                        
                        Spacer()
                        if statusData != "รอการตอบรับ" {
                            NavigationLink(destination: ChatMainPage(petitioner: transactionData?.petitioner, applicant: transactionData?.applicant, conversation_id: transactionData?.conversation_id ?? "")){
                                Image(systemName: "message")
                                    .font(.system(size: 18, weight: .regular))
                                    .foregroundColor(Color.black)
                            }
                        }

                    }
                    Divider()
                    
                    HStack{
                        VStack(alignment: .leading){
                            Text(transactionData?.title ?? "")
                                .font(Font.custom("SukhumvitSet-Bold", size: 18))
                            HStack{
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.darkred)
                                
                                Text(transactionData?.task_location?.name ?? "")
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
                            Text(transactionData?.detail ?? "")
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
                        
                        Text("\(transactionData?.location?.building ?? "") ชั้น \(transactionData?.location?.floor ?? "") ห้อง \(transactionData?.location?.room ?? "") \(transactionData?.location?.optional ?? "")")
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
