//
//  ImagePicker.swift
//  ObjectDetector
//
//  Created by Fabian Schneider on 19.06.22.
//

import SwiftUI

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let parent: ImagePicker
    init(_ parent: ImagePicker) {
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let uiImage = info[.originalImage] as? UIImage {
            parent.onDismiss(uiImage)
        }
        parent.presentationMode.wrappedValue.dismiss()
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    var onDismiss: (UIImage) -> Void
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

private struct ImagePickerSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    var onDismiss: (UIImage) -> Void
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                ImagePicker(onDismiss: onDismiss)
            }
    }
}

extension View {
    func imagePickerSheet(isPresented: Binding<Bool>, onDismiss: @escaping (UIImage) -> Void) -> some View {
        self.modifier(ImagePickerSheetModifier(isPresented: isPresented, onDismiss: onDismiss))
    }
}
