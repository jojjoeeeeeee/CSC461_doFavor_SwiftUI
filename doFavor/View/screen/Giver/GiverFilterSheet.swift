//
//  GiverFilterSheet.swift
//  doFavor
//
//  Created by Khing Thananut on 25/3/2565 BE.
//

import SwiftUI

struct GiverFilterSheet: View {
    @Binding var showingSheet: Bool
    @Binding var isLatest: Bool
    @State var FilterTypeModel: [String] = ["food","grocery","drinks"] //use for creating ViewButton
    @Binding var FilterType: [String]
    


    
    var body: some View{
        
        VStack(alignment:.leading){
            HStack{
                Button(action: {
                    showingSheet.toggle()
                })
                {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color.init(red: 218/255, green: 218/255, blue: 218/255))
                        .padding(.top,30)
                }
                
                Spacer()
            }
            
            Text("ประเภท")
                .font(Font.custom("SukhumvitSet-Bold", size: 20))
            
            //type button
            HStack{
                ForEach(FilterTypeModel, id:\.self){ type in
                    
                    Button(action: {
                        if FilterType.contains(type){
                            FilterType.removeAll(where: {$0==type})
                        }else{
                            FilterType.append(type)
                        }
                    }){
                        Text(type)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(FilterType.contains(type) ? Color.darkred : Color.grey)
                            .padding(.horizontal, 21)
                            .frame(height: 33)
                            .background(FilterType.contains(type) ? Color.darkred.opacity(0.15) : Color.clear, alignment: .center)
                            .cornerRadius(33)
                            .overlay(
                                RoundedRectangle(cornerRadius: 33).stroke(FilterType.contains(type) ? Color.darkred : Color.grey, lineWidth: 1)
                            )
                    }
                }
            }
            //type button closure
            Text("การจัดเรียง")
                .font(Font.custom("SukhumvitSet-Bold", size: 20))
            //Sorting
            HStack{
                    Button(action: {
                        if isLatest{
                            print("isLatest",isLatest)
                        }else{
                            isLatest.toggle()
                        }
                    }){
                        Text("ล่าสุด")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17))
                            .foregroundColor(isLatest ? Color.darkred : Color.grey)
                            .padding(.horizontal, 21)
                            .frame(height: 33)
                            .background(isLatest ? Color.darkred.opacity(0.15) : Color.clear, alignment: .center)
                            .cornerRadius(33)
                            .overlay(
                                RoundedRectangle(cornerRadius: 33).stroke(isLatest ? Color.darkred : Color.grey, lineWidth: 1)
                            )
                    }
                if AppUtils.getUsrAddress() != nil {
                    Button(action: {
                        if isLatest{
                            isLatest.toggle()
                        }else{
                            print("isLatest",isLatest)
                        }
                    }){
                        Text("ใกล้ฉัน")
                            .font(Font.custom("SukhumvitSet-Bold", size: 17))
                            .foregroundColor(!isLatest ? Color.darkred : Color.grey)
                            .padding(.horizontal, 21)
                            .frame(height: 33)
                            .background(!isLatest ? Color.darkred.opacity(0.15) : Color.clear, alignment: .center)
                            .cornerRadius(33)
                            .overlay(
                                RoundedRectangle(cornerRadius: 33).stroke(!isLatest ? Color.darkred : Color.grey, lineWidth: 1)
                            )
                    }
                }

            }

        }
        .frame(width:UIScreen.main.bounds.width-40)
        
    }
}
