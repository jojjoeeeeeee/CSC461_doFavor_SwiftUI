//
//  SignUpVerify.swift
//  doFavor
//
//  Created by Khing Thananut on 22/3/2565 BE.
//
 
import SwiftUI

//class LimitedCharacter: ObservedObject<>{
//
//    @Published var char:String=""{
//        didSet{
//            if char.count > 6{
//                char = String(char.prefix(6))
//            }
//        }
//    }
//}

struct SignUpVerify: View {
//    @ObservedObject var limitChar: LimitedCharacter
    @State var verifycode: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        //        NavigationView{
                    ZStack{
                        Image("App-BG")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width)
                        
                        VStack(alignment: .center, spacing: 30){
                            Text("Verification Code")
                                .font(Font.custom("SukhumvitSet-Bold", size: 20))


                            HStack(alignment: .center, spacing: 5){
                                TextField("",text: $verifycode)
                                    .textFieldStyle(verifyTF())
                            }
                            Text(verbatim:"โปรดกรอกรหัสยืนยันที่ได้รับทางอีเมล์ Thananut.khing@g.swu.ac.th โปรดตรวจสอบกล่องข้อความ/อีเมลขยะ")
                                .font(Font.custom("SukhumvitSet-Medium", size: 14))
                                .textContentType(.none)
                                .multilineTextAlignment(.center)
                                                        
                            NavigationLink(destination: {}){
                                    Text("ยืนยัน")
                                        .foregroundColor(Color.white)
                                        .frame(width: 140, height: 41, alignment: .center)
                                        .background(Color.darkred)
                                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                                        .cornerRadius(15)
//                                        .padding(.top, 21)
                            }
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
        //            .background(.red)

                }
}

struct verifyTF: TextFieldStyle{
    func _body(configuration: TextField<_Label>) -> some View {
        HStack{
            configuration
//                .padding()
                .frame(width: UIScreen.main.bounds.width*0.7, height: 57, alignment: .center)
                .font(Font.custom("SukhumvitSet-Bold", size: 20))
                .multilineTextAlignment(.center)
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
