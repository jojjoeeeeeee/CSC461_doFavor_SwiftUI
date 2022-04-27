//
//  GiverMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct GiverMainPage: View {
    
    var body: some View {
        NavigationView{
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
                        addressSegment()
                        //                    searchSegment()
                        //                        .padding(.top,20)
                        //                        .frame(width:  UIScreen.main.bounds.width-30)
                        
                        GiverView()
                        TabbarView()
                        
                    }            .edgesIgnoringSafeArea(.bottom)
                    
                }
            }
            .navigationBarHidden(true)
            
        }
    }
}

struct GiverMainPage_Previews: PreviewProvider {
    static var previews: some View {
        GiverMainPage()
    }
}

struct GiverView: View{
    @State private var showingSheet = false
    @State private var transactionID = ""
    @State private var searchText = ""
    
    @StateObject public var TSCTData = AllDataObservedModel()
    
    @State var data:TSCTDataModel?
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isRefreshing: Bool = false
    @State var isPaddingTop: Bool = true
    
    @State var isShowBtn: Bool = false
    @State var minScrollValue: CGFloat = 0.0
    
    
    func fetchTransaction(){

        
        TransactionViewModel().getAll(){ result in
            self.isLoading = false
            self.isRefreshing = false
            switch result {
            case .success(let response):
                print("Success",response)
                TSCTData.transactions = response.transactions
                
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
    
    func fetchDetail(){
        isLoading.toggle()
        
        TransactionViewModel().getTSCT(reqObj: RequestGetTSCTModel(transaction_id: transactionID), type: Constants.TSCT_GET_APPLICANT ){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                print("Success",response)
                data = response
                showingSheet.toggle()
                
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
    
    var TSCTDataTwo:[getAllDataModel]?{
        if searchText.isEmpty{
            return (TSCTData.transactions)
        }else{
            return (TSCTData.transactions?.filter{
                $0.title?.contains(searchText) as! Bool || $0.task_location?.name?.contains(searchText) as! Bool
            })!
        }
    }
    
    var body: some View{
        VStack{
            searchSegment(searchText: $searchText).padding(.horizontal).padding(.top)
            doFavorActivityIndicatorView(isLoading: isLoading, isPage: false){
                ScrollViewReader { proxy in
                    RefreshableScrollView(isLoading: $isRefreshing, isPaddingTop: _isPaddingTop,onRefresh: {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        fetchTransaction()
                    },
                    content: {
                        VStack(spacing: 0){
                            
                            if (TSCTDataTwo?.count ?? 0 > 0) {
                                ForEach((0..<(TSCTDataTwo?.count ?? 0)), id:\.self){ index in
                                    giverListCard(category: (TSCTDataTwo?[index].type)!, shopName:( TSCTDataTwo?[index].title)!, landMark: ( TSCTDataTwo?[index].task_location?.name)!, distance: "", note: (TSCTDataTwo?[index].detail)!)
                                        .onTapGesture {
                                            transactionID = (TSCTDataTwo?[index].id!)!
                                            fetchDetail()
                                        }
                                        .sheet(isPresented: $showingSheet){
                                            GiverDetailPage(id: $transactionID, showingSheet: $showingSheet, data: data)
                                        }
                                }
                            }
                            else {
                                Text("ไม่พบรายการรับฝากในขณะนี้")
                                    .font(Font.custom("SukhumvitSet-Bold", size: 14))
                                    .fontWeight(.semibold)
                            }
                            
                            
                            
                        }
                        .onAppear{
                            self.isLoading = true
                            fetchTransaction()
                        }
                        .frame(width:  UIScreen.main.bounds.width-30)
                        .padding()
                        
                        GeometryReader { geometry in
                            let offset = geometry.frame(in: .named("scroll")).minY
                            Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: offset)
                        }
                        
                    })
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }.onAppear{
                        minScrollValue = UIScreen.main.bounds.height-100
                        UIScrollView.appearance().keyboardDismissMode = .interactive
                    }
                    .overlay(alignment: .bottomTrailing){
                        if isShowBtn && (TSCTDataTwo?.count ?? 0 > 0) {
                            Image(systemName: "arrow.up")
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 15, height: 15)
                            .padding(10)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(2)
                            .padding(.bottom, 20)
                            .padding(.horizontal,20)
                            .onTapGesture {
                                withAnimation{
                                    proxy.scrollTo(-1, anchor: .top)
                                }
                            }
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                        if value < minScrollValue {
                            isShowBtn = true
                        }
                        else {
                            isShowBtn = false
                        }
                    }
                }
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

struct searchSegment: View{
    @State var isPresented:Bool = false
    @Binding var searchText: String
    
    
    var body: some View{
        HStack{
            TextField("กำลังหาอะไรอยู่...",text: $searchText)
                .textFieldStyle(doFavTextFieldStyle(icon: "magnifyingglass", color: Color.darkest))
            Button(action: {
                isPresented.toggle()
            })
            {
                Image(systemName: "slider.vertical.3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.darkest)
                    .frame(width: 41, height: 41)
                    .background(Color.white, alignment: .center)
                    .cornerRadius(46)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }
            .halfSheet(isPresented: $isPresented) {
                ZStack{
                    VStack{
                        Text("Hi Filter")
                        
                        Button{
                            isPresented.toggle()
                        }label: {
                            Text("Close")
                        }
                    }
                }
                
            } onEnd:{
                isPresented.toggle()
            }
            
        }
    }
}

struct giverListCard: View{
    //    @StateObject public var TSCTData = AllDataObservedModel()
    //    @State var data:RequestGetTSCTModel?
    
    
    var category: String
    var shopName: String
    var landMark: String
    var distance: String
    var note: String
    
    var body: some View{
        HStack(){
            Image("TestPic1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width*0.255, height:UIScreen.main.bounds.width*0.255)
                .clipped()
                .padding(.vertical,12)
                .padding(.leading,12)
            
            VStack(alignment:.leading,spacing: 0){
                Text(category)
                    .font(.system(size: 8, weight: .semibold))
                    .foregroundColor(Color.darkred)
                    .padding(.horizontal, 11)
                    .frame(height: 15)
                    .background(Color.darkred.opacity(0.15), alignment: .center)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20).stroke(Color.darkred, lineWidth: 1)
                    )
                
                Text(shopName)
                
                Text("\(landMark)  |  \(distance)")
                    .font(Font.custom("SukhumvitSet-Bold", size: 10))
                    .fontWeight(.semibold)
                Spacer()
                HStack(spacing:2){
                    Image(systemName: "square.text.square")
                        .font(.system(size: 18, weight: .light))
                    Text(note)
                        .font(Font.custom("SukhumvitSet-Bold", size: 10))
                        .fontWeight(.medium)
                }
                
            }
            .padding(.vertical,12)
            .padding(.trailing,12)
            
            Spacer()
        }
        .foregroundColor(Color.darkest)
        .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
        .frame(width:UIScreen.main.bounds.width-30 ,height: UIScreen.main.bounds.width*0.3)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
        .padding(12)
        
    }
}

