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
            identifyLight(img: pickedImage)
            
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
    
}

