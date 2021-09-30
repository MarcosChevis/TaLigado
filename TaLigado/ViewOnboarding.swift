//
//  ViewOnboarding.swift
//  TaLigado
//
//  Created by Vitor Cheung on 29/09/21.
//

import Foundation
import UIKit
class ViewOnboarding:UIView{
    
    
    let labelTitulo = UILabel()
    let label = UILabel()
    var imageName = String()
    lazy var image = UIImage(named: imageName)
    lazy var imageView = UIImageView(image: image!)
    
    func setup(titulo:String,text:String,imageName:String){
        
        labelTitulo.text=titulo
        labelTitulo.textAlignment = .center
        labelTitulo.font = UIFont .boldSystemFont(ofSize:  30.0)
        labelTitulo.textColor = UIColor(named: "corGelinho")
        self.addSubview(labelTitulo)
        
        label.text = text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont .boldSystemFont(ofSize: 19.0)
        self.addSubview(label)
        label.textColor = UIColor(named: "corGelinho")
        
        self.imageName = imageName
        self.addSubview(imageView)
        setupConstrainstsOnbarding()
        
    }
    
    
    func setupConstrainstsOnbarding(){
        
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        let labelTituloConstraints:[NSLayoutConstraint] = [
            labelTitulo.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            labelTitulo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            labelTitulo.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(labelTituloConstraints)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints:[NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor,constant: 40),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imgConstrainsts:[NSLayoutConstraint] = [
            imageView.widthAnchor.constraint(equalToConstant: 250),
            imageView.heightAnchor.constraint(equalToConstant: 200),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 50)
        ]
        NSLayoutConstraint.activate(imgConstrainsts)
        
        
    }
    
//    func setupImageView(width: CGFloat, higth: CGFloat){
//        let imgConstrainsts:[NSLayoutConstraint] = [
//            imageView.widthAnchor.constraint(equalToConstant: width),
//            imageView.heightAnchor.constraint(equalToConstant: higth),
//            ]
//        NSLayoutConstraint.activate(imgConstrainsts)
//    }
    
}
