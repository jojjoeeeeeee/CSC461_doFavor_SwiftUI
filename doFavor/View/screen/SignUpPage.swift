//
//  SignUpPage.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI


struct SignUpPage: View{
    @State var buasri: String = ""
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var CFpassword: String = ""
    @State var onSubmit: Bool = false
    @State var errMsg: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    private func fetchRegister() {
        var model = RequestUserModel()
        var name = RequestNameModel()
        
        name.firstname = firstname
        name.lastname = lastname
        
        model.username = buasri
        model.name = name
        model.email = email
        model.profile_pic = ""
        model.password = password
        model.device_id = AppUtils.getDeviceUUIDToken()
        
        print(model)
        SignUpViewModel().registerUser(reqObj: model) { result in
            switch result {
            case .success(let response):
                print("Success",response)
                //navigate
                onSubmit.toggle()
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    errMsg = msg
                case .Non200StatusCodeError(let val):
                    print("Error Code: \(val.status) - \(val.message)")
                case .UnParsableError:
                    print("Error \(error)")
                }
            }
        }
    }
    
    private func validateTextfield() {
        if buasri == "" {
            errMsg = "buasri id must not be empty."
        }
        else if firstname == "" {
            errMsg = "firstname must not be empty."
        }
        else if firstname.count > 128 {
            errMsg = "firstname must less than 128 characters."
        }
        else if lastname == "" {
            errMsg = "lastname must not be empty."
        }
        else if lastname.count > 128 {
            errMsg = "lastname must less than 128 characters."
        }
        else if email == "" {
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
            ZStack{
                Image("App-BG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width)
                VStack(alignment: .center, spacing: 12){
                    
                    TextField("Buasri ID",text: $buasri)
                        .textFieldStyle(doFavTextFieldStyle(icon: "person.fill", color: Color.darkred))
                    HStack(alignment: .center, spacing: 5){
                        TextField("Firstname",text: $firstname)
                            .textFieldStyle(doFavTextFieldStyle(icon: "", color: Color.clear))
                //                        Spacer()
                        TextField("Lastname",text: $lastname)
                            .textFieldStyle(doFavTextFieldStyle(icon: "", color: Color.clear))
                    }
                    
                    TextField("G-SWU E-mail",text: $email)
                        .textFieldStyle(doFavTextFieldStyle(icon: "envelope.fill", color: Color.darkred))
                    
                    SecureField("Password",text: $password)
                        .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                    SecureField("Confirm Password",text: $CFpassword)
                        .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                    
                    Text(errMsg)
                        .foregroundColor(Color.darkred)
                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                        .background(Color.clear)
                    
                    Text("Submit")
                        .foregroundColor(Color.white)
                        .frame(width: 140, height: 41, alignment: .center)
                        .background(Color.darkred)
                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                        .cornerRadius(15)
                        .padding(.top, 21)
                        .onTapGesture { validateTextfield() }
                    NavigationLink(destination: ContentView(),isActive: $onSubmit){
                            EmptyView()
                    }
                
                    
                    Spacer()
                }.frame(width: 293)
                    .padding(130)

        }.edgesIgnoringSafeArea(.bottom)
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
            

    }
}


struct Previews_SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
