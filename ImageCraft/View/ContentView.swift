import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins


struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var cropRect = CGRect(x: 50, y: 50, width: 200, height: 200)
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
            } else {
                Text("No Image")
            }
            
            List {
                Section(header: Text("Source")) {
                    Button("Open Camera") {
                        viewModel.openCamera()
                    }
                    Button("Open Photo Library") {
                        viewModel.openPhotoLibrary()
                    }
                }
                
                Section(header: Text("Adjustments")) {
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
                
                Section(header: Text("Effects")) {
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
                
                Section(header: Text("Transformations")) {
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
                
                Section(header: Text("Filters")) {
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
                
                Section(header: Text("Actions")) {
                    Button("Save Image") {
                        viewModel.saveImage()
                    }
                    Button("Share Image") {
                        viewModel.shareImage()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .disabled(viewModel.image == nil)
        }
    }
}


#Preview {
    ContentView()
}
