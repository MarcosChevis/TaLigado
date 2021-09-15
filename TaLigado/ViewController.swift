//
//  ViewController.swift
//  TaLigado
//
//  Created by Marcos Chevis on 10/09/21.
//

import UIKit
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var but: UIButton = {
        let but = UIButton(frame: .zero)
        but.translatesAutoresizingMaskIntoConstraints = false
        
        but.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        but.backgroundColor = .blue

        
        return but
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        
        view.addSubview(but)
        but.titleLabel?.text = "botao"
        
        but.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        but.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        but.heightAnchor.constraint(equalToConstant: 100).isActive = true
        but.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
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
            identifyLight(img: pickedImage)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func identifyLight(img: UIImage) {
        
        
        let handler = VNImageRequestHandler(cgImage: img.cgImage!)

        let request = VNClassifyImageRequest()
        try? handler.perform([request])
        let observations = request.results as? [VNClassificationObservation]
        for obs in observations! {
            if obs.confidence > 0.01 {
                print(obs.identifier, obs.confidence)
            }
        }
        //print(request.results?.debugDescription)
    }
    
}

