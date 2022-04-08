//
//  doFavorMainLoadingIndicator.swift
//  doFavor
//
//  Created by Phakkharachate on 7/4/2565 BE.
//



import SwiftUI

struct doFavorMainLoadingIndicatorView<Content>: View where Content: View {
    var isLoading: Bool 
    var content: () -> Content
    @State private var fillPoint:Double = 0.0
    @State private var rotationDegree:Double = 0
    
    private var animation: Animation {
        Animation.linear(duration: 2).repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            self.content()
                .disabled(self.isLoading)
                .blur(radius: self.isLoading ? 2 : 0)
            VStack {
                Ring(fillPoint: fillPoint)
                    .stroke(Color.darkred, lineWidth: 10)
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(rotationDegree))
                    .onAppear() {
                        DispatchQueue.main.async {
                            withAnimation (self.animation){
                                rotationDegree = 360
                                self.fillPoint = 1
                            }
                        }
                    }
                
            }
            .opacity(self.isLoading ? 1 : 0)
        }.overlay( GeometryReader(content: { geometry  in
            Color.black.opacity(self.isLoading ? 0.1 : 0).frame(width: geometry.size.width,
                                                                height: geometry.size.height+100)
            .ignoresSafeArea()
        })
        )
    }
}
