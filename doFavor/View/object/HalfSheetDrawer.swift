//
//  HalfSheetDrawer.swift
//  doFavor
//
//  Created by Khing Thananut on 25/3/2565 BE.
//

import SwiftUI

extension View{
    
    func halfSheet<SheetView: View>(isPresented: Binding<Bool>,@ViewBuilder sheetView: @escaping ()->SheetView,onEnd: @escaping ()->()) ->some View{
        
        //
        return self
            .background(
                HalfSheetHelper(sheetView: sheetView(), isPresented: isPresented, onEnd: onEnd)
            )
    }
}

struct HalfSheetHelper<SheetView: View>: UIViewControllerRepresentable{
    var sheetView: SheetView
    @Binding var isPresented: Bool
    var onEnd: ()->()
    
    let controller = UIViewController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        controller.view.backgroundColor = .clear
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        if isPresented{
            let sheetController = CustomHostingController(rootView: sheetView)
            sheetController.presentationController?.delegate = context.coordinator
            uiViewController.present(sheetController, animated: true)
            
        }else{
            uiViewController.dismiss(animated: true)
        }
    }
    
    class Coordinator: NSObject, UISheetPresentationControllerDelegate{
        var parent: HalfSheetHelper
        
        init(parent: HalfSheetHelper){
            self.parent = parent
        }
        
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            parent.onEnd()
        }
    }
}

class CustomHostingController<Content: View>: UIHostingController<Content>{
    
    override func viewDidLoad() {
        
//        view.backgroundColor = .clear
        
        if #available(iOS 15.0, *) {
            if let presentationController = presentationController as? UISheetPresentationController{
                presentationController.detents = [
                    .medium(),
                    .large()
                ]
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

//https://www.youtube.com/watch?v=YJwhzOijwwI
