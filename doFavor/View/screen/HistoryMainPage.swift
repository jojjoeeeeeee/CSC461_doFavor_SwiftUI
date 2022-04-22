//
//  HistoryMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct HistoryMainPage: View {
    @ObservedObject var historyData = HistoryDataObservedModel()
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isRefreshing: Bool = false
    
    //pending,accept,p_cancel,a_cancel,success
    
    @State var dateData = [String]()
    @State var statusData = [String]()
    
    func getDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        for i in 0..<(historyData.history?.count ?? 0) {
            let date = dateFormat().stringToDate(date: historyData.history?[i].created ?? "")
            let dateString = dateFormatter.string(from: date)
            dateData.append(dateString)
        }
    }
    
    func getStatus() {
        for i in 0..<(historyData.history?.count ?? 0) {
            let status = historyData.history?[i].status
            if status == "pending"{
                statusData.append("รอการตอบรับ")
            }
            else if status == "accept" {
                statusData.append("กำลังดำเนินการ")
            }
            else if status == "p_cancel" || status == "a_cancel" {
                statusData.append("ยกเลิก")
            }
            else if status == "success" {
                statusData.append("เสร็จสิ้น")
            }
            else {
                statusData.append("")
            }
        }
    }
    
    func fetchHistoryData() {
        isLoading.toggle()
        
        TransactionViewModel().getHistory() { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
//                print("Success",response)
                historyData.history = response.history
                getDate()
                getStatus()
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
        NavigationView{
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
                            HistoryView(historyData: self.historyData, isLoading: $isLoading, isAlert: $isAlert, isExpired: $isExpired, isNoNetwork: $isNoNetwork, dateData: $dateData, statusData: $statusData, isRefreshing: $isRefreshing)
                            TabbarView()
                        }.onAppear{fetchHistoryData()}
                        .edgesIgnoringSafeArea(.bottom)
                        
                        

                    }
                    .navigationBarHidden(true)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }
                .alert(isPresented:$isAlert) {
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
                    else {
                        return Alert(
                            title: Text("Error"),
                            message: Text("No network connection please try again"),
                            dismissButton: .default(Text("Ok")) {
                                isLoading = false
                                isNoNetwork = false
                            }
                        )
                    }
                }
                
            }
        }
    }
}

struct HistoryMainPage_Previews: PreviewProvider {
    static var previews: some View {
        HistoryMainPage()
    }
}

struct HistoryView: View{
    
    @StateObject public var historyData = HistoryDataObservedModel()
    @Binding var isLoading: Bool
    @Binding var isAlert: Bool
    @Binding var isExpired: Bool
    @Binding var isNoNetwork: Bool
    @Binding var dateData:[String]
    @Binding var statusData:[String]
    @Binding var isRefreshing: Bool
    
    func getDate() {
        dateData.removeAll()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        for i in 0..<(historyData.history?.count ?? 0) {
            let date = dateFormat().stringToDate(date: historyData.history?[i].created ?? "")
            let dateString = dateFormatter.string(from: date)
            dateData.append(dateString)
        }
    }
    
    func getStatus() {
        statusData.removeAll()
        for i in 0..<(historyData.history?.count ?? 0) {
            let status = historyData.history?[i].status
            if status == "pending"{
                statusData.append("รอการตอบรับ")
            }
            else if status == "accept" {
                statusData.append("กำลังดำเนินการ")
            }
            else if status == "p_cancel" || status == "a_cancel" {
                statusData.append("ยกเลิก")
            }
            else if status == "success" {
                statusData.append("เสร็จสิ้น")
            }
            else {
                statusData.append("")
            }
        }
    }
    
    func fetchHistoryData() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        TransactionViewModel().getHistory() { result in
            self.isRefreshing = false
            switch result {
            case .success(let response):
                print("Success",response)
                historyData.history = response.history
                getDate()
                getStatus()
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
    
    
    var body: some View{
        
        VStack(alignment:.leading,spacing:0){
            Text("ประวัติการทำรายการ")
                .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                .padding()

            RefreshableScrollView(isLoading: $isRefreshing,
                                  onRefresh: {
                                    // Update your data and
                                    fetchHistoryData()
                                    
                                  },
                                  content: {
                                    VStack(alignment:.leading,spacing: 0){
                                        
                                        ForEach((0..<(self.historyData.history?.count ?? 0)), id: \.self) { index in
                                            transactionHistory(historyData: self.historyData, isLoading: $isLoading, isAlert: $isAlert, isExpired: $isExpired, isNoNetwork: $isNoNetwork, dateData: $dateData, statusData: $statusData, index: index)
                                        }

                                    }
                                    .padding(.horizontal,20)
                                  })
//            ScrollView(){
//
//
//
//
//            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)


    }
}

struct transactionHistory: View{
    
    @StateObject public var historyData = HistoryDataObservedModel()
    
    @Binding var isLoading: Bool
    @Binding var isAlert: Bool
    @Binding var isExpired: Bool
    @Binding var isNoNetwork: Bool
    @Binding var dateData:[String]
    @Binding var statusData:[String]
    
    @State var data:TSCTDataModel? = nil
    
    @State public var index: Int
    @State private var isActive: Bool = false
    //"5 ก.พ. 2021"
    //กำลังดำเดินการ
   
    func fetchDetail(type : String) {
        isLoading.toggle()
        
        var path = ""
        if type == "ฝากซื้อ" {
            path = Constants.TSCT_GET_PETITIONER
        }
        else if type == "รับฝาก" {
            path = Constants.TSCT_GET_APPLICANT
        }
        
        var model = RequestGetTSCTModel()
        model.transaction_id = historyData.history?[index].id ?? ""
        
        TransactionViewModel().getTSCT(reqObj: model, type: path) { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
//                print("Success",response)
                data = response
                isActive.toggle()
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
    
    var body: some View{
        HStack{
            VStack{
                Text(historyData.history?[index].role ?? "")
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                    .foregroundColor(Color.white)
                    .frame(height: 24)
                    .padding(.horizontal,15)
                    .background(Color.darkred)
                    .cornerRadius(5)
                Text(dateData[index])
                    .font(Font.custom("SukhumvitSet-Bold", size: 9.6).weight(.regular))
                    .foregroundColor(Color.grey)

            }
            VStack(alignment: .leading){
                Text(historyData.history?[index].title ?? "")
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .truncationMode(.tail)
                    .font(Font.custom("SukhumvitSet-Bold", size: 18).weight(.bold))
                Text(historyData.history?[index].detail ?? "")
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .truncationMode(.tail)
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.medium))
            }
            Spacer()
            VStack{
                Text(statusData[index])
                    .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.bold))
                    .foregroundColor(statusData[index] == "รอการตอบรับ" ? Color.darkred : (statusData[index] == "กำลังดำเนินการ" ? Color.darkred : Color.grey))
                    .frame(height: 24)
                    .padding(.horizontal,15)
                    .background(statusData[index] == "รอการตอบรับ" ?  Color.darkred.opacity(0.15) : (statusData[index] == "กำลังดำเนินการ" ? Color.darkred.opacity(0.15) : Color.grey.opacity(0.15)))
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
        .onTapGesture {
            fetchDetail(type: historyData.history?[index].role ?? "")
        }
        
        NavigationLink(destination: HistoryDetailPage(transactionData: data), isActive: $isActive){
            EmptyView()
        }
        Divider()
    }
}
