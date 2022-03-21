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
    
    @Environment(\.presentationMode) var presentationMode

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
                    
                    TextField("Password",text: $password)
                        .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                    TextField("Confirm Password",text: $CFpassword)
                        .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill", color: Color.grey))
                    
                    NavigationLink(destination: SignUpVerify()){
                            Text("Submit")
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 41, alignment: .center)
                                .background(Color.darkred)
                                .font(Font.custom("SukhumvitSet-Bold", size: 15))
                                .cornerRadius(15)
                                .padding(.top, 21)
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
//            .background(.red)

        }
    }
//}
