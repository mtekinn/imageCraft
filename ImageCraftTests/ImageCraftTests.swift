import XCTest
@testable import ImageCraft

class ImageProcessorTests: XCTestCase {
    var imageProcessor: ImageProcessor!
    var testImage: UIImage!

    override func setUp() {
        super.setUp()
        imageProcessor = ImageProcessor()
        testImage = UIImage(named: "TestImage")! // Replace with your test image
    }

    override func tearDown() {
        imageProcessor = nil
        testImage = nil
        super.tearDown()
    }

    func testBrightnessAdjustment() {
        let adjustedImage = imageProcessor.adjustBrightness(of: testImage, to: 0.5)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testContrastAdjustment() {
        let adjustedImage = imageProcessor.adjustContrast(of: testImage, to: 1.5)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testSaturationAdjustment() {
        let adjustedImage = imageProcessor.adjustSaturation(of: testImage, to: 1.5)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testApplyVignette() {
        let adjustedImage = imageProcessor.applyVignette(inputImage: testImage, intensity: 1.0, radius: 1.0)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testApplySepiaTone() {
        let adjustedImage = imageProcessor.applySepiaTone(inputImage: testImage, intensity: 1.0)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testInvertColors() {
        let adjustedImage = imageProcessor.invertColors(of: testImage)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testConvertToGrayscale() {
        let adjustedImage = imageProcessor.convertToGrayscale(inputImage: testImage)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testRotateImage() {
        let adjustedImage = imageProcessor.rotate(image: testImage, by: 90)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testCropImage() {
        let cropRect = CGRect(x: 50, y: 50, width: 200, height: 200)
        let adjustedImage = imageProcessor.crop(image: testImage, to: cropRect)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testFlipImageHorizontally() {
        let adjustedImage = imageProcessor.flip(image: testImage, orientation: .upMirrored)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testFlipImageVertically() {
        let adjustedImage = imageProcessor.flip(image: testImage, orientation: .downMirrored)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }

    func testApplyFilter() {
        let adjustedImage = imageProcessor.applyFilter(to: testImage, filterType: FilterType.sepia)
        XCTAssertNotNil(adjustedImage)
        XCTAssertNotEqual(testImage, adjustedImage)
    }
}
