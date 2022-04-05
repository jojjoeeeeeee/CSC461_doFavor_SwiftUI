//
//  GiverFilterSheet.swift
//  doFavor
//
//  Created by Khing Thananut on 25/3/2565 BE.
//

import SwiftUI

struct GiverFilterSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
        
            if isPresented {
                VStack {
                    Spacer()
                
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    self.isPresented = false
                                }
                            }) {
                                Text("done")
                                    .padding(.top, 5)
                            }
                        }
                    
                        sheetContent()
                    }
                    .padding()
                }
                .zIndex(.infinity)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

extension View {
    func customBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        sheetContent: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(GiverFilterSheet(isPresented: isPresented, sheetContent: sheetContent))
    }
}
