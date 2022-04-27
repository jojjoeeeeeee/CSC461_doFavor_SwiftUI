//
//  ChatMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI
import ImageViewer
import Kingfisher

struct ChatMainPage: View {
    
    
    public var petitioner:ResponseUserTSCT?
    public var applicant:ResponseUserTSCT?
    public var conversation_id:String
    @ObservedObject var messageData = FirebaseMessageObservedModel()
    
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    
    @State var isShowFullImage: Bool = false
    @State var tempFullImage: Image = Image(systemName: "photo")
    
    func getMessage() {
        MessageViewModel().fetchMessageData(conversation_id: conversation_id) { result in
            switch result{
            case .success(let response):
                messageData.data = response

            case .failure(let error):
                switch error {
                case .ConversationNotFound:
                    print("Conversation not found")
                case .MessageNotFound:
                    print("this conversation doesnt have any message")
                }
            }
        }

    }

    
    var body: some View {
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
                    ChatContent(isAlert: $isAlert, isExpired: $isExpired, isNoNetwork: $isNoNetwork,conversation_id: conversation_id, messageData: messageData, isShowFullImage: $isShowFullImage, tempFullImage: $tempFullImage)
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)
                .overlay(ImageViewer(image: $tempFullImage, viewerShown: $isShowFullImage))
                
            }.onAppear{
                getMessage()
            }
            
            
        }
        .navigationBarHidden(true)
        .keyboardAware()
        
    }
}

struct ChatMainPage_Previews: PreviewProvider {
    static var previews: some View {
        ChatMainPage(conversation_id: "624f69d13f8a07d7755851a6_conversation")
    }
}

struct ChatTitle: View{
    
    @StateObject var messageData = FirebaseMessageObservedModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        HStack{
            Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }){
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
            }
            Spacer()
            VStack{
                Text(messageData.data?.petitioner?.id == AppUtils.getUsrId() ? ("\(messageData.data?.applicant?.firstname ?? "") \(messageData.data?.applicant?.lastname ?? "")") : ("\(messageData.data?.petitioner?.firstname ?? "") \(messageData.data?.petitioner?.lastname ?? "")"))
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text(messageData.data?.petitioner?.id == AppUtils.getUsrId() ? "ผู้รับฝาก":"ผู้ฝาก")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.darkred)
            }
            
            Spacer()
            
            Button(action:{
                
            }){
                // HERE IS A EMPTY BUTTON TO MAKE THE NAME CENTERED, SO I HIDDEN IT. HOPE THAT WOULD NOT AFFECTED.
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color.white.opacity(0))
                    .hidden()
            }
        }
        .padding(.horizontal,20)
        .padding(.vertical,20)
        
    }
}

struct MessageBubble: View{
//    var messageData:MessageModel
    var TextMS:String
    let proxy: ScrollViewProxy
    @StateObject var messageData = FirebaseMessageObservedModel()

    @State var type:String
    @State var sender: String

    @State var image = Image(systemName: "photo")
    @Binding var isShowFullImage: Bool
    @Binding var tempFullImage: Image

    var imageUrl = URL(string: "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000")
    
    var body: some View{
        HStack(alignment:.top ,spacing: 16){
            
            AsyncImage(url: imageUrl){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .cornerRadius(28)
                    .opacity(sender == AppUtils.getUsrId()! ? 0 : 100)
                
            }placeholder: {
                ProgressView()
            }
            
            if type == "Encrypted" {
                HStack {
                    Text("Content Sealing")
                    Image(systemName: "lock.circle")
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 15, height: 15)
                }
                .padding()
                .background(sender == AppUtils.getUsrId()! ? Color.darkred.opacity(0.3) :  Color.black.opacity(0.05))
            } else if type == "text" {
                Text(TextMS)
                    .padding()
                    .background(sender == AppUtils.getUsrId()! ? Color.darkred.opacity(0.1) :  Color.black.opacity(0.03))
            } else if type == "photo" {
                let url = URL(string: TextMS)
                let processor = ResizingImageProcessor(referenceSize: .init(width: 800,height:800), mode: .aspectFill)
                
                KFImage.url(url)
                    .placeholder({
                        HStack{
                            ProgressView()
                        }
                        .padding()
                        .frame(width: 150, height: 150)
                        .background(sender == AppUtils.getUsrId()! ? Color.darkred.opacity(0.3) :  Color.black.opacity(0.05))
                    })
                    .setProcessor(processor)
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .onProgress { receivedSize, totalSize in  }
                    .onSuccess { result in
                        withAnimation{
                            proxy.scrollTo((messageData.data?.message?.count ?? 0) - 1, anchor: .bottom)
                        }
                        image = Image(uiImage: result.image)
                    }
                    .onFailure { error in print("ERROR LOAD IMAGE",error) }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width/3)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .onTapGesture{
                        self.tempFullImage = image
                        if self.tempFullImage != Image(systemName: "photo") {
                            isShowFullImage = true
                        }
                    }
            }
            
            AsyncImage(url: imageUrl){ image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .cornerRadius(28)
                    .opacity(sender == AppUtils.getUsrId()! ? 100 : 0)
                
            }placeholder: {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, alignment: sender == AppUtils.getUsrId()! ? .trailing : .leading)
        .font(Font.custom("SukhumvitSet-Bold", size: 13).weight(.regular))
        
    }
    
}

struct MessageField: View{
    
    @Binding var isAlert: Bool
    @Binding var isExpired: Bool
    @Binding var isNoNetwork: Bool
    
    @State var MessageTexts: String = ""
    
    @State var image: Image? = Image(systemName: "photo")
    @State var data: Data?
    
    @State var conversation_id: String
    @State var messageData = FirebaseMessageObservedModel()
    
    @State var isShowActionSheet: Bool = false
    @State var pickerSelectedType: UIImagePickerController.SourceType = .photoLibrary
    @State var isShowImagePicker: Bool = false
    
    @State var isImage: Bool = false
    @State var imageLoading: Bool = false
    
    func sendMsg() {
        if !MessageTexts.isEmpty {
            MessageViewModel().sendMessage(conversation_id: conversation_id, message: MessageTexts, by: AppUtils.getUsrId() ?? "", otherPublicKey: messageData.data?.petitioner?.id == AppUtils.getUsrId() ? messageData.data?.applicant?.publicKey ?? "" : messageData.data?.petitioner?.publicKey ?? "", type: "text") { success in
                if success {
                    print("success send message")
                }
                else {
                    print("fail to send message")
                }
            }
            MessageTexts = ""
        }
        else if self.image != Image(systemName: "photo") && self.data != nil {
            
            self.imageLoading = true
            let dateFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .long
                formatter.locale = .current
                formatter.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss O"
                return formatter
            }()
            
            let filename = "\(conversation_id)_\(AppUtils.getUsrId() ?? "")_\(dateFormatter.string(from: Date()))"
            
            MessageViewModel().uploadMessagePhoto(with: self.data!, fileName: filename) { result in
                
                switch result{
                case .success(let url):
                    
                    MessageViewModel().sendMessage(conversation_id: conversation_id, message: url, by: AppUtils.getUsrId() ?? "", otherPublicKey: messageData.data?.petitioner?.id == AppUtils.getUsrId() ? messageData.data?.applicant?.publicKey ?? "" : messageData.data?.petitioner?.publicKey ?? "", type: "photo") { success in
                        if success {
                            print("success send message")
                            self.image = Image(systemName: "photo")
                            self.isImage = false
                            self.imageLoading = false
                            self.data = nil
                        }
                        else {
                            print("fail to send message")
                            self.image = Image(systemName: "photo")
                            self.isImage = false
                            self.imageLoading = false
                            self.data = nil
                        }
                    }
                case .failure(let error):
                    self.image = Image(systemName: "photo")
                    self.isImage = false
                    self.imageLoading = false
                    self.data = nil
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
    }
    
    var body: some View{
        HStack{
            if isImage {
                Button(action:{
                    self.isImage = false
                    self.image = Image(systemName: "photo")
                }){
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(self.imageLoading == false ? Color.darkred : Color.grey)
                }.disabled(self.imageLoading)
                
                ZStack {
                    HStack{
                        self.image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: UIScreen.main.bounds.height/5)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .blur(radius: self.imageLoading ? 0.5 : 0)
                            .padding()
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width*0.8)
                    .background(Color.darkred.opacity(0.1))
                    .cornerRadius(40)

                    if imageLoading {
                        ProgressView().tint(Color.white)
                    }
                }
                
            }
            else {
                Button(action:{
                    self.isShowActionSheet = true
                }){
                    Image(systemName: "paperclip")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.darkred)
                }
                
                TextField("พิมพ์ข้อความ...",text: $MessageTexts)
                    .padding()
                    .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                    .frame(height:40)
                    .background(Color.darkred.opacity(0.1))
                    .cornerRadius(40)
                    .submitLabel(.send)
                    .onSubmit {
                        sendMsg()
                    }
            }
            
            Button(action:{
                sendMsg()
            }){
                Image(systemName: "arrow.uturn.up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(self.imageLoading == false ? Color.darkred : Color.grey)
            }.disabled(self.imageLoading)
            
        }
        .padding()
        .frame(height: isImage == false ? 50 : UIScreen.main.bounds.height/4+50)
        .onTapGesture() {
            self.isShowActionSheet = false
        }
        
        .actionSheet(isPresented: self.$isShowActionSheet) { () -> ActionSheet in
            ActionSheet(title: Text("Send a photo"), buttons: [
                .cancel(),
                .default(Text("Take Photo"), action: {
                    self.pickerSelectedType = .camera
                    self.isShowImagePicker = true
                }),
                .default(Text("Choose Photo"), action: {
                    self.pickerSelectedType = .photoLibrary
                    self.isShowImagePicker = true
                })

              ])
        }.sheet(isPresented: self.$isShowImagePicker) {
            UIImagePickerVC(image: self.$image, data: self.$data, sourceType: self.pickerSelectedType).background(Color.black).edgesIgnoringSafeArea(.all)
                .onDisappear{
                    if data == nil {
                        self.isImage = false
                    } else {
                        self.isImage = true
                    }
                }
        }
        
    }
    
}

struct ChatContent: View{
    
    @Binding var isAlert: Bool
    @Binding var isExpired: Bool
    @Binding var isNoNetwork: Bool
    
    @State var conversation_id:String
    @StateObject var messageData = FirebaseMessageObservedModel()
    @State var isShowBtn: Bool = false
    @State var maxScrollValue: CGFloat = 0.0
    
    @Binding var isShowFullImage: Bool
    @Binding var tempFullImage: Image
    
    
    var body: some View{
        VStack{
            ChatTitle(messageData: messageData)
            ScrollViewReader { proxy in
                ScrollView{
                    VStack{
                        ForEach(0..<(messageData.data?.message?.count ?? 0), id: \.self) { index in
                            MessageBubble(TextMS: messageData.data?.message?[index].content ?? "", proxy: proxy, messageData: messageData, type: messageData.data?.message?[index].type ?? "", sender: messageData.data?.message?[index].sender ?? "", isShowFullImage: $isShowFullImage, tempFullImage: $tempFullImage).id(index)
                        }
                        

                    }.padding(.horizontal,20)
                    
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .named("scroll")).minY
                        Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                    }
                    
                }
                .navigationBarHidden(true)
                .onAppear{
                    UIScrollView.appearance().keyboardDismissMode = .interactive
                }
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear{
                            maxScrollValue = geometry.size.height
                        }
                    }
                )
                .onChange(of: messageData.data?.message?.count) { value in
                    if (value ?? 0) > 0 {
                        withAnimation{
                            proxy.scrollTo((value ?? 0) - 1, anchor: .bottom)
                        }
                    }
                }
                .overlay(alignment: .bottomTrailing){
                    if isShowBtn {
                        Image(systemName: "arrow.down")
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 15, height: 15)
                        .padding(10)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(2)
                        .padding(.bottom, 20)
                        .padding(.horizontal,20)
                        .disabled(!isShowBtn)
                        .onTapGesture {
                            withAnimation{
                                proxy.scrollTo((messageData.data?.message?.count ?? 0) - 1, anchor: .bottom)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    if value > maxScrollValue {
                        isShowBtn = true
                    }
                    else {
                        isShowBtn = false
                    }
                }

            }
            MessageField(isAlert: $isAlert, isExpired: $isExpired, isNoNetwork: $isNoNetwork,conversation_id: conversation_id, messageData: messageData)
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
        
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
