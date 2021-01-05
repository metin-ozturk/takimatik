//
//  ImagePickerView.swift
//  Takimatik
//
//  Created by Metin Öztürk on 26.07.2020.
//  Copyright © 2020 abplus. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePickerView : UIViewControllerRepresentable {
    
    @Binding var isBeingPresented : Bool

    @ObservedObject var createEventViewModel: CreateEventViewModel
    

    func updateUIViewController(_ uiViewController: ImagePickerView.UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.delegate = context.coordinator
        return controller
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        private let parent : ImagePickerView
        
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                DispatchQueue.main.async {
                    self.parent.createEventViewModel.selectedImage = selectedImage
                }
            }
            
            DispatchQueue.main.async {
                self.parent.isBeingPresented = false
            }
        }
    }
    
}
