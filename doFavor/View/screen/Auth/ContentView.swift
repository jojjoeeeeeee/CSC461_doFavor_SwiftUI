//
//  ContentView.swift
//  doFavorUItest
//
//  Created by Khing Thananut on 17/3/2565 BE.
//

import SwiftUI


struct ContentView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var isLinkActive = false

    
    var body: some View {
        NavigationView{
        ZStack{
            Image("App-BG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
            
//            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .center, spacing: 12){
                    // App Logo Image
                    Image("App-Logo")
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
                    SecureField("Password",text: $password)
                        .textFieldStyle(doFavTextFieldStyle(icon: "lock.fill",color: Color.grey))
                        .frame(width: 293)
                        .padding(.bottom, 12)
                    
                    // Buttons
                    NavigationLink(destination: HomePage()){
                        Text("Sign in")
                            .foregroundColor(.white)
                            .frame(width: 140, height: 41, alignment: .center)
                            .background(Color.darkred)
                            .font(Font.custom("SukhumvitSet-Bold", size: 15))
                            .cornerRadius(15)
                    }
                        
                    NavigationLink(destination: SignUpPage()){
                        Text("Sign up")
                            .foregroundColor(Color.darkred)
                            .frame(width: 140, height: 41, alignment: .center)
                            .background(Color.clear)
                            .font(Font.custom("SukhumvitSet-Bold", size: 15))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.darkred, lineWidth: 2))
                    }

                    
                }
//            }).background(.red)
        }.edgesIgnoringSafeArea(.all)
        

        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
