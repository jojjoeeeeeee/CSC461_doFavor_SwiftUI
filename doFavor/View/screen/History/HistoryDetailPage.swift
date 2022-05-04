//
//  HistoryDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI

struct HistoryDetailPage: View {
    
    @Binding var transactionData:TSCTDataModel?
    
    @State var dateData = ""
    @State var statusData = ""
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isCancel: Bool = false
    @State var isSuccess: Bool = false
    let userId = AppUtils.getUsrId()
    
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
    
    func fetchCancelTSCT() {
        isLoading.toggle()
        var path = ""
        if transactionData?.petitioner?.id == userId {
            path = Constants.TSCT_CANCEL_PETITIONER
        }
        else if transactionData?.applicant?.id == userId {
            path = Constants.TSCT_CANCEL_APPLICANT
        }
        
        
        TransactionViewModel().cancelTSCT(reqObj: RequestGetTSCTModel(transaction_id: transactionData?.id), type: path){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                transactionData = response
                getDetail()

            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    print(msg)
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                case .NoNetworkError:
                    isAlert = true
                    isNoNetwork.toggle()
                }
            }
        }
    }
    
    func fetchSuccessTSCT() {
        isLoading.toggle()
        
        TransactionViewModel().successTSCT(reqObj: RequestGetTSCTModel(transaction_id: transactionData?.id)){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                transactionData = response
                getDetail()

            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    print(msg)
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                case .NoNetworkError:
                    isAlert = true
                    isNoNetwork.toggle()
                }
            }
        }
    }
    
    
    var body: some View {
        doFavorMainLoadingIndicatorView(isLoading: isLoading) {
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
                        
                        HistoryDetail(transactionData: $transactionData, dateData: $dateData, statusData: $statusData, isAlert: $isAlert, isCancel: $isCancel, isSuccess: $isSuccess)
                        TabbarView()
                    }.onAppear{ getDetail() }
                        .edgesIgnoringSafeArea(.bottom)
                    
                }
                
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            .navigationBarHidden(true)
        }.alert(isPresented:$isAlert) {
            if isExpired {
                return Alert(
                    title: Text("Session Expired"),
                    message: Text("this account is signed-in from another location please sign-in again"),
                    dismissButton: .destructive(Text("Ok")) {
                        AppUtils.eraseAllUsrData()
                        doFavorApp(rootView: .LoginView)
                    }
                )
            }
            else if isNoNetwork {
                return Alert(
                    title: Text("Error"),
                    message: Text("No network connection please try again"),
                    dismissButton: .default(Text("Ok")) {
                        isLoading = false
                        isNoNetwork = false
                    }
                )
            }
            else if isSuccess {
                return Alert(
                    title: Text("กรุณายืนยัน"),
                    message: Text("ท่านต้องการยืนยันรายการรับฝากสำเร็จหรือไม่"),
                    primaryButton: .default(Text("ยืนยัน")) {
                        fetchCancelTSCT()
                        isSuccess = false
                    },
                    secondaryButton: .cancel() {
                        isSuccess = false
                    }
                )
            }
            else {
                return Alert(
                    title: Text("กรุณายืนยัน"),
                    message: Text("ท่านต้องการยกเลิกรายการนี้หรือไม่"),
                    primaryButton: .destructive(Text("ยืนยัน")) {
                        fetchCancelTSCT()
                        isCancel = false
                    },
                    secondaryButton: .cancel() {
                        isCancel = false
                    }
                )
            }
        }
    }
}

//struct HistoryDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryDetailPage()
//    }
//}

struct HistoryDetail: View{
    
    @Environment(\.presentationMode) var presentationMode
    @State var isLinkActive = false
    @Binding var transactionData:TSCTDataModel?
    @Binding var dateData:String
    @Binding var statusData:String
    @Binding var isAlert: Bool
    @Binding var isCancel: Bool
    @Binding var isSuccess: Bool
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
                
                if statusData == "รอการตอบรับ" || statusData == "กำลังดำเนินการ" {
                    Text("ยกเลิก")
                        .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))
                        .foregroundColor(Color.darkred)
                        .underline()
                        .padding(.top,40)
                        .padding(.trailing,20)
                        .padding(.bottom,10)
                        .onTapGesture {
                            isAlert = true
                            isCancel = true
                        }
                }
            }
            
            ScrollView(){
                VStack(alignment: .leading){
                    HStack{
                        Text(transactionData?.petitioner?.id == userId ? "ฝากซื้อ":"รับฝาก")
                            .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                            .foregroundColor(Color.white)
                            .frame(height: 24)
                            .padding(.horizontal,15)
                            .background(transactionData?.petitioner?.id == userId ? Color.darkred:Color.grey)
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
                        
                        NavigationLink(destination: HistoryReportRequest(transactionID: transactionData?.id ?? "")){
                            Text("รายงานปัญหา")
                                .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                                .foregroundColor(Color.grey)
                                .underline()
                        }
                        
                        
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
                        
                        Text("\(transactionData?.location?.building ?? "") ห้อง \(transactionData?.location?.room ?? "") ชั้น \(transactionData?.location?.floor ?? "") \(transactionData?.location?.optional ?? "")")
                            .font(Font.custom("SukhumvitSet-Bold", size: 14))
                            .foregroundColor(Color.darkred)
                            .fontWeight(.bold)
                        
                    }
                }
                .padding(.horizontal,20)
            }
            
            if statusData == "กำลังดำเนินการ" {
                if transactionData?.petitioner?.id == userId {
                    NavigationLink(destination: PaymentPage(), isActive: $isLinkActive){
                        Button(action: {
                            self.isLinkActive = true
                            
                        }){
                            Text("ชำระเงิน")
                                .foregroundColor(Color.white)
                                .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                            
                        }
                        .frame(width:UIScreen.main.bounds.width-40, height: 50)
                        .background(Color.darkred)
                        .cornerRadius(15)
                        .padding(.bottom)
                    }
                } else if transactionData?.applicant?.id == userId {
                    Button(action: {
                        isAlert = true
                        isSuccess = true
                        
                    }){
                        Text("สำเร็จ")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                        
                    }
                    .frame(width:UIScreen.main.bounds.width-40, height: 50)
                    .background(Color.darkred)
                    .cornerRadius(15)
                    .padding(.bottom)
                }
            }
            //            NavigationLink(destination: PaymentPage(), isActive: $isLinkActive){
            //                Button(action: {
            //                    // ยกเลิก/ได้รับของแล้ว
            //                    if (statusData=="กำลังดำเนินการ") {
            //                        self.isLinkActive = true
            //                    }
            //
            //                }){
            //                    Text(statusData=="รอการตอบรับ" ? "ยกเลิก" :  statusData=="กำลังดำเนินการ" ? "ได้รับสิ่งของ" : "")
            //                        .foregroundColor(Color.white)
            //                        .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
            //
            //                }
            //                .frame(width:UIScreen.main.bounds.width-40, height: 50)
            //                .background(statusData=="รอการตอบรับ" ? Color.grey : statusData=="กำลังดำเนินการ" ? Color.darkred : Color.clear)
            //                .cornerRadius(15)
            //                .padding(.bottom)
            //            }
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        
    }
}
