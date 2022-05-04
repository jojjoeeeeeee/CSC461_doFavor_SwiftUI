//
//  PaymentPage.swift
//  doFavor
//
//  Created by Khing Thananut on 4/5/2565 BE.
//

import SwiftUI

struct PaymentPage: View {
    var body: some View {
        
        GeometryReader{ geometry in
            ZStack{
                Image("App-BG")
                    .resizable()
                    .aspectRatio(geometry.size, contentMode: .fill)
//                    .edgesIgnoringSafeArea(.all)
                Image("NavBar-BG")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .position(x:UIScreen.main.bounds.width/2)
                
                VStack(spacing:0){
                    PaymentView()
                }
            }
//            .edgesIgnoringSafeArea(.all)
        }
        .navigationTitle("")
        .navigationBarHidden(true)

    }
}


struct PaymentView:View{
    @Environment(\.presentationMode) var presentationMode
    @State var isSelected = ""
    @State private var showingAlert = false
    
    var body: some View{
        VStack(spacing:0){
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

            
            ScrollView{
                //first atm selection
                Button(action:{
                    isSelected = "1"
                }){
                    HStack{
                        Image(systemName: isSelected=="1"  ? "creditcard.fill" : "creditcard")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(isSelected=="1" ? Color.darkred : Color.darkest)
                            .padding(.leading)
                        
                        Text("บัตรเอทีเอ็ม")
                            .foregroundColor(isSelected=="1" ? Color.darkred : Color.darkest)
                        Spacer()
                        Text("8901")
                            .foregroundColor(Color.darkest)
                        
                        Image("icon-mastercard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:32)
                            .padding(.trailing)

                    }
                    .frame(height: 50)
                    .background(isSelected=="1" ? Color.darkred.opacity(0.15) : Color.clear)
                    .cornerRadius(15)
                }
                
                //second selection
                Button(action:{
                    isSelected = "2"
                }){
                    HStack{
                        Image(systemName: isSelected=="2"  ? "creditcard.fill" : "creditcard")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(isSelected=="2" ? Color.darkred : Color.darkest)
                            .padding(.leading)
                        
                        Text("บัตรเอทีเอ็ม")
                            .foregroundColor(isSelected=="2" ? Color.darkred : Color.darkest)
                        Spacer()
                        Text("1024")
                            .foregroundColor(Color.darkest)
                        
                        Image("icon-visa")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width:32)
                            .padding(.trailing)

                    }
                    .frame(height: 50)
                    .background(isSelected=="2" ? Color.darkred.opacity(0.15) : Color.clear)
                    .cornerRadius(15)

                }

                
                //third Bank Payment
                Button(action:{
                    isSelected = "3"
                }){
                    HStack{
                        Image(systemName: "building.columns.fill")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(isSelected=="3" ? Color.darkred : Color.darkest)
                            .padding(.leading)
                        
                        Text("โอนผ่านธนาคาร")
                            .foregroundColor(isSelected=="3" ? Color.darkred : Color.darkest)
                        Spacer()

                    }
                    .frame(height: 50)
                    .background(isSelected=="3" ? Color.darkred.opacity(0.15) : Color.clear)
                    .cornerRadius(15)

                }

                
                
            }
            .frame(width:UIScreen.main.bounds.width-40)

            Button(action: {
                if !isSelected.isEmpty{
                    self.presentationMode.wrappedValue.dismiss()  
                    doFavorApp(rootView: .MainAppView)
                }else{
                    showingAlert=true
                }
            }){
                Text("ชำระเงิน")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                    .frame(width:UIScreen.main.bounds.width-40, height: 50)
                    .background(Color.darkred)
                    .cornerRadius(15)
            }
            
            .alert("โปรดเลือกช่องทางการชำระเงิน", isPresented: $showingAlert){
                Button("OK", role: .cancel){}
            }
            .padding(.bottom)
        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom, UIScreen.main.bounds.height*0.025)
        .background(Color.white)
        .cornerRadius(20)
        .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
    }
    
}

struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPage()
    }
}
