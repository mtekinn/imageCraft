import SwiftUI
import UIKit

class CameraViewModel: ObservableObject {
    
    @Published var image: UIImage?
    @Published var isShareSheetShowing = false
    @Published var isCameraViewShowing = false
    @Published var isPhotoLibraryViewShowing = false
    @Published var isCameraPresented = false
    @Published var isPhotoLibraryPresented = false
    @Published var sourceType: UIImagePickerController.SourceType?
    @Published var brightness = 0.0
    @Published var contrast = 0.0
    @Published var saturation = 0.0
    @Published var sepiaToneIntensity = 0.0
    @Published var vignetteIntensity = 0.0
    @Published var vignetteRadius = 0.0
    
    let imageProcessor = ImageProcessor()
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            isCameraPresented = true
        } else {
            print("Camera not available")
        }
    }

    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            isPhotoLibraryPresented = true
        } else {
            print("Photo Library not available")
        }
    }
    
    func handlePickedImage(_ pickedImage: UIImage) {
        let croppedImage = imageProcessor.cropToBounds(image: pickedImage, width: 600, height: 800) // 4:3 aspect ratio
        self.image = croppedImage
    }
    
    func applyFilter(_ filterType: FilterType) {
        guard let image = image else { return }
        self.image = imageProcessor.applyFilter(to: image, filterType: filterType)
    }
    
    func adjustBrightness(_ brightness: Float) {
        guard let image = image else { return }
        self.image = imageProcessor.adjustBrightness(of: image, to: brightness)
    }
    
    func adjustContrast(_ contrast: Float) {
        guard let image = image else { return }
        self.image = imageProcessor.adjustContrast(of: image, to: contrast)
    }
    
    func adjustSaturation(_ saturation: Float) {
        guard let image = image else { return }
        self.image = imageProcessor.adjustSaturation(of: image, to: saturation)
    }
    
    func invertColors() {
        guard let image = image else { return }
        self.image = imageProcessor.invertColors(of: image)
    }
    
    func convertToGrayscale() {
        guard let image = image else { return }
        self.image = imageProcessor.convertToGrayscale(inputImage: image)
    }
    
    func applySepiaTone(intensity: Double) {
        guard let image = image else { return }
        self.image = imageProcessor.applySepiaTone(inputImage: image, intensity: intensity)
    }
    
    func applyVignette(intensity: Double, radius: Double) {
        guard let image = image else { return }
        self.image = imageProcessor.applyVignette(inputImage: image, intensity: intensity, radius: radius)
    }
    
    func rotateImage(_ degrees: CGFloat) {
        guard let image = image else { return }
        self.image = imageProcessor.rotate(image: image, by: degrees)
    }
    
    func cropImage(to rect: CGRect) {
        guard let image = image else { return }
        self.image = imageProcessor.crop(image: image, to: rect)
    }
    
    func flipImageHorizontally() {
        guard let image = image else { return }
        self.image = imageProcessor.flip(image: image, orientation: .upMirrored)
    }
    
    func flipImageVertically() {
        guard let image = image else { return }
        self.image = imageProcessor.flip(image: image, orientation: .downMirrored)
    }
    
    func shareImage() {
        guard let image = image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func saveImage() {
        guard let image = image else { return }
        imageProcessor.save(image: image)
    }
}
