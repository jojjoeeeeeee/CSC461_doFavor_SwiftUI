//
//  ChatMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI



struct ChatMainPage: View {
    
    
    public var petitioner:ResponseUserTSCT?
    public var applicant:ResponseUserTSCT?
    public var conversation_id:String
    @ObservedObject var messageData = FirebaseMessageObservedModel()
    //    @StateObject var messageData:FirebaseMessage
    
    func getMessage(){
        
        MessageViewModel().fetchMessageData(conversation_id: conversation_id) { result in
            switch result{
            case .success(let response):
                messageData.data = response
            case .failure(let error):
                switch error {
                case .ConversationNotFound:
                    MessageViewModel().createNewConversation(conversation_id: conversation_id, by: AppUtils.getUsrId()!, publicKey: AppUtils.E2EE.getBase64PublicKey(), petitioner: petitioner, applicant: applicant) { success in
                        if success {
                            print("success create new conversation")
                        } else {
                            print("fail to create new conversation")
                        }

                    }
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
                    ChatContent(conversation_id: conversation_id, messageData: messageData)
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }.onAppear{ getMessage() }
            
            
        }
        .keyboardAware()
        .navigationBarHidden(true)
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
    
    @State var sender: String
    //    var message: MessagerModel
    var imageUrl = URL(string: "https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg?w=2000")
    
    var body: some View{
        HStack(alignment:.top ,spacing: 16){
            
            if #available(iOS 15.0, *) {
                AsyncImage(url: imageUrl){ image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 28, height: 28)
                        .cornerRadius(28)
                        .opacity(sender == AppUtils.getUsrId()! ? 0 : 100)
                    
                }placeholder: {
                    ProgressView()
                }
            } else {
                Image("TestPic1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .cornerRadius(28)
                    .disabled(sender == AppUtils.getUsrId()!)
            }
            
            
            Text(TextMS)
                .padding()
                .background(sender == AppUtils.getUsrId()! ? Color.darkred.opacity(0.1) :  Color.black.opacity(0.03))
                .onAppear(perform: {print("Text BG",sender == AppUtils.getUsrId()!)})
            
            Image("TestPic1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 28, height: 28)
                .cornerRadius(28)
                .opacity(sender == AppUtils.getUsrId()! ? 100 : 0)
        }
        .frame(maxWidth: .infinity, alignment: sender == AppUtils.getUsrId()! ? .trailing : .leading)
        .font(Font.custom("SukhumvitSet-Bold", size: 13).weight(.regular))
        
    }
    
}

struct MessageField: View{
    @State var MessageTexts: String = ""
    
    @State var conversation_id: String
    
    func sendMsg() {
        if !MessageTexts.isEmpty {
            MessageViewModel().sendMessage(conversation_id: conversation_id, message: MessageTexts, by: AppUtils.getUsrId() ?? "") { success in
                if success {
                    print("success send message")
                }
                else {
                    print("fail to send message")
                }
            }
        }
        MessageTexts = ""
    }
    
    var body: some View{
        HStack{
            Button(action:{
                
            }){
                Image(systemName: "paperclip")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.darkred)
            }
            if #available(iOS 15.0, *) {
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
            } else {
                TextField("พิมพ์ข้อความ...",text: $MessageTexts, onCommit: {
                    sendMsg()
                })
                    .padding()
                    .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
                    .frame(height:40)
                    .background(Color.darkred.opacity(0.1))
                    .cornerRadius(40)
            }
            Button(action:{
                sendMsg()
            }){
                Image(systemName: "arrow.uturn.up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color.darkred)
            }
            
        }
        .padding()
        .frame(height:50)
    }
    
}

struct ChatContent: View{
    
    @State var conversation_id:String
    @StateObject var messageData = FirebaseMessageObservedModel()
    
    
    var body: some View{
        VStack{
            ChatTitle(messageData: messageData)
            ScrollView{
                VStack{

                    ForEach(0..<(messageData.data?.message?.count ?? 0), id: \.self){ index in
                        MessageBubble(TextMS: messageData.data?.message?[index].content ?? "", sender: messageData.data?.message?[index].sender ?? "").onAppear{
                            print("HII",messageData.data?.petitioner)
                        }
                    }


                }
                .padding(.horizontal,20)
            }
            MessageField(conversation_id: conversation_id)
            
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        
    }
}
