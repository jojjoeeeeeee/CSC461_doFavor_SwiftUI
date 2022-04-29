//
//  SettingMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct SettingMainPage: View {
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
                    SettingView()
                    TabbarView()

                }
                .edgesIgnoringSafeArea(.bottom)

            }
        }
        .navigationBarHidden(true)
    }
}

struct SettingMainPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingMainPage()
    }
}

struct SettingView: View{
    @State var username: String = AppUtils.getUsrUsername() ?? ""
    @State var email: String = AppUtils.getUsrEmail() ?? ""
    @State var name: String = AppUtils.getUsrName() ?? ""
    
    var body: some View{
        VStack{
            ScrollView(){
                VStack{
                    Text("บัญชีผู้ใช้")
                        .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                        .padding()
                    
                    HStack(spacing:20){
                        Image("TestPic1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width*0.26,height:UIScreen.main.bounds.width*0.26)
                            .cornerRadius(98)
                        
//                        Spacer()
                        
                        VStack(alignment: .leading, spacing:9){
                            Text("Buasri ID : \(username)")
                            Text(name)
                                .frame(height: 24)
                                .padding(.horizontal,15)
                                .background(Color.grey.opacity(0.15))
                                .cornerRadius(5)
                            Text(email)
                                .textContentType(.none)
                                .frame(height: 24)
                                .padding(.horizontal,15)
                                .background(Color.grey.opacity(0.15))
                                .cornerRadius(5)

                            Text("เปลี่ยนรหัสผ่าน")
                                .underline()
                        }                        .font(Font.custom("SukhumvitSet-Bold", size: 12).weight(.regular))
                            .foregroundColor(Color.grey)

                    }
                    Divider()
                    HStack(spacing: 8){
                        Button(action: {
                            
                        }){
                            Image(systemName: "info.circle")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color.darkred)

                            Text("แจ้งปัญหาการใช้งาน/ติดต่อแอดมิน")
                                .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.black))
                                .foregroundColor(Color.darkred)
                            Spacer()
                        }
                    }.padding(10)
                    Divider()
                    HStack(spacing: 8){
                        Button(action: {
                            
                        }){
                            Image(systemName: "info.circle")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(Color.darkred)

                            Text("เกี่ยวกับแอพพลิเคชั่น")
                                .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.black))
                                .foregroundColor(Color.darkred)
                            Spacer()
                        }
                    }.padding(10)
                    Divider()


                    Spacer()
            }.padding(.horizontal,20)

            }

            Button(action: {
                AppUtils.eraseAllUsrData()
                                doFavorApp(rootView: .LoginView)
            }){
                Text("ออกจากระบบ")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.grey)
            .cornerRadius(15)
            .padding(.bottom)
            
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
//        .cornerRadius(20)

    }
}
