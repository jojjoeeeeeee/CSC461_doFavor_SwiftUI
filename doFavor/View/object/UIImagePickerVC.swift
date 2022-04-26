//
//  UIImagePickerVC.swift
//  doFavor
//
//  Created by Phakkharachate on 26/4/2565 BE.
//

import SwiftUI

struct UIImagePickerVC: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: Image?
    @Binding var data: Data?
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> UIImagePickerVC.Coordinator {
        return Coordinator(presentationMode: presentationMode, image: self.$image, data: self.$data)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var presentationMode: PresentationMode
        @Binding var image: Image?
        @Binding var data: Data?
        
        init(presentationMode: Binding<PresentationMode>, image: Binding<Image?>, data: Binding<Data?>) {
            _presentationMode = presentationMode
            _image = image
            _data = data
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let selectedImage = info[.originalImage] as! UIImage
            let orientationFixedImage = selectedImage.fixOrientation()
            data = orientationFixedImage.jpegData(compressionQuality: 1.0)
            image = Image(uiImage: self.resizeImage(image: selectedImage))
            presentationMode.dismiss()
        }
        
        func resizeImage(image: UIImage) -> UIImage {
            let scale = 300 / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: 300, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: 300, height: newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage!
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
    
    }
}

