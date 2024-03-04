import SwiftUI
import UIKit

// A SwiftUI view that represents a UIImagePickerController
struct CameraView: UIViewControllerRepresentable {
    var handlePickedImage: (UIImage) -> Void
    var sourceType: UIImagePickerController.SourceType

    // The coordinator handles the interaction with the UIImagePickerController
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var handlePickedImage: (UIImage) -> Void

        init(handlePickedImage: @escaping (UIImage) -> Void) {
            self.handlePickedImage = handlePickedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Safely unwrap the selected image
            guard let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                print("No image was selected")
                return
            }
            
            handlePickedImage(uiImage)
            picker.dismiss(animated: true, completion: nil)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(handlePickedImage: handlePickedImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraView>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraView>) {
        // Nothing to update
    }
}
