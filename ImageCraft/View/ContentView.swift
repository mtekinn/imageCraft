import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    
    var body: some View {
        VStack {
            // Limit the height of the image to a fraction of the total available height
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.main.bounds.height / 3)
            } else {
                Text("No Image")
            }
            
            SourceButtonsView(viewModel: viewModel)
            
            if viewModel.image != nil {
                TabView {
                    ImageAdjustmentsView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "slider.horizontal.3")
                            Text("Adjustments")
                        }
                    
                    ImageEffectsView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "wand.and.stars")
                            Text("Effects")
                        }
                    
                    ImageTransformationsView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "arrow.rotate.right")
                            Text("Transformations")
                        }
                    
                    ImageFiltersView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "camera.filters")
                            Text("Filters")
                        }
                    
                    ImageActionsView(viewModel: viewModel)
                        .tabItem {
                            Image(systemName: "square.and.arrow.up")
                            Text("Actions")
                        }
                }
            }
        }
    }
}

struct SourceButtonsView: View {
    @ObservedObject var viewModel: CameraViewModel

    var body: some View {
        Section(header: Text("Source")) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Open Camera") {
                    viewModel.openCamera()
                }
                .sheet(isPresented: $viewModel.isCameraPresented) {
                    ImagePicker(sourceType: .camera, selectedImage: $viewModel.image, isPresented: $viewModel.isCameraPresented)
                }
            } else {
                Text("Camera not available")
            }

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                Button("Open Photo Library") {
                    viewModel.openPhotoLibrary()
                }
                .sheet(isPresented: $viewModel.isPhotoLibraryPresented) {
                    ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.image, isPresented: $viewModel.isPhotoLibraryPresented)
                }
            } else {
                Text("Photo Library not available")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

struct ImageAdjustmentsView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            Slider(value: $viewModel.brightness, in: -1.0...1.0, step: 0.1) {
                Text("Brightness")
            }
            Slider(value: $viewModel.contrast, in: 0.0...4.0, step: 0.1) {
                Text("Contrast")
            }
            Slider(value: $viewModel.saturation, in: 0.0...2.0, step: 0.1) {
                Text("Saturation")
            }
        }
    }
}

struct ImageEffectsView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            Button("Apply Vignette") {
                viewModel.applyVignette(intensity: viewModel.vignetteIntensity, radius: viewModel.vignetteRadius)
            }
            Button("Apply Sepia Tone") {
                viewModel.applySepiaTone(intensity: viewModel.sepiaToneIntensity)
            }
            Button("Invert Colors") {
                viewModel.invertColors()
            }
            Button("Convert to Grayscale") {
                viewModel.convertToGrayscale()
            }
        }
    }
}

struct ImageTransformationsView: View {
    @ObservedObject var viewModel: CameraViewModel
    @State private var cropRect = CGRect(x: 50, y: 50, width: 200, height: 200)
    
    var body: some View {
        VStack {
            Button("Rotate Image") {
                viewModel.rotateImage(90) // rotates the image 90 degrees
            }
            Button("Crop Image") {
                viewModel.cropImage(to: cropRect)
            }
            Button("Flip Image Horizontally") {
                viewModel.flipImageHorizontally()
            }
            Button("Flip Image Vertically") {
                viewModel.flipImageVertically()
            }
        }
    }
}

struct ImageFiltersView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            Button("Apply Sepia Filter") {
                viewModel.applyFilter(.sepia)
            }
            Button("Apply Noir Filter") {
                viewModel.applyFilter(.noir)
            }
            Button("Apply Comic Filter") {
                viewModel.applyFilter(.comic)
            }
        }
    }
}

struct ImageActionsView: View {
    @ObservedObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack {
            Button("Save Image") {
                viewModel.saveImage()
            }
            Button("Share Image") {
                viewModel.shareImage()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
