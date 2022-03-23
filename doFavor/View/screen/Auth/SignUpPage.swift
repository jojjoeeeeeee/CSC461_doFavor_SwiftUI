//
//  SignUpPage.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI
import Focuser

struct SignUpPage: View{
    @State var buasri: String = ""
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var CFpassword: String = ""
    @State var onSubmit: Bool = false
    @State var errMsg: String = "error"
    @State var isLoading: Bool = true
    @State var isError: Bool = false
    @FocusStateLegacy var focusedField: SignUpFormFields?
    
    
    @Environment(\.presentationMode) var presentationMode
    
    private func fetchRegister() {
        var model = RequestRegisterUserModel()
        var name = RequestNameModel()

        name.firstname = firstname.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}
        name.lastname = lastname.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}

        model.username = buasri.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}.lowercased()
        model.name = name
        model.email = email.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}.lowercased()
        model.profile_pic = ""
        model.password = password.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}
        model.device_id = AppUtils.getDeviceUUIDToken()

        print(model)
        
        AuthViewModel().registerUser(reqObj: model) { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                AppUtils.saveUsrEmail(email: response.email ?? "")
                onSubmit.toggle()
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    errMsg = msg
                    isError = true
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                }
            }
        }
    }

    private func validateTextfield() {
        
        isError = true
        if buasri.isEmpty {
            errMsg = "buasri id must not be empty."
        }
        else if firstname.isEmpty {
            errMsg = "firstname must not be empty."
        }
        else if firstname.count > 128 {
            errMsg = "firstname must less than 128 characters."
        }
        else if lastname.isEmpty {
            errMsg = "lastname must not be empty."
        }
        else if lastname.count > 128 {
            errMsg = "lastname must less than 128 characters."
        }
        else if email.isEmpty {
            errMsg = "email must not be empty."
        }
        else if !email.matchRegex(for : "^[A-Z0-9a-z._%+-]+@g.swu.ac.th$") {
            errMsg = "please use gswu email."
        }
        else if password.count < 6 || password.count > 32 || CFpassword.count < 6 || CFpassword.count > 32 {
            errMsg = "password must have 6 - 32 characters."
        }
        else if password != CFpassword {
            errMsg = "password does not match."
        }
        else {
            isError.toggle()
            isLoading.toggle()
            fetchRegister()
        }
    }

    var backbtn: some View{
        Button(action: {
        }){
            Image("arrow.left")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color.darkred)
        }
    }
    
    var body: some View{
//        NavigationView{
        doFavorActivityIndicatorView(isLoading: self.isLoading, isPage: true) {
          GeometryReader { geometry in
              ZStack{
                  
                  Image("App-BG")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: UIScreen.main.bounds.width)
                  VStack(alignment: .center, spacing: 12){
                      TextField("Buasri ID",text: $buasri)
                          .textFieldStyle(doFavTextFieldStyle(icon: "person.fill", color: Color.darkred))
                          .focusedLegacy($focusedField, equals: .buasri)
                      HStack(alignment: .center, spacing: 5){
                          TextField("Firstname",text: $firstname)
                              .textFieldStyle(doFavTextFieldStyle(icon: "", color: Color.clear))
                              .focusedLegacy($focusedField, equals: .fname)
  //                        Spacer()
                          TextField("Lastname",text: $lastname)
                              .textFieldStyle(doFavTextFieldStyle(icon: "", color: Color.clear))
                              .focusedLegacy($focusedField, equals: .lname)
                      }
                      
                      TextField("G-SWU E-mail",text: $email)
                          .textFieldStyle(doFavTextFieldStyle(icon: "envelope.fill", color: Color.darkred))
                          .textContentType(.emailAddress)
                          .keyboardType(.emailAddress)
                          .focusedLegacy($focusedField, equals: .email)
                      
                      SecureField("Password",text: $password)
                          .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                          .focusedLegacy($focusedField, equals: .pwd)
                      SecureField("Confirm Password",text: $CFpassword)
                          .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                          .focusedLegacy($focusedField, equals: .cfpwd)
                      
                      Text(errMsg)
                           .foregroundColor(Color.darkred)
                           .font(Font.custom("SukhumvitSet-Bold", size: 15))
                           .background(Color.clear)
                           .opacity(isError ? 1 : 0)

                       Text("Submit")
                           .foregroundColor(Color.white)
                          .frame(width: 140, height: 41, alignment: .center)
                          .background(Color.darkred)
                          .font(Font.custom("SukhumvitSet-Bold", size: 15))
                           .cornerRadius(15)
                           .padding(.top, 21)
                           .onTapGesture { validateTextfield() }
                      NavigationLink(destination: SignUpVerify(),isActive: $onSubmit){
                               EmptyView()
                       }
                      
                      

                      Spacer()
                  }.frame(width: 293)
                      .padding(.top, 130)
                  
  //                    .background(.green)
              }
              .edgesIgnoringSafeArea(.all)
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
              
          }
          
        }

//            .background(.red)

    }
}
