//
//  GiverDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI
import CoreLocation

struct GiverDetailPage: View {
    @Binding var id:String
    @Binding var showingSheet: Bool
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isMessage: Bool = false
    @State var data:TSCTDataModel?
    @State var distance: String = ""
    
    func fetchAcceptTSCT() {
        isLoading.toggle()
        
        TransactionViewModel().acceptTSCT(reqObj: RequestGetTSCTModel(transaction_id: id)){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                data = response
                let usrName = AppUtils.getUsrName()?.components(separatedBy: " ")
                var applicant = FirebaseUserModel()
                applicant.id = data?.applicant?.id
                applicant.firstname = usrName?[0]
                applicant.lastname = usrName?[1]
                
                showingSheet = false

                MessageViewModel().updateApplicantInConversation(conversation_id: data?.conversation_id ?? "", publicKey: AppUtils.E2EE.getBase64PublicKey(), by: applicant) { success in
                    if success {
                        print("success create new conversation")
                        doFavorApp(rootView: .HistoryView)
                    }
                    else {
                        print("fail to create new conversation")
                    }
                }
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    print(msg)
                case .Non200StatusCodeError(let val):
                    if val.message == "Forbiden" {
                        data?.isAccepted = true
                        isAlert = true
                        isMessage.toggle()
                    }
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
    
    var body: some View {
        doFavorMainLoadingIndicatorView(isLoading: isLoading){
            GeometryReader { geometry in
                
                VStack(alignment:.leading, spacing:27){
                    //back button
                    HStack{
                        Button(action: {
                            showingSheet = false
                        })
                        {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                                .padding(.top,30)
                        }
                        
                        Spacer()
                    }
                    
                    
                    //Detail
                    HStack(){
                        Image("TestPic1")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width*0.42, height:UIScreen.main.bounds.width*0.42)
                            .clipped()
                        
                        VStack(alignment:.leading){
                            Button(action: {
                                
                            })
                            {
                                Text(data?.type ?? "")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color.darkred)
                                    .padding(.horizontal, 11)
                                    .frame(height: 19)
                                    .background(Color.darkred.opacity(0.15), alignment: .center)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20).stroke(Color.darkred, lineWidth: 1)
                                    )
                            }
                            
                            Text(data?.title ?? "")
                                .font(Font.custom("SukhumvitSet-Bold", size: 18))
                            
                            HStack{
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.darkred)
                                
                                Text("\(data?.task_location!.name ?? "") \(data?.task_location!.building ?? "")")
                                    .font(Font.custom("SukhumvitSet-Bold", size: 14))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.darkred)
                            }
                            
                            Text(distance)
                                .font(Font.custom("SukhumvitSet-Medium", size: 14))
                                .textContentType(.none)
                                .onAppear{
                                    let address = AppUtils.getUsrAddress()
                                    if let lat = address?.latitude, let lon = address?.longitude {
                                        let coordinateAddress = CLLocation(latitude: lat, longitude: lon)
                                        let coordinateTask = CLLocation(latitude: data?.task_location?.latitude ?? 0.0, longitude: data?.task_location?.longitude ?? 0.0)

                                        let distanceInMeters = coordinateAddress.distance(from: coordinateTask)
                                        if distanceInMeters >= 1000 {
                                            print("ระยะ",distanceInMeters)
                                            let distanceInKm:Double = distanceInMeters/1000
                                            print("ระยะEIEI",distanceInKm)
                                            distance = String(format:"ห่างจากฉัน: %.2f กิโลเมตร",distanceInKm)
                                        } else {
                                            print("ระยะ",distanceInMeters)
                                            distance = String(format:"ห่างจากฉัน: %.0f เมตร",distanceInMeters)
                                        }
                                        
                                    } else {
                                        distance = "กรุณาใส่ที่อยู่ปัจจุบัน"
                                    }
                                }
                        }
                        .frame(width:UIScreen.main.bounds.width*0.42-20)
                        .fixedSize()
                        .padding(.vertical,12)
                        .padding(.trailing,12)
                        
                        Spacer()
                    }
                    .foregroundColor(Color.darkest)
                    .frame(width:UIScreen.main.bounds.width-40 ,height: UIScreen.main.bounds.width*0.42)
                    .fixedSize()
                    
                    //Note
                    HStack(alignment: .top, spacing: 2){
                        VStack(alignment:.leading){
                            Image(systemName: "square.text.square")
                                .font(.system(size: 18, weight: .light))
                                .frame(width: 34, height: 34)
                                .background(Color.white)
                                .cornerRadius(34)
                                .padding(.top,9)
                                .padding(.leading,9)
                            Text(data?.detail ?? "")
                                .font(Font.custom("SukhumvitSet-Bold", size: 13))
                                .fontWeight(.medium)
                                .padding(.horizontal,9)
                                .padding(.bottom,9)
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .frame(width:UIScreen.main.bounds.width-40)
                    .frame(minHeight: 190)
                    .background(Color.darkred.opacity(0.15))
                    .cornerRadius(15)
                    
                    VStack(alignment:.leading){
                        Text("จัดส่งที่ :")
                            .font(Font.custom("SukhumvitSet-Bold", size: 15))
                            .fontWeight(.bold)
                        
                        Text("\(data?.location!.building ?? "") ชั้น \(data?.location!.floor ?? "") ห้อง \(data?.location!.room ?? "")")
                            .font(Font.custom("SukhumvitSet-Bold", size: 14))
                            .foregroundColor(Color.darkred)
                            .fontWeight(.bold)
                        
                    }
                    
                    
                    //Submit button
                    Button(action: {
                        fetchAcceptTSCT()

                    }){
                        Text(data?.isAccepted == false ? "รับมอบหมาย" : "ไม่สามารถรับมอบหมาย")
                        //                Text("รับมอบหมาย")
                            .foregroundColor(Color.white)
                            .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                            .frame(width:UIScreen.main.bounds.width-40, height: 50)
                            .background(data?.isAccepted == false ? Color.darkred : Color.grey)
                            
                            .cornerRadius(15)
                        
                    }.disabled(data?.isAccepted ?? true)
                    
                    Spacer()
                }
                .frame(width:UIScreen.main.bounds.width-40)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
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
            else if isNoNetwork {
                return Alert(
                    title: Text("Error"),
                    message: Text("No network connection please try again"),
                    dismissButton: .default(Text("Ok")) {
                        isLoading = false
                        isNoNetwork = false
                    }
                )
            }
            else {
                return Alert(
                    title: Text("เกิดข้อผิดพลาด"),
                    message: Text("ไม่สามารถรับรายการนี้ได้เนื่องจากมีคนรับไปก่อนหน้า"),
                    dismissButton: .default(Text("Ok")) {
                        isMessage = false
                    }
                )
            }
        }
    }
}

//struct GiverDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        GiverDetailPage(showingSheet: .constant(true), data: )
//    }
//}
