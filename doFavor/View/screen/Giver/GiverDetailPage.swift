//
//  GiverDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct GiverDetailPage: View {
    @Binding var id:String
    @Binding var showingSheet: Bool
    
    @State var isLoading: Bool = false
    @State var data:TSCTDataModel? = nil
    
    func fetchDetail(){
        isLoading.toggle()

        TransactionViewModel().getTSCT(reqObj: RequestGetTSCTModel(transaction_id: id), type: Constants.TSCT_GET_APPLICANT ){ result in
            isLoading.toggle()
            switch result {
            case .success(let response):
                data = response
                print("Success",response)
                
            case .failure(let error):
                print("Error \(error)")
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
                        Text(data?.type! ?? "")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.darkred)
                            .padding(.horizontal, 11)
                            .frame(height: 19)
                            .background(Color.darkred.opacity(0.15), alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20).stroke(Color.darkred, lineWidth: 1)
                            )
                    }
                    
                    Text(data?.title! ?? "")
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
                    
                    Text(verbatim:"ห่างจากฉัน: 3 กิโลเมตร")
                        .font(Font.custom("SukhumvitSet-Medium", size: 14))
                        .textContentType(.none)
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
                    Text(data?.detail! ?? "")
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
                
            }){
                Text(data?.isAccepted ?? false  ? "รับมอบหมาย" : "ไม่สามารถรับมอบหมาย")
//                Text("รับมอบหมาย")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)

            Spacer()
        }
        .frame(width:UIScreen.main.bounds.width-40)
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        .onAppear{
            fetchDetail()
            print("isAccepted = ",data?.isAccepted!)
        }
        }
        }
    }
}

//struct GiverDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        GiverDetailPage(showingSheet: .constant(true), data: )
//    }
//}
