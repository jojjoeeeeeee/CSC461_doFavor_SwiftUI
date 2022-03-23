//
//  doFavorActivityIndicator.swift
//  doFavorUItest
//
//  Created by Phakkharachate on 23/3/2565 BE.
//

import SwiftUI

struct doFavorActivityIndicatorView<Content>: View where Content: View {
    var isLoading: Bool
    var isPage: Bool
    var content: () -> Content
    @State private var fillPoint:Double = 0.0
    @State private var rotationDegree:Double = 0
    
    private var animation: Animation {
        Animation.linear(duration: 2).repeatForever(autoreverses: false)
    }
    
    var body: some View {
        if isPage {
            GeometryReader { geometry in
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
                    .frame(width: UIScreen.main.bounds.width,
                           height: UIScreen.main.bounds.height)
                    .background(Color.black.opacity(self.isLoading ? 0.1 : 0))
                    .ignoresSafeArea()
                    .opacity(self.isLoading ? 1 : 0)
                }
            }
        }
        else {
            GeometryReader { geometry in
                ZStack(alignment: .center) {
                    self.content()
                        .disabled(self.isLoading)
                    VStack {
                        Ring(fillPoint: fillPoint)
                            .stroke(Color.darkred, lineWidth: 10)
                            .frame(width: 50, height: 50)
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
//                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(self.isLoading ? 1 : 0)
                }
            }
            
        }
    }
}

struct Ring: Shape {
    var fillPoint: Double
    var delayPoint: Double = 0.5
    
    var animatableData : Double {
        get { return fillPoint }
        set { fillPoint = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var start:Double
        let end = 360 * fillPoint
        
        if fillPoint > delayPoint {
            start = (2*fillPoint) * 360
        }
        else {
            start = 0
        }
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.size.width/2, y: rect.size.height/2),
                    radius: rect.size.width/2,
                    startAngle: .degrees(start),
                    endAngle: .degrees(end),
                    clockwise: false)
        return path
    }
}
