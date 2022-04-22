//
//  RefreshableScrollView.swift
//  FSUIComponents
//
//  Created by Lyt on 1/8/21.
//

import Foundation
import SwiftUI

struct ScrollViewDragOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

public struct RefreshableScrollView<Content>: View where Content: View {
    
    @State private var fillPoint:Double = 0.0
    @State private var rotationDegree:Double = 0
    
    private var animation: Animation {
        Animation.linear(duration: 2).repeatForever(autoreverses: false)
    }

    @Environment(\.colorScheme)
    private var colorScheme

    private let pullThreshold: CGFloat = -40

    @State
    private var readyForNextPull = true

    @State
    private var dragTransitionHeight: CGFloat = 0 {
        didSet {
            if !isLoading, dragTransitionHeight < pullThreshold, readyForNextPull {
                readyForNextPull = false
                isLoading = true
                onRefresh()
                return
            }

            if isLoading, dragTransitionHeight > pullThreshold {
                withAnimation(.easeOut) {
                    scrollViewOffset = -pullThreshold
                }
            }

            if dragTransitionHeight == 0 {
                readyForNextPull = true
            }
        }
    }

    @State
    private var scrollViewOffset: CGFloat = 0

    private let content: Content

    @Binding
    private var isLoading: Bool

    private var onRefresh: () -> Void

    public init(isLoading: Binding<Bool>,
                onRefresh: @escaping () -> Void,
                @ViewBuilder content: @escaping () -> Content) {
        self._isLoading = isLoading
        self.content = content()
        self.onRefresh = onRefresh
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Ring2(fillPoint: fillPoint)
                .stroke(Color.darkred, lineWidth: 3)
                .frame(width: 30, height: 30)
                .opacity(dragTransitionHeight > 0 ? 0.0 : 1.0)
                .rotationEffect(.degrees(rotationDegree))
                .onAppear() {
                    withAnimation (self.animation){
                        rotationDegree = 360
                        self.fillPoint = 1
                    }
                }
            if isLoading {
                
//                ProgressView()
//                    .padding()
//                    .opacity(dragTransitionHeight > 0 ? 0.0 : 1.0)
                
            } else {
//                Image(systemName: "arrow.clockwise.circle")
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .rotationEffect(Angle(degrees: Double(-2 * dragTransitionHeight)))
//                    .padding()
//                    .opacity(dragTransitionHeight > 0 ? 0.0 : 1.0)
            }

            GeometryReader { outsideProxy in
                ScrollView {
                    VStack {
                        GeometryReader { insideProxy in
                            Color.clear
                                .preference(key: ScrollViewDragOffsetPreferenceKey.self,
                                            value: outsideProxy.frame(in: .global).minY+10 - insideProxy.frame(in: .global).minY)
                        }
                        .onPreferenceChange(ScrollViewDragOffsetPreferenceKey.self) { newValue in
                            dragTransitionHeight = newValue
                        }

                        content

                        Spacer()
                    }
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .offset(x: 0, y: scrollViewOffset)
                    .onChange(of: isLoading, perform: { _ in
                        if !isLoading {
                            withAnimation {
                                scrollViewOffset = 0
                            }
                        }
                    })
                }
            }
        }
    }
}

struct RefreshableScrollViewDemoView: View {

    @State private var isLoading: Bool = false

    var body: some View {
        NavigationView {
            RefreshableScrollView(isLoading: $isLoading,
                                  onRefresh: {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.isLoading = false
                                    }
                                  },
                                  content: {
                                    Text("123 \(isLoading.description)")
                                        .frame(maxHeight: .infinity)
                                  })
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Nav Title")
        }
    }
}

struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollViewDemoView()
    }
}

struct Ring2: Shape {
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

