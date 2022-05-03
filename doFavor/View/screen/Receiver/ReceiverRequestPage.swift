//
//  ReceiverRequestPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct ReceiverRequestPage: View {
    @ObservedObject var formData = FormDataObservedModel()
    //    @State var formData: TSCTFormDataModel?
    
    @State var isLoading: Bool = false
    @State var isExpired: Bool = false
    @State var isFieldError: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isAlert: Bool = false
    
    
    
    @State var detail = ""
    var detailPlaceholder: String = "ระบุรายละเอียดและจำนวนที่ต้องการฝาก"
    
    func fetchFormData() {
        isLoading.toggle()
        
        TransactionViewModel().getFormData() { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                formData.landmark = response.landmark
                formData.type = response.type
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    print(msg)
                case .Non200StatusCodeError(let val):
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
        NavigationView{
            doFavorMainLoadingIndicatorView(isLoading: isLoading) {
                GeometryReader { geometry in
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
                            RequestView(detail: $detail, isLoading: $isLoading, isExpired: $isExpired, isFieldError: $isFieldError, isNoNetwork: $isNoNetwork, isAlert: $isAlert, formData: self.formData)
//                            TabbarView()
                        }.onAppear{fetchFormData()}
                            .edgesIgnoringSafeArea(.bottom)
                        
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    .navigationTitle("")
                    .navigationBarHidden(true)
                    
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    
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
                    else if isFieldError {
                        return Alert(
                            title: Text("Error"),
                            message: Text("field missing"),
                            dismissButton: .default(Text("Ok")) {
                                
                                fetchFormData()
                            }
                        )
                    }
                    else {
                        return Alert(
                            title: Text("Error"),
                            message: Text("No network connection please try again"),
                            dismissButton: .default(Text("Ok")) {
                                isLoading = false
                                isNoNetwork = false
                            }
                        )
                    }
                    
                }
                
            }
        }
    }
}

struct ReceiverRequestPage_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverRequestPage()
    }
}

struct RequestView: View{
    @State private var selectedLandmark = "เลือกอาคาร"
    //pickerSheet
    @State private var selectionIndex : Int = -1
    @State private var pickerType = 0 // TODO: Update to Enum
    private var isShowingOverlay: Bool {
        get {
            return self.pickerType != 0
        }
    }
    

    private var landmarkPicker: some View{
        pickerSheet(selection: $selectedLandmark, selectionIndex: $selectionIndex, data: formData.landmark!, pickerType: $pickerType)
    }

    private var pickerOverlay: some View {
        Group {
            if pickerType == 1 {
                landmarkPicker
            } else {
                EmptyView()
            }
        }
    }

    
    @State var selectedType: Int = 0
    @State var detailPlaceholder: String = "ระบุรายละเอียดและจำนวนที่ต้องการฝาก"
    
    @State var shopName: String = ""
    @Binding var detail: String
    @State var type: String = ""
    var reward: String = ""
    
    @State var errMsg: String = "error"
    @State var isError: Bool = false
    
    @Binding var isLoading: Bool
    @Binding var isExpired: Bool
    @Binding var isFieldError: Bool
    @Binding var isNoNetwork: Bool
    @Binding var isAlert: Bool
    
    @StateObject public var formData = FormDataObservedModel()
    
    @State var address: userLocationDataModel?
    @State var isNoAddress: Bool = true
    
    private func fetchCreateTSCT() {
        var model = RequestCreateTSCTModel()
        var location = RequestLocationModel()
        var task_location = RequestTaskLocationModel()
        
        model.title = shopName.trimmingCharacters(in: .whitespacesAndNewlines).filter{!$0.isWhitespace}
        model.detail = detail
        model.type = type
        model.reward = ""
        model.petitioner_id = AppUtils.getUsrId() ?? ""
        model.applicant_id = ""
        model.conversation_id = ""
        
        location.room = (address?.room ?? "").isEmpty ? "-" : address?.room
        location.floor = (address?.floor ?? "").isEmpty ? "-" : address?.floor
        location.building = address?.building ?? ""
        location.optional = address?.optional ?? ""
        location.latitude = address?.latitude ?? 0.0
        location.longitude = address?.longitude ?? 0.0
        
        task_location.name = formData.landmark?[selectionIndex].name
        task_location.building = formData.landmark?[selectionIndex].building
        task_location.latitude = formData.landmark?[selectionIndex].latitude
        task_location.longitude = formData.landmark?[selectionIndex].longitude
        
        model.location = location
        model.task_location = task_location
        
        TransactionViewModel().create(reqObj: model) { result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                let usrName = AppUtils.getUsrName()?.components(separatedBy: " ")
                var petitoner = FirebaseUserModel()
                petitoner.id = model.petitioner_id
                petitoner.firstname = usrName?[0]
                petitoner.lastname = usrName?[1]
                
                MessageViewModel().createNewConversation(conversation_id: response.conversation_id ?? "", publicKey: AppUtils.E2EE.getBase64PublicKey(), by: petitoner) { success in
                    if success {
                        print("success create new conversation")
                        doFavorApp(rootView: .HistoryView)
                    }
                    else {
                        print("fail to create new conversation")
                    }
                }
                //                onSubmit.toggle()
            case .failure(let error):
                switch error{
                case .BackEndError(let msg):
                    if msg == "session expired" {
                        isAlert = true
                        isExpired.toggle()
                    }
                    errMsg = msg
                    isError = true
                case .Non200StatusCodeError(let val):
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
    
    
    private func validateData() {
        type = formData.type?[selectedType].title_en ?? ""
        
        isError = true
        if type.isEmpty { //Building empty
            isError = false
            isAlert = true
            isFieldError = true
        }
        else if shopName.isEmpty {
//            errMsg = "กรุณาระบุชื่อร้าน"
            isError = false
            isAlert = true
            isFieldError = true
        }
        else if detail.isEmpty {
//            errMsg = "กรุณาระบุรายละเอียด"
            isError = false
            isAlert = true
            isFieldError = true
        }
        else if selectionIndex == -1 {
            isError = false
            isAlert = true
            isFieldError = true
        }
        else if isNoAddress {
                    isError = false
                    isAlert = true
                    isFieldError = true
        }
        else {
            isError.toggle()
            isLoading.toggle()
            fetchCreateTSCT()
        }
    }
    
    var body: some View{
        
        VStack{
            ScrollView(){
                VStack(alignment:.leading, spacing: 10){
                    //back button
                    HStack{
                        Button(action: {
                            doFavorApp(rootView: .MainAppView)
                        })
                        {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                                .padding(.top,30)
                        }
                        
                        Spacer()
                    }
                    
                    //
                    Text("ที่อยู่ของฉัน")
                        .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                    addressSegment()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                        ).onAppear{
                            address = AppUtils.getUsrAddress()
                            if address != nil {
                                isNoAddress = false
                            } else {
                                isNoAddress = true
                            }
                        }

                    
                    Text("บริการที่ต้องการฝาก")
                        .font(Font.custom("SukhumvitSet-Bold", size: 23).weight(.bold))
                    HStack{
                        ForEach((0..<(self.formData.type?.count ?? 0)), id: \.self) { index in
                            Button(action: {
                                selectedType = index
                            })
                            {
                                Text(self.formData.type?[index].title_en ?? "")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(self.selectedType == index ? Color.darkred : Color.grey)
                                    .padding(.horizontal, 21)
                                    .frame(height: 33)
                                    .background(self.selectedType == index ? Color.darkred.opacity(0.15) : Color.clear, alignment: .center)
                                    .cornerRadius(33)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 33).stroke(self.selectedType == index ? Color.darkred : Color.grey, lineWidth: 1)
                                    )
                            }
                        }
                        
                    }
                    
                    HStack{
                        Text("ชื่อร้าน")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))
                        
                        TextField("ระบุชื่อร้าน..",text: $shopName)
                            .frame(height:36)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                            )
                        
                    }
                    
                    HStack{
                        Text("อาคารใกล้เคียง")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))
                        Button(action: {
                            UIApplication.shared.endEditing()
                            
                            if (formData.landmark?.count ?? 0) > 0 {
                                self.pickerType = 1
                            }
                        }){
                            Text("\(self.selectedLandmark)")
                                .padding()
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 18, weight: .semibold))
                                .padding()
                        }
                        .frame(height:36)
                        .foregroundColor(Color.darkred.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                        )
                    }

                    VStack(alignment: .leading, spacing: 0){
                        Text("สิ่งที่ต้องการฝาก")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))
                        
                        ZStack {
                            if detail.isEmpty {
                                TextEditor(text: $detailPlaceholder)
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .frame(height:89,alignment: .topLeading)
                                    .disabled(true)
                            }
                            TextEditor(text: $detail)
                                .foregroundColor(.primary)
                                .frame(height:89,alignment: .topLeading)
                                .opacity(detail.isEmpty ? 0.25 : 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                                )
                        }
                        
                    }
                    
                    VStack(alignment: .leading, spacing: 0){
                        Text("รูปภาพ (หากมี)")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17).weight(.bold))
                        Button(action: {
                            withAnimation(.easeInOut) {
                                //                                self.isPresented = false
                            }
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 27, weight: .regular))
                                .foregroundColor(Color.darkred.opacity(0.5))
                                .padding(25)
                            
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 10).stroke(Color.darkred.opacity(0.5), lineWidth: 2)
                        )
                        
                        
                    }
                    
                    Text(errMsg)
                        .foregroundColor(Color.darkred)
                        .font(Font.custom("SukhumvitSet-Bold", size: 15))
                        .background(Color.clear)
                        .opacity(isError ? 1 : 0)
                    
                }
                .padding(.horizontal,20)
                //                .frame(width: UIScreen.main.bounds.width-40)
                .font(Font.custom("SukhumvitSet-Bold", size: 14).weight(.bold))
            }
            
            ZStack {
                //button
                Button(action: {
                    validateData()
                }){
                    Text("ยืนยัน")
                        .foregroundColor(Color.white)
                        .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))
                        .frame(width:UIScreen.main.bounds.width-40, height: 50)
                        .background(Color.darkred)
                        .cornerRadius(15)
                        .padding(.bottom)
                    
                }
                
                if isShowingOverlay {
        //            Spacer()
                    pickerOverlay
                        .frame(alignment: .bottomTrailing)
                        .transition(AnyTransition.move(edge: .bottom))
                        .animation(.easeInOut(duration: 0.5))
    //                    .position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height-180)

                }
            }

        }
        .frame(width: UIScreen.main.bounds.width)
        .padding(.bottom, UIScreen.main.bounds.height*0.025)
        .background(Color.white)
        .cornerRadius(20)

    }
}


struct pickerSheet: View{
    @Binding var selection: String
    @Binding var selectionIndex: Int
    var data: [landmarkDataModel]
    @Binding var pickerType: Int

    
    var body: some View {
        VStack(spacing:0){
            Button(action: {
                pickerType = 0
                if selectionIndex != -1 {
                    selection = data[selectionIndex].name ?? ""
                }
            }){
                Spacer()
                Text("Done").fontWeight(.bold).padding(.trailing)
            }.padding(10.0)
        Group{
            Picker("",selection: $selectionIndex){
                ForEach(0..<data.count, id: \.self){ index in
                    Text(data[index].name!)
                }
                
            }.onAppear{
                selectionIndex = 0
            }
        .pickerStyle(WheelPickerStyle())
            .foregroundColor(.white)
            .frame(height: 180)
            .padding()
        }
        .background(Color(UIColor(red: 226/255, green: 225/255, blue: 228/255, alpha: 1)))
        }
        .background(Color(UIColor(red: 247/255, green: 247/255, blue: 249/255, alpha: 1)))

    }
}
