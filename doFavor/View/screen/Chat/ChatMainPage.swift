//
//  ChatMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 20/4/2565 BE.
//

import SwiftUI



struct ChatMainPage: View {
    
    let chat:FirebaseMessage = FirebaseMessage(petitioner: "peti", applicant: "appli", message: [MessageModel(content: "Hello", date: Date(), type: "text", sender: "peti"),MessageModel(content: "Hiiiii", date: Date(), type: "text", sender: "appli")])
    
    @State var received: Bool = false
    public var conversation_id:String
    @StateObject var messageData = FirebaseMessageObservedModel()
    //    @StateObject var messageData:FirebaseMessage
    
    func getMessage(){
        MessageViewModel().fetchMessageData(conversation_id: conversation_id) { result in
            switch result{
            case .success(let response):
                messageData.data = response
                if AppUtils.getUsrId()!.matchRegex(for: (messageData.data?.petitioner.description)!) {
                    received = true
                }else{
                    received = false
                }
                print(response.message[0].content)
                print("chat sucess",messageData.data!.message)
                print("name",messageData.data!.petitioner)
                print("name",messageData.data!.applicant)
                //                print("ID",AppUtils.getUsrId()!)
                //                print("received",received)
                //                        print(response)
            case .failure:
                print("chat failure")
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
                    ChatContent(chat: chat, conversation_id: conversation_id, received: $received, messageData: messageData)
                    TabbarView()
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }.onAppear{ getMessage() }
            
            
        }
        .navigationBarHidden(true)
    }
}

struct ChatMainPage_Previews: PreviewProvider {
    static var previews: some View {
        ChatMainPage(received: true, conversation_id: "624f69d13f8a07d7755851a6_conversation")
    }
}

struct ChatTitle: View{
    var Name:String
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
                Text(Name)
                    .font(.system(size: 17, weight: .semibold))
                    .multilineTextAlignment(.center)
                Text("Sender")
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
    
    @Binding var received: Bool
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
                        .opacity(received ? 0 : 100)
                    
                }placeholder: {
                    ProgressView()
                }
            } else {
                Image("TestPic1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 28, height: 28)
                    .cornerRadius(28)
                    .disabled(received)
            }
            
            
            Text(TextMS)
                .padding()
                .background(received ? Color.darkred.opacity(0.1) :  Color.black.opacity(0.03))
                .onAppear(perform: {print("Text BG",received)})
            
            Image("TestPic1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 28, height: 28)
                .cornerRadius(28)
                .opacity(received ? 100 : 0)
        }
        .frame(maxWidth: .infinity, alignment: received ? .trailing : .leading)
        .font(Font.custom("SukhumvitSet-Bold", size: 13).weight(.regular))
        
    }
    
}

struct MessageField: View{
    @State var MessageTexts: String = ""
    
    var body: some View{
        HStack{
            Button(action:{
                
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
            Button(action:{
                
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

struct Student: Hashable {
    let name: String
}

struct ChatContent: View{
    var chat:FirebaseMessage

    @State var conversation_id:String
    @Binding var received: Bool
    var messageData:FirebaseMessageObservedModel
    
    
    
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]

    
    var body: some View{
        VStack{
            ChatTitle(Name: "Name")
            ScrollView{
                VStack{
                    ForEach(students, id: \.self){ item in
//                        Text(item.name)
                        MessageBubble(TextMS: item.name, received: $received)
                    }

                    //                    ForEach(messageData.data.message, id: \.content){
                    //                        text in MessageBubble(messageData: text, received: $received)
                    //                    }
                    //                    MessageBubble(received: $received, message: MessageModel(content: "Hi", date: Date(), type: "1", sender: "applicant"))
                    //                    MessageBubble(messageData: messageData, received: $received, message: <#T##MessageModel#>)
                }
                .padding(.horizontal,20)
            }
            MessageField()
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.white)
        .cornerRadius(20)
        
    }
}
