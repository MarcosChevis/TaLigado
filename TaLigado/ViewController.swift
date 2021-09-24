//
//  ViewController.swift
//  TaLigado
//
//  Created by Marcos Chevis on 10/09/21.
//


import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    private lazy var previewView: UIView = view
    
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAVCapture()
        setupConstraints()
    }
    
    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .hd1920x1080 // Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = previewView.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    //MARK: -Elementos
    
    //botão
    lazy var butaoQuestion: UIButton = {
        let buttonTemp = UIButton()
        buttonTemp.backgroundColor = UIColor(named: "corAzul")
    
        //primeiro seta uma configuração
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)

        //adicionado qual a imagem - SF Symbol - com a figuração criada acima
         let largeBoldDoc = UIImage(systemName: "questionmark.circle.fill", withConfiguration: largeConfig)

        //no final que voce está colocando realmente a imagem
        buttonTemp.setImage(largeBoldDoc, for: .normal)
        
        //Cor dos botão
        buttonTemp.tintColor = UIColor(named: "corGelinho")
        
        buttonTemp.layer.cornerRadius = 31
        
        buttonTemp.addTarget(self, action: #selector(callForOnBoarding), for: .touchUpInside)
        
        return buttonTemp
    }()
    
    //Switch
    lazy var switchVibracao: UISwitch = {
        let switchTemp = UISwitch()
        
        //Cor dos botão
        switchTemp.tintColor = UIColor(named: "corGelinho")
        
        switchTemp.tintColor = UIColor(named: "corGelinho"); // the "off" color
        switchTemp.onTintColor = UIColor(named: "corLaranja"); // the "on" color
        
        return switchTemp
    }()
    
    //labels
    lazy var labelVibracao: UILabel = {
        let labelTemp = UILabel()
        labelTemp.backgroundColor = UIColor(named: "corAzul")
        
        //Cor dos botão
        labelTemp.tintColor = UIColor(named: "corGelinho")
        
        labelTemp.font = UIFont.boldSystemFont(ofSize: 16.0)
        labelTemp.text = "    Modo de Vibração "
        
        labelTemp.layer.masksToBounds = true
        labelTemp.layer.cornerRadius = 31
        return labelTemp
    }()
    
    lazy var labelEstado: UILabel = {
        let labelTemp = UILabel()
        labelTemp.backgroundColor = UIColor(named: "corAzul")
        
        //Cor dos botão
        labelTemp.tintColor = UIColor(named: "corGelinho")
        
        return labelTemp
    }()
    
    //MARK: -Constraints
    func setupConstraints(){
        
        let alturaInferiror:CGFloat = 62
        //Botao de duvidas
        butaoQuestion.translatesAutoresizingMaskIntoConstraints = false
        previewView.addSubview(butaoQuestion)
        let butaoQuestionConstraints:[NSLayoutConstraint] = [
            butaoQuestion.widthAnchor.constraint(equalToConstant: alturaInferiror),
            butaoQuestion.heightAnchor.constraint(equalToConstant: alturaInferiror),
            butaoQuestion.trailingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.trailingAnchor,constant: -35),
            butaoQuestion.bottomAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(butaoQuestionConstraints)
        
        labelVibracao.translatesAutoresizingMaskIntoConstraints = false
        
        previewView.addSubview(labelVibracao)
        let labelVibracaoConstraints:[NSLayoutConstraint] = [
            labelVibracao.heightAnchor.constraint(equalToConstant: alturaInferiror),
            labelVibracao.leadingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.leadingAnchor,constant: 25),
            labelVibracao.trailingAnchor.constraint(equalTo: butaoQuestion.leadingAnchor,constant: -15),
            labelVibracao.bottomAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(labelVibracaoConstraints)
        
        labelEstado.translatesAutoresizingMaskIntoConstraints = false
        
        
        //Switch Vibracao
        switchVibracao.translatesAutoresizingMaskIntoConstraints = false
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = (alturaInferiror-20)/standardHeight
        let widthRatio = ((alturaInferiror-20)*standardWidth/standardHeight)/standardWidth

        switchVibracao.transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        
        previewView.addSubview(switchVibracao)
        let switchVibracaoConstraints:[NSLayoutConstraint] = [
            switchVibracao.widthAnchor.constraint(equalToConstant: 30),
            switchVibracao.heightAnchor.constraint(equalToConstant: 30),
            switchVibracao.trailingAnchor.constraint(equalTo: labelVibracao.trailingAnchor,constant: -switchVibracao.frame.width/2-10),
            switchVibracao.centerYAnchor.constraint(equalTo: labelVibracao.centerYAnchor)
        ]
        NSLayoutConstraint.activate(switchVibracaoConstraints)
        
        previewView.addSubview(labelEstado)
        let labelEstadoConstraints:[NSLayoutConstraint] = [
            labelEstado.heightAnchor.constraint(equalToConstant: alturaInferiror),
            labelEstado.leadingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.leadingAnchor),
            labelEstado.trailingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.trailingAnchor),
            labelEstado.centerYAnchor.constraint(equalTo: previewView.centerYAnchor,constant: 150)
        ]
        NSLayoutConstraint.activate(labelEstadoConstraints)

        
    }
    
    @objc
    func callForOnBoarding(){
        let vc = ViewControllerOnBoarding(nibName: nibName, bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: -Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: -Used in Subclass
    func startCaptureSession() {
        session.startRunning()
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // to be implemented in the subclass
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didDrop didDropSampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // print("frame dropped")
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
