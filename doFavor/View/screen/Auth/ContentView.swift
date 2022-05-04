//
//  ContentView.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI
import Focuser

struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var isLinkActive = false
    @State var onSubmit: Bool = false
    
    @State var errMsg: String = "error"
    @State var isLoading: Bool = false
    @State var isError: Bool = false
    @State var isNoNetwork: Bool = false
    
    @FocusStateLegacy var focusedField: SignInFormFields?
    
    private func fetchLogin() {
        var model = RequestLoginUserModel()
        
        model.username = username.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        model.password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        model.device_id = AppUtils.getDeviceUUIDToken()
        
        print(model)
        
        AuthViewModel().loginUser(reqObj: model) { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                AppUtils.saveUsrEmail(email: response.email ?? "")
                if let state = response.state {
                    if state == "none" {
                        onSubmit.toggle()
                    }
                    else if state == "ban" {
                        errMsg = "account has been banned"
                        //go to banned page
                    }
                    else {
                        AppUtils.saveUsrProfile(profile: response.profile_pic ?? "")
                        AppUtils.saveUsrUsername(username: response.username ?? "")
                        AppUtils.saveUsrName(firstname: response.name?.firstname ?? "", lastname: response.name?.lastname ?? "")
                        doFavorApp(rootView: .MainAppView)
                    }
                }
                
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
        //        doFavorApp(rootView: .MainAppView)
        
        isError = true
        if username.isEmpty {
            errMsg = "buasri id must not be empty."
        }
        else if password.isEmpty {
            errMsg = "password must not be empty."
        }
        else {
            isError.toggle()
            isLoading.toggle()
            fetchLogin()
        }
    }
    
    var body: some View {
        NavigationView{
            doFavorActivityIndicatorView(isLoading: self.isLoading, isPage: true) {
                GeometryReader { geometry in
                    
                    Background{
                        ZStack{
                            Image("App-BG")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width)
                            
                            //            ScrollView(.vertical, showsIndicators: false, content: {
                            VStack(alignment: .center, spacing: 12){
                                // App Logo Image
                                Image("app-icon-2")
                                    .resizable()
                                    .frame(width: 190, height: 190)
                                    .clipShape(Circle())
                                    .aspectRatio(contentMode: .fit)
                                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
                                //                        .padding(.bottom, 12)
                                
                                //  Text Fields
                                TextField("Buasri ID",text: $username)
                                    .textFieldStyle(doFavTextFieldStyle(icon: "person.fill",color: Color.darkred))
                                    .frame(width: 293)
                                    .focusedLegacy($focusedField, equals: .buasri)
                                SecureField("Password",text: $password)
                                    .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill",color: Color.grey))
                                    .frame(width: 293)
                                    .padding(.bottom, 12)
                                    .focusedLegacy($focusedField, equals: .pwd)
                                
                                Text(errMsg)
                                    .foregroundColor(Color.darkred)
                                    .font(Font.custom("SukhumvitSet-Bold", size: 15))
                                    .background(Color.clear)
                                    .opacity(isError ? 1 : 0)
                                
                                // Buttons
                                
                                Text("Sign in")
                                    .foregroundColor(.white)
                                    .frame(width: 140, height: 41, alignment: .center)
                                    .background(Color.darkred)
                                    .font(Font.custom("SukhumvitSet-Bold", size: 15))
                                    .cornerRadius(15)
                                    .onTapGesture { validateTextfield()}
                                
                                NavigationLink(destination: SignUpPage()){
                                    Text("Sign up")
                                        .foregroundColor(Color.darkred)
                                        .frame(width: 140, height: 41, alignment: .center)
                                        .background(Color.clear)
                                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.darkred, lineWidth: 2))
                                }
                                
                                NavigationLink(destination: SignUpVerify(),isActive: $onSubmit){
                                    EmptyView()
                                }
                                
                            }
                            //                .frame(width: UIScreen.main.bounds.width*0.8)
                            
                            
                            
                            //            }).background(.red)
                            
                        }
                    }.onTapGesture {
                        UIApplication.shared.endEditing()
                    }
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
                
            }// blur closure
            .edgesIgnoringSafeArea(.all)
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
