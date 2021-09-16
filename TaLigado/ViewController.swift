//
//  ViewController.swift
//  TaLigado
//
//  Created by Marcos Chevis on 10/09/21.
//
import Accelerate
import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var but: UIButton = {
        let but = UIButton(frame: .zero)
        view.addSubview(but)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        but.titleLabel?.text = "botao"
        
       
        
        but.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        but.backgroundColor = .blue
        
        
        return but
    }()
    
    lazy var label: UILabel = {
        let label = UILabel(frame: .zero)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Photo"
        
        but.titleLabel?.text = "botao"
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        
        setupConstraints()
        
    }
    
    func setupConstraints() {
        
        but.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        but.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        but.heightAnchor.constraint(equalToConstant: 100).isActive = true
        but.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: but.bottomAnchor, constant: 32).isActive = true
    }
    
    @objc func takePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            
            
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let (binZero, binOne, binTwo, _) = histogram(image: pickedImage)
            let contador:UInt = (binZero[binZero.count-1] + binOne[binZero.count-1] + binTwo[binZero.count-1])/3
                
            label.text = String(contador)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func identifyLight(img: UIImage) {
        
        
        let handler = VNImageRequestHandler(cgImage: img.cgImage!)
        
        let request = VNClassifyImageRequest()
        try? handler.perform([request])
        guard let unfilteredObservations = request.results as? [VNClassificationObservation] else { return }
        
        var observation: VNClassificationObservation?
        
        for obs in unfilteredObservations {
            if obs.identifier == "light" {
                observation = obs
            }
        }
        
        guard let obs = observation else { return }
        
        
        
        let title = obs.identifier
        let number = obs.confidence
        
        print(title, number)
        
        label.text = title + " " + number.description
    }


    /// Get histograms for R, G, B, A channels of UIImage
    /// https://stackoverflow.com/questions/37818720/swift-2-2-count-black-pixels-in-uiimage
    /// https://stackoverflow.com/questions/40562889/drawing-histogram-of-cgimage-in-swift-3
    /// https://developer.apple.com/documentation/accelerate/specifying_histograms_with_vimage
    func histogram(image: UIImage) -> (red: [UInt], green: [UInt], blue: [UInt], alpha: [UInt]) {
        let img: CGImage = CIImage(image: image)!.cgImage!

        let imgProvider: CGDataProvider = img.dataProvider!
        let imgBitmapData: CFData = imgProvider.data!
        var imgBuffer = vImage_Buffer(
            data: UnsafeMutableRawPointer(mutating: CFDataGetBytePtr(imgBitmapData)),
            height: vImagePixelCount(img.height),
            width: vImagePixelCount(img.width),
            rowBytes: img.bytesPerRow)

        // bins: zero = red, green = one, blue = two, alpha = three
        var binZero = [vImagePixelCount](repeating: 0, count: 256)
        var binOne = [vImagePixelCount](repeating: 0, count: 256)
        var binTwo = [vImagePixelCount](repeating: 0, count: 256)
        var binThree = [vImagePixelCount](repeating: 0, count: 256)
        
        binZero.withUnsafeMutableBufferPointer { zeroPtr in
            binOne.withUnsafeMutableBufferPointer { onePtr in
                binTwo.withUnsafeMutableBufferPointer { twoPtr in
                    binThree.withUnsafeMutableBufferPointer { threePtr in
                        
                        var histogramBins = [zeroPtr.baseAddress, onePtr.baseAddress,
                                             twoPtr.baseAddress, threePtr.baseAddress]
                        
                        histogramBins.withUnsafeMutableBufferPointer {
                            histogramBinsPtr in
                            let error = vImageHistogramCalculation_ARGB8888(
                                &imgBuffer,
                                histogramBinsPtr.baseAddress!,
                                vImage_Flags(kvImageNoFlags))
                            
                            guard error == kvImageNoError else {
                                fatalError("Error calculating histogram: \(error)")
                            }
                        }
                    }
                }
            }
        }
        
        return (binZero, binOne, binTwo, binThree)
    }
    
}

