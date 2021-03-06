//
//  GiverMainPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI
import CoreLocation

struct GiverMainPage: View {
    
    @State var FilterType: [String] = ["food","grocery","drinks"] //use for creating ViewButton
    @State var isPresented: Bool = false
    @State var isLatest = true
    @State private var offset = CGSize.zero
    
    
    var popOverFilter: some View {
        Group {
            ZStack(alignment: .bottom) {
                Color.black.opacity(0.001).ignoresSafeArea(.all)
                    .onTapGesture {
                        isPresented = false
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                if gesture.translation.height > 0 {
                                    offset = gesture.translation
                                }
                            }
                            .onEnded{ _ in
                                if offset.height > 80 {
                                    offset = .zero
                                    isPresented = false
                                } else {
                                    offset = .zero
                                }
                            }
                    )
                ZStack {
                    Rectangle()
                        .fill(Color.white)
                        .frame(maxWidth: .infinity, maxHeight: 300.0)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
//                        .edgesIgnoringSafeArea(.all)
                    GiverFilterSheet(showingSheet: $isPresented, isLatest: $isLatest, FilterType: $FilterType)
                        .padding(.bottom, 50)
                }
                .gesture(
                    DragGesture()
                        .onChanged{ gesture in
                            if gesture.translation.height > 0 {
                                offset = gesture.translation
                            }
                        }
                        .onEnded{ _ in
                            if offset.height > 40 {
                                offset = .zero
                                isPresented = false
                            } else {
                                offset = .zero
                            }
                        }
                )
                .offset(x: 0, y: offset.height)
            }
        }
    }
    
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
                        GiverView(isPresented: $isPresented, FilterType: $FilterType, isLatest: $isLatest)
                        TabbarView()
                        
                    }            .edgesIgnoringSafeArea(.bottom)
                    
                }.overlay{
                    if isPresented {
                        popOverFilter
                            .frame(alignment: .bottomTrailing)
                            .transition(AnyTransition.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5))
                            .edgesIgnoringSafeArea(.bottom)

                    }
                }
            }
            
            .navigationBarHidden(true)
            
        }
    }
}

struct GiverView: View{
    @Binding var isPresented: Bool
    @Binding var FilterType: [String]
    @Binding var isLatest: Bool
    @State private var showingSheet = false
    @State private var transactionID = ""
    @State private var searchText = ""
    
    @StateObject public var TSCTData = AllDataObservedModel()
    
    @State var TSCTDataBackup = [getAllDataModel]()
    
    @State var data:TSCTDataModel?
    
    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isRefreshing: Bool = false
    @State var isPaddingTop: Bool = true
    
    @State var isShowBtn: Bool = false
    @State var minScrollValue: CGFloat = 0.0
    
    let dateFormatter = DateFormatter()
    @State var stateOfMinScrollValue:Int = 0
    
    
    func fetchTransaction(){
        
        
        TransactionViewModel().getAll(){ result in
            self.isLoading = false
            self.isRefreshing = false
            switch result {
            case .success(let response):
                print("Success")
                TSCTData.transactions = response.transactions
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
//                    TSCTData.transactions = TSCTData.transactions?.sorted { dateFormatter.date(from: $0.created ?? "2011-11-11'T'11:11:11.111Z")! > dateFormatter.date(from: $1.created ?? "2011-11-11'T'11:11:11.111Z")! }
                TSCTData.transactions = TSCTData.transactions?.map{ (val: getAllDataModel) -> getAllDataModel in
                    var mutableVal = val
                    let address = AppUtils.getUsrAddress()
                    if let lat = address?.latitude, let lon = address?.longitude {
                        let coordinateAddress = CLLocation(latitude: lat, longitude: lon)
                        let coordinateTask = CLLocation(latitude: val.task_location?.latitude ?? 0.0, longitude: val.task_location?.longitude ?? 0.0)

                        let distanceInMeters = coordinateAddress.distance(from: coordinateTask)
                        mutableVal.distance = distanceInMeters
                        
                        if distanceInMeters >= 1000 {
                            let distanceInKm:Double = distanceInMeters/1000
                            mutableVal.distanceString = String(format:"%.2f km",distanceInKm)
                        } else {
                            mutableVal.distanceString = String(format:"%.0f m",distanceInMeters)
                        }
                    } else {
                        mutableVal.distanceString = "?????????????????????????????????????????????????????????????????????"
                    }
                    return mutableVal
                }
                
                TSCTDataBackup = TSCTData.transactions!
                
                if isLatest {
                    TSCTData.transactions = TSCTData.transactions?.sorted { dateFormatter.date(from: $0.created ?? "2011-11-11'T'11:11:11.111Z")! > dateFormatter.date(from: $1.created ?? "2011-11-11'T'11:11:11.111Z")! }
                } else {
                    TSCTData.transactions = TSCTData.transactions?.sorted{$0.distance ?? 0.0 < $1.distance ?? 0.0}
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
                print("Success")
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
            return TSCTData.transactions?.filter{FilterType.contains($0.type ?? "") as Bool}
        } else{
            if isLatest {
                return (TSCTData.transactions?.filter{
                    ($0.title?.contains(searchText) as! Bool || $0.task_location?.name?.contains(searchText) as! Bool) && FilterType.contains($0.type ?? "") as Bool
                })
            } else {
                return (TSCTData.transactions?.sorted{$0.distance ?? 0.0 < $1.distance ?? 0.0})?.filter{
                    ($0.title?.contains(searchText) as! Bool || $0.task_location?.name?.contains(searchText) as! Bool) && FilterType.contains($0.type ?? "") as Bool
                }
            }
        }
        
    }
    
    var body: some View{
        VStack{
            searchSegment(isPresented: $isPresented, searchText: $searchText, TSCTDataTwo: TSCTDataTwo, isLatest: $isLatest).padding(.horizontal).padding(.top)
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
                                    giverListCard(category: (TSCTDataTwo?[index].type)!, shopName:( TSCTDataTwo?[index].title)!, landMark: ( TSCTDataTwo?[index].task_location?.name)!, tasklocation: (TSCTDataTwo?[index].task_location)!, note: (TSCTDataTwo?[index].detail)!, distance: (TSCTDataTwo?[index].distanceString)!)
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
                                Text("???????????????????????????????????????????????????????????????????????????")
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
                        UIScrollView.appearance().keyboardDismissMode = .interactive
                    }
                    .overlay(alignment: .bottomTrailing){
                        if isShowBtn && (TSCTDataTwo?.count ?? 0 > 4) {
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
                        if stateOfMinScrollValue < 2 {
                            minScrollValue = value*0.85
                            stateOfMinScrollValue += 1
                        }

                        if value < minScrollValue {
                            isShowBtn = true
                        }
                        else {
                            isShowBtn = false
                        }
                    }
                }
            }
        }
        .onChange(of: isLatest) { latest in
            TSCTData.transactions = TSCTDataBackup
            if latest {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                TSCTData.transactions = (TSCTData.transactions?.sorted{ dateFormatter.date(from: $0.created ?? "2011-11-11'T'11:11:11.111Z")! > dateFormatter.date(from: $1.created ?? "2011-11-11'T'11:11:11.111Z")! })?.filter{FilterType.contains($0.type ?? "") as Bool}
            } else {
                TSCTData.transactions = (TSCTData.transactions?.sorted{$0.distance ?? 0.0 < $1.distance ?? 0.0})?.filter{FilterType.contains($0.type ?? "") as Bool}
            }
        }
        .onChange(of: FilterType) { filter in
            TSCTData.transactions = TSCTDataBackup
            if isLatest {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                TSCTData.transactions = (TSCTData.transactions?.sorted{ dateFormatter.date(from: $0.created ?? "2011-11-11'T'11:11:11.111Z")! > dateFormatter.date(from: $1.created ?? "2011-11-11'T'11:11:11.111Z")! })?.filter{FilterType.contains($0.type ?? "") as Bool}
            } else {
                TSCTData.transactions = (TSCTData.transactions?.sorted{$0.distance ?? 0.0 < $1.distance ?? 0.0})?.filter{FilterType.contains($0.type ?? "") as Bool}
            }
        }
        .alert(isPresented:$isAlert) {
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
    
    @Binding var isPresented:Bool
    @Binding var searchText: String
    var TSCTDataTwo:[getAllDataModel]?
    @Binding var isLatest: Bool
    
    var body: some View{
        HStack{
            TextField("?????????????????????????????????????????????...",text: $searchText)
                .textFieldStyle(doFavTextFieldStyle(icon: "magnifyingglass", color: Color.darkest))
            
            Button(action: {
                UIApplication.shared.endEditing()
                isPresented.toggle()
            }){
                Image(systemName: "slider.vertical.3")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.darkest)
                    .frame(width: 41, height: 41)
                    .background(Color.white, alignment: .center)
                    .cornerRadius(46)
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            }
            
            
            //            .sheet(isPresented: $isPresented){
            //                GiverFilterSheet(showingSheet: $isPresented, isLatest: $isLatest, FilterType: $FilterType)
            //            }
            
        }
        
    }
    
}

//}

struct giverListCard: View{
    //    @StateObject public var TSCTData = AllDataObservedModel()
    //    @State var data:RequestGetTSCTModel?
    
    
    var category: String
    var shopName: String
    var landMark: String
    var tasklocation: landmarkDataModel
    var note: String
    var distance: String
    
    var body: some View{
        HStack(){
            Image(category)
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
