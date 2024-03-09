import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class ImageProcessor {
    let context = CIContext()
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func applyFilter(to inputImage: UIImage, filterType: FilterType) -> UIImage {
        guard let ciImage = CIImage(image: inputImage) else {
            return inputImage
        }
        
        var outputImage: CIImage?
        switch filterType {
        case .sepia:
            let sepiaFilter = CIFilter.sepiaTone()
            sepiaFilter.inputImage = ciImage
            sepiaFilter.intensity = 1.0
            outputImage = sepiaFilter.outputImage
        case .noir:
            let noirFilter = CIFilter.photoEffectNoir()
            noirFilter.inputImage = ciImage
            outputImage = noirFilter.outputImage
        case .comic:
            let comicFilter = CIFilter.comicEffect()
            comicFilter.inputImage = ciImage
            outputImage = comicFilter.outputImage
        case .oldFilm:
            let sepiaFilter = CIFilter.sepiaTone()
            sepiaFilter.inputImage = ciImage
            sepiaFilter.intensity = 0.8
            if let output = sepiaFilter.outputImage {
                let noiseFilter = CIFilter.noiseReduction()
                noiseFilter.inputImage = output
                noiseFilter.noiseLevel = 0.02
                outputImage = noiseFilter.outputImage
            }
        case .hdr:
            let toneCurveFilter = CIFilter.toneCurve()
            toneCurveFilter.inputImage = ciImage
            toneCurveFilter.point0 = CGPoint(x: 0.0, y: 0.0)
            toneCurveFilter.point1 = CGPoint(x: 0.25, y: 0.15)
            toneCurveFilter.point2 = CGPoint(x: 0.5, y: 0.5)
            toneCurveFilter.point3 = CGPoint(x: 0.75, y: 0.85)
            toneCurveFilter.point4 = CGPoint(x: 1.0, y: 1.0)
            outputImage = toneCurveFilter.outputImage
        case .bokeh:
            let blurFilter = CIFilter.gaussianBlur()
            blurFilter.inputImage = ciImage
            blurFilter.radius = 10
            outputImage = blurFilter.outputImage
        case .colorPop:
            let falseColorFilter = CIFilter.falseColor()
            falseColorFilter.inputImage = ciImage
            falseColorFilter.color0 = CIColor(color: UIColor.magenta)
            falseColorFilter.color1 = CIColor(color: UIColor.yellow)
            outputImage = falseColorFilter.outputImage
        case .dramaticShadows:
            let contrastFilter = CIFilter.colorControls()
            contrastFilter.inputImage = ciImage
            contrastFilter.contrast = 1.5
            outputImage = contrastFilter.outputImage

        default:
            outputImage = ciImage
        }
        
        guard let ciOutputImage = outputImage,
              let cgImage = context.createCGImage(ciOutputImage, from: ciOutputImage.extent) else {
            return inputImage
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    
    func adjustBrightness(of inputImage: UIImage, to brightness: Float) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.brightness = brightness

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func adjustContrast(of inputImage: UIImage, to contrast: Float) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.contrast = contrast

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func adjustSaturation(of inputImage: UIImage, to saturation: Float) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.colorControls()
        filter.inputImage = ciImage
        filter.saturation = saturation

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func invertColors(of inputImage: UIImage) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.colorInvert()
        filter.inputImage = ciImage

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func convertToGrayscale(inputImage: UIImage) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.photoEffectMono()
        filter.inputImage = ciImage

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func applySepiaTone(inputImage: UIImage, intensity: Double) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.sepiaTone()
        filter.inputImage = ciImage
        filter.intensity = Float(intensity)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func applyVignette(inputImage: UIImage, intensity: Double, radius: Double) -> UIImage {
        let ciImage = CIImage(image: inputImage)
        let filter = CIFilter.vignette()
        filter.inputImage = ciImage
        filter.intensity = Float(intensity)
        filter.radius = Float(radius)

        guard let outputImage = filter.outputImage,
              let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return inputImage
        }

        return UIImage(cgImage: cgImage)
    }
    
    func rotate(image: UIImage, by degrees: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(image.size)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context.rotate(by: degrees * CGFloat.pi / 180)
        image.draw(in: CGRect(x: -image.size.width / 2, y: -image.size.height / 2, width: image.size.width, height: image.size.height))
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return rotatedImage
    }
    
    func crop(image: UIImage, to rect: CGRect) -> UIImage {
        let cgImage = image.cgImage!.cropping(to: rect)!
        return UIImage(cgImage: cgImage)
    }
    
    func flip(image: UIImage, orientation: UIImage.Orientation) -> UIImage {
        return UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: orientation)
    }
    
    func share(image: UIImage, viewController: UIViewController) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    func save(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
