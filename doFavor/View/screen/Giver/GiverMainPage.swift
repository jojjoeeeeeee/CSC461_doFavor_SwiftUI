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

    @State var isLoading: Bool = false
    @State var isAlert: Bool = false
    @State var isExpired: Bool = false
    @State var isNoNetwork: Bool = false
    @State var isRefreshing: Bool = false
    
    func fetchTransaction(){
        isLoading.toggle()
        
        TransactionViewModel().getAll(){ result in
            isLoading.toggle()

            switch result {
            case .success(let response):
                print("Success",response)
                TSCTData.transactions = response.transactions
//                print(TSCTData.transactions![0].status)
                
            case .failure(let error):
                print("Error \(error)")
        }
    }
    }
    
    var TSCTDataTwo:[getAllDataModel]?{
        if searchText.isEmpty{
            return (TSCTData.transactions)
        }else{
            return (TSCTData.transactions?.filter{
                $0.title?.contains(searchText) as! Bool
            })!
        }
    }
    
    var body: some View{
        VStack{
            doFavorActivityIndicatorView(isLoading: isLoading, isPage: false){
            ScrollView(){
                VStack(spacing: 0){
                    searchSegment(searchText: $searchText)
                    

                    
//                    ForEach((0..<(TSCTData.transactions?.count ?? 0)), id:\.self){ index in
//                        giverListCard(category: (TSCTData.transactions?[index].type)!, shopName:( TSCTData.transactions?[index].title)!, landMark: ( TSCTData.transactions?[index].task_location?.name)!, distance: "", note: (TSCTData.transactions?[index].detail)!)
//                            .onTapGesture {
//                                showingSheet.toggle()
//                                transactionID = TSCTData.transactions![index].id!
//
//                            }
//                            .sheet(isPresented: $showingSheet){
//                                GiverDetailPage(id: $transactionID, showingSheet: $showingSheet)
//                            }
//                    }
                    
                    
                    ForEach((0..<(TSCTDataTwo?.count ?? 0)), id:\.self){ index in
                        giverListCard(category: (TSCTDataTwo?[index].type)!, shopName:( TSCTDataTwo?[index].title)!, landMark: ( TSCTDataTwo?[index].task_location?.name)!, distance: "", note: (TSCTDataTwo?[index].detail)!)
                            .onTapGesture {
                                showingSheet.toggle()
                                transactionID = (TSCTDataTwo?[index].id!)!
                                    
                            }
                            .sheet(isPresented: $showingSheet){
                                GiverDetailPage(id: $transactionID, showingSheet: $showingSheet)
                            }
                    }

                    
                    
                }
                .onAppear{fetchTransaction()}
                .frame(width:  UIScreen.main.bounds.width-30)

                .padding()
            }
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

