//
//  SignUpVerify.swift
//  doFavor
//
//  Created by Khing Thananut on 22/3/2565 BE.
//

import SwiftUI
import Focuser

struct SignUpVerify: View {
    //    @ObservedObject var limitChar: LimitedCharacter
    //    @State var verifycode: String = ""
    
    @FocusStateLegacy var focusedField: VerifyCodeFormFields?
    
    @State var errMsg: String = "error"
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    @State var isNoNetwork: Bool = false
    
    @AppStorage(Constants.AppConstants.CUR_USR_EMAIL) var email:String = ""
    
    @ObservedObject var vfc1 = TextBindingManager(limit : 1)
    @ObservedObject var vfc2 = TextBindingManager(limit : 1)
    @ObservedObject var vfc3 = TextBindingManager(limit : 1)
    @ObservedObject var vfc4 = TextBindingManager(limit : 1)
    @ObservedObject var vfc5 = TextBindingManager(limit : 1)
    @ObservedObject var vfc6 = TextBindingManager(limit : 1)
    
    
    
    @Environment(\.presentationMode) var presentationMode
    
    private func fetchVerify() {
        var model = RequestOtpModel()
        
        model.email = email
        model.otp = vfc1.text + vfc2.text + vfc3.text + vfc4.text + vfc5.text + vfc6.text
        model.device_id = AppUtils.getDeviceUUIDToken()
        
        print(model)
        
        AuthViewModel().verifyUser(reqObj: model) { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                AppUtils.saveUsrProfile(profile: response.profile_pic ?? "")
                AppUtils.saveUsrUsername(username: response.username ?? "")
                AppUtils.saveUsrEmail(email: response.email ?? "")
                AppUtils.saveUsrName(firstname: response.name?.firstname ?? "", lastname: response.name?.lastname ?? "")
                doFavorApp(rootView: .MainAppView)
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    errMsg = msg
                    isError = true
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                case .NoNetworkError:
                    isNoNetwork.toggle()
                }
            }
        }
    }
    
    private func validateTextfield() {
        
        isError = true
        if vfc1.text.isEmpty || vfc2.text.isEmpty || vfc3.text.isEmpty || vfc4.text.isEmpty || vfc5.text.isEmpty || vfc6.text.isEmpty {
            errMsg = "กรุณากรอกรหัสยืนยันให้ครบ 6 หลัก"
        }
        else {
            isError.toggle()
            isLoading.toggle()
            fetchVerify()
        }
    }
    
    
    var body: some View {
        //        NavigationView{
        doFavorActivityIndicatorView(isLoading: self.isLoading, isPage: true) {
          GeometryReader { geometry in
                  ZStack{
                      Image("App-BG")
                          .resizable()
                          .aspectRatio(contentMode: .fill)
                          .frame(width: UIScreen.main.bounds.width)
                      
                      VStack(alignment: .center, spacing: 30){
                          Text("Verification Code")
                              .font(Font.custom("SukhumvitSet-Bold", size: 20))
                          
                          
                          HStack(alignment: .center, spacing: 5){
                              TextField("",text: $vfc1.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc1.text) { val in
                                      vfc1.text = String(val.suffix(vfc1.characterLimit))
                                      if val != "" {
                                          focusedField = VerifyCodeFormFields.vfc2
                                      }
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc1)
                              TextField("",text: $vfc2.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc2.text) { val in
                                      vfc2.text = String(val.suffix(vfc2.characterLimit))
                                      if val != "" {
                                          focusedField = VerifyCodeFormFields.vfc3
                                      }
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc2)
                              TextField("",text: $vfc3.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc3.text) { val in
                                      vfc3.text = String(val.suffix(vfc3.characterLimit))
                                      if val != "" {
                                          focusedField = VerifyCodeFormFields.vfc4
                                      }
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc3)
                              TextField("",text: $vfc4.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc4.text) { val in
                                      vfc4.text = String(val.suffix(vfc4.characterLimit))
                                      if val != "" {
                                          focusedField = VerifyCodeFormFields.vfc5
                                      }
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc4)
                              TextField("",text: $vfc5.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc5.text) { val in
                                      vfc5.text = String(val.suffix(vfc5.characterLimit))
                                      if val != "" {
                                          focusedField = VerifyCodeFormFields.vfc6
                                      }
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc5)
                              TextField("",text: $vfc6.text)
                                  .textFieldStyle(verifyTF())
                                  .onChange(of: vfc6.text) { val in
                                      vfc6.text = String(val.suffix(vfc6.characterLimit))
                                      validateTextfield()
                                  }
                                  .focusedLegacy($focusedField, equals: .vfc6)
                          }
                          Text(errMsg)
                              .foregroundColor(Color.darkred)
                              .font(Font.custom("SukhumvitSet-Bold", size: 15))
                              .background(Color.clear)
                              .opacity(isError ? 1 : 0)
                          
                          Text(verbatim:"โปรดกรอกรหัสยืนยันที่ได้รับทางอีเมล์ \(email) โปรดตรวจสอบกล่องข้อความ/อีเมลขยะ")
                              .font(Font.custom("SukhumvitSet-Medium", size: 14))
                              .textContentType(.none)
                              .multilineTextAlignment(.center)
                          
                          //                            NavigationLink(destination: {}){
                          //                                    Text("ยืนยัน")
                          //                                        .foregroundColor(Color.white)
                          //                                        .frame(width: 140, height: 41, alignment: .center)
                          //                                        .background(Color.darkred)
                          //                                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                          //                                        .cornerRadius(15)
                          ////                                        .padding(.top, 21)
                          //                            }
                          
//                          Text("ยืนยัน")
//                              .foregroundColor(Color.white)
//                              .frame(width: 140, height: 41, alignment: .center)
//                              .background(Color.darkred)
//                              .font(Font.custom("SukhumvitSet-Bold", size: 15))
//                              .cornerRadius(15)
//                              .onTapGesture { validateTextfield() }
                          //                            Spacer()
                      }
                      .frame(width: UIScreen.main.bounds.width*0.8)
                      
                  }
                  .edgesIgnoringSafeArea(.top)
                  .navigationBarTitle("Sign Up",displayMode: .inline)
                  .navigationBarBackButtonHidden(true)
                  .navigationBarItems(leading:
                                          Button(action:{
                      self.presentationMode.wrappedValue.dismiss()
                  }){
                      HStack{
                          Image(systemName:"arrow.left")
                              .font(.system(size: 20, weight: .regular))
                              .foregroundColor(Color.darkred)
                      }
                      
                  })
              .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
          }.alert(isPresented:$isNoNetwork) {
              Alert(
                  title: Text("Error"),
                  message: Text("No network connection please try again"),
                  dismissButton: .default(Text("Ok")) {
                      isLoading = false
                      isNoNetwork = false
                  }
              )
          }
        }
        //            .background(.red)
        
    }
}

struct verifyTF: TextFieldStyle{
    func _body(configuration: TextField<_Label>) -> some View {
        HStack{
            configuration
            //                .padding()
                .frame(width: UIScreen.main.bounds.width*0.1, height: 57, alignment: .center)
                .font(Font.custom("SukhumvitSet-Bold", size: 20))
                .multilineTextAlignment(.center)
                .textContentType(.oneTimeCode)
                .keyboardType(.numberPad)
        }
        .cornerRadius(7).border(Color.darkred, width: 1)
        .background(Color.darkred.opacity(0.15), alignment: .center)
        
        
    }
    
}

struct SignUpVerify_Previews: PreviewProvider {
    static var previews: some View {
        SignUpVerify()
    }
}
