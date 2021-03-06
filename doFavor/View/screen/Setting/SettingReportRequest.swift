//
//  SettingReportRequest.swift
//  doFavor
//
//  Created by Khing Thananut on 4/5/2565 BE.
//

import SwiftUI

struct SettingReportRequest: View {
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    
    var body: some View {
        doFavorMainLoadingIndicatorView(isLoading: isLoading) {
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
                        ReportRequestView(isLoading: $isLoading, isAlert: $isAlert, isExpired: $isExpired, isNoNetwork: $isNoNetwork)
                        TabbarView()
                        
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    
                }
            }.navigationBarHidden(true)
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

struct SettingReportRequest_Previews: PreviewProvider {
    static var previews: some View {
        SettingReportRequest()
    }
}

struct ReportRequestView:View{
    
    @Environment(\.presentationMode) var presentationMode
    @State var email: String = AppUtils.getUsrEmail() ?? ""
    @State var detail = ""
    @State var detailPlaceholder: String = "??????????????????????????????????????????????????????????????????????????????????????????????????????????????? ???????????????????????????????????????????????????????????????????????????????????????"
    @State var errMsg = ""
    @State var isError: Bool = false
    @Binding var isLoading: Bool
    @Binding var isAlert: Bool
    @Binding var isExpired: Bool
    @Binding var isNoNetwork: Bool
    
    private func validateData() {
        
        isError = true
        
        if detail.isEmpty {
            errMsg = "?????????????????????????????????????????????????????????????????????????????????"
        } else {
            isError.toggle()
            fetchReportUser()
        }
    }
    
    func fetchReportUser() {
        isLoading.toggle()
        
        UserViewModel().report(reqObj: RequestReportModel(email: email, detail: detail)){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                self.presentationMode.wrappedValue.dismiss()
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
            
            Text("??????????????????????????????????????????????????????/????????????????????????????????????")
                    .font(Font.custom("SukhumvitSet-Bold", size: UIScreen.main.bounds.width*0.054).weight(.bold))
                .padding()

            
            ScrollView(){
                VStack(alignment: .leading){
                HStack{
                    Text("????????????????????????????????????")
                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                        .foregroundColor(Color.grey)

                    
                    Text(email)
                        .font(Font.custom("SukhumvitSet-Medium", size: 12))
                        .foregroundColor(Color.grey)
                        .textContentType(.none)
                        .frame(height: 24)
                        .padding(.horizontal,15)
                        .background(Color.grey.opacity(0.15))
                        .cornerRadius(5)
                }
                
                    VStack(alignment: .leading, spacing: 0){
                    Text("?????????????????????????????????")
                        .font(Font.custom("SukhumvitSet-Bold", size: 17))

                    ZStack {
                        if detail.isEmpty {
                            TextEditor(text: $detailPlaceholder)
                                .foregroundColor(Color(UIColor.placeholderText))
                                .frame(height:UIScreen.main.bounds.width*0.8,alignment: .topLeading)
                                .disabled(true)
                                .padding()
                        }
                        TextEditor(text: $detail)
                            .font(Font.custom("SukhumvitSet-Bold", size: 15))
                            .foregroundColor(.primary)
                            .frame(height:UIScreen.main.bounds.width*0.8,alignment: .topLeading)
                            .opacity(detail.isEmpty ? 0.25 : 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                            )
                            .padding(2)
                    }
                }
                
                Text(errMsg)
                    .foregroundColor(Color.darkred)
                    .font(Font.custom("SukhumvitSet-Bold", size: 15))
                    .background(Color.clear)
                    .opacity(isError ? 1 : 0)
            }
            }
            .frame(width:UIScreen.main.bounds.width-40)


            Button(action: {
                validateData()
            }){
                Text("??????????????????")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)
            .padding(.bottom)

        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        
    }
}
