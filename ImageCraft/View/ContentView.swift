import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @StateObject private var viewModel = CameraViewModel()
    @State private var selectedFilterIndex: Int? = nil

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    // Arka planı dinamik olarak güncelle
                    BackgroundView(imageSelected: viewModel.image != nil)

                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Text("Please select an image to edit")
                            .foregroundColor(.white)
                            .italic()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Picker("Select Filter", selection: $selectedFilterIndex) {
                    Text("Original").tag(nil as Int?)
                    ForEach(FilterType.allCases.indices, id: \.self) { index in
                        Text(FilterType.allCases[index].displayName).tag(index as Int?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .onChange(of: selectedFilterIndex) { newIndex in
                    if let newIndex = newIndex {
                        let filterType = FilterType.allCases[newIndex]
                        viewModel.applyFilter(filterType)
                    } else {
                        viewModel.applyFilter(.none)
                    }
                }

                SourceButtonsView(viewModel: viewModel)
            }
            .navigationTitle("ImageCraft")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.shareImage()
                    }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

// Dinamik arka plan görünümü
struct BackgroundView: View {
    var imageSelected: Bool
    
    var body: some View {
        Group {
            if imageSelected {
                Color.white
            } else {
                RadialGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), center: .center, startRadius: 20, endRadius: 500)
            }
        }
        .ignoresSafeArea()
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
    @State private var selectedFilter: FilterType? = .none
    
    let filterButtonWidth: CGFloat = 100
    let filterButtonHeight: CGFloat = 40
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(FilterType.allCases, id: \.self) { filterType in
                    Button(action: {
                        withAnimation {
                            selectedFilter = filterType
                            viewModel.applyFilter(filterType)
                        }
                    }) {
                        Text(filterType.displayName)
                            .frame(width: filterButtonWidth, height: filterButtonHeight)
                            .foregroundColor(.white)
                            .background(selectedFilter == filterType ? Color.blue : Color.gray)
                            .cornerRadius(filterButtonHeight / 2)
                            .scaleEffect(selectedFilter == filterType ? 1.2 : 1)
                            .opacity(selectedFilter == filterType ? 1 : 0.7)
                    }
                }
            }
            .padding(.horizontal)
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
