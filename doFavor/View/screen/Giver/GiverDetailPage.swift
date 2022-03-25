//
//  GiverDetailPage.swift
//  doFavor
//
//  Created by Khing Thananut on 24/3/2565 BE.
//

import SwiftUI

struct GiverDetailPage: View {
    @Binding var showingSheet: Bool
    
    var body: some View {
        VStack(spacing:27){
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
                        Text("food")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(Color.darkred)
                            .padding(.horizontal, 11)
                            .frame(height: 19)
                            .background(Color.darkred.opacity(0.15), alignment: .center)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20).stroke(Color.darkred, lineWidth: 1)
                            )
                    }
                    
                    Text("ร้านป้าต๋อย")
                        .font(Font.custom("SukhumvitSet-Bold", size: 18))

                    HStack{
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.darkred)

                        Text("ประตู 5 อาคารประดู่ไข่ดาว")
                            .font(Font.custom("SukhumvitSet-Bold", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(Color.darkred)
                    }
                    
                    Text(verbatim:"ห่างจากฉัน: 3 กิโลเมตร")
                        .font(Font.custom("SukhumvitSet-Medium", size: 14))
                        .textContentType(.none)
//                        .lineLimit(nil)


                    
//                    Spacer()
                }
                .frame(width:UIScreen.main.bounds.width*0.42-20)
                .fixedSize()
                .padding(.vertical,12)
                .padding(.trailing,12)

                Spacer()
            }
            .foregroundColor(Color.darkest)
//            .font(Font.custom("SukhumvitSet-Bold", size: 15).weight(.bold))
            .frame(width:UIScreen.main.bounds.width-40 ,height: UIScreen.main.bounds.width*0.42)
            .fixedSize()
//            .padding(12)
            
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
                    Text("หมูปิ้ง 2 ไม้ ")
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
            //Submit button
            Button(action: {
            }){
                Text("รับมอบหมาย")
                    .foregroundColor(Color.white)
                    .font(Font.custom("SukhumvitSet-Bold", size: 20).weight(.bold))

            }
            .frame(width:UIScreen.main.bounds.width-40, height: 50)
            .background(Color.darkred)
            .cornerRadius(15)

            Spacer()
        }
        .frame(width:UIScreen.main.bounds.width-40)

    }
}

struct GiverDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        GiverDetailPage(showingSheet: .constant(true))
    }
}
