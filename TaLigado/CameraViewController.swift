//
//  ViewController.swift
//  TaLigado
//
//  Created by Marcos Chevis on 10/09/21.
//


import UIKit
import AVFoundation
import Vision

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var bufferSize: CGSize = .zero
    let InferiorCustomSafeArea: CGFloat = 62
    
    var defaults = UserDefaults.standard
    var rootLayer: CALayer! = nil
    
    var isVibrateActive: Bool = true
    
    private lazy var previewView: UIView = view
    
    private let session = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    
    //MARK: -UIElements
    //botão
    lazy var butaoQuestion: UIButton = {
        let buttonTemp = UIButton()
        buttonTemp.backgroundColor = UIColor(named: "corAzul")
        buttonTemp.translatesAutoresizingMaskIntoConstraints = false
    
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
    
    lazy var vibrationBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "corAzul")
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 32
        
        return view
    }()
    
    //Switch
    lazy var switchVibracao: UISwitch = {
        let switchTemp = UISwitch()
        
        //Cor dos botão
        switchTemp.tintColor = UIColor(named: "corGelinho")
        
        switchTemp.tintColor = UIColor(named: "corGelinho"); // the "off" color
        switchTemp.onTintColor = UIColor(named: "corLaranja"); // the "on" color
        
        switchTemp.translatesAutoresizingMaskIntoConstraints = false
        
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = (InferiorCustomSafeArea-20)/standardHeight
        let widthRatio = ((InferiorCustomSafeArea-20)*standardWidth/standardHeight)/standardWidth

        switchTemp.transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
        
        switchTemp.addTarget(self, action: #selector(updateisVibrateActive), for: .touchUpInside)
        

        
        return switchTemp
    }()
    
    //labels
    lazy var labelVibracao: UILabel = {
        let labelTemp = UILabel()
        labelTemp.backgroundColor = UIColor(named: "corAzul")
        labelTemp.translatesAutoresizingMaskIntoConstraints = false
        //Cor dos botão
        labelTemp.textColor = UIColor(named: "corGelinho")
        
        labelTemp.font = UIFont.boldSystemFont(ofSize: 16.0)
        labelTemp.text = "Modo de Vibração "
        
        return labelTemp
    }()
    
    lazy var labelEstado: UILabel = {
        let labelTemp = UILabel()
        labelTemp.backgroundColor = UIColor(named: "corAzul")
        labelTemp.translatesAutoresizingMaskIntoConstraints = false
        
        //Cor dos botão
        labelTemp.textColor = UIColor(named: "corGelinho")
        labelTemp.font = UIFont.boldSystemFont(ofSize: 20.0)
        
        labelTemp.textAlignment = .center
        
        labelTemp.text = "À procura da luz"
        
        //Enum
//        var estado = TextoLabelEstados.procurando
//
//        switch estado{
//        case .ligado:
//            labelEstado.text = "A luz está ligada"
//        case .desligado:
//            labelEstado.text = "A luz está desligada"
//        case .procurando:
//            labelEstado.text =  "À procura da luz"
//
//        }
        
        return labelTemp
    }()
    
    //MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupAVCapture()
        setupConstraints()
        getVibrationState()
        setupVoiceOver()
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
    
    
    
    //MARK: -Constraints
    func setupConstraints(){
        
        previewView.addSubview(labelEstado)
        previewView.addSubview(vibrationBackgroundView)
        vibrationBackgroundView.addSubview(labelVibracao)
        vibrationBackgroundView.addSubview(switchVibracao)
        previewView.addSubview(butaoQuestion)
        
        //labelEstado
        let labelEstadoConstraints:[NSLayoutConstraint] = [
            labelEstado.heightAnchor.constraint(equalToConstant: InferiorCustomSafeArea),
            labelEstado.leadingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.leadingAnchor),
            labelEstado.trailingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.trailingAnchor),
            labelEstado.centerYAnchor.constraint(equalTo: previewView.centerYAnchor,constant: 150)
        ]
        NSLayoutConstraint.activate(labelEstadoConstraints)
        
        //BackgroundVibracao
        let vibrationBackgroundViewConstraints: [NSLayoutConstraint] = [
            vibrationBackgroundView.bottomAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.bottomAnchor),
            vibrationBackgroundView.leadingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.leadingAnchor, constant: 35),
            vibrationBackgroundView.trailingAnchor.constraint(equalTo: butaoQuestion.leadingAnchor, constant: -8),
            vibrationBackgroundView.heightAnchor.constraint(equalToConstant: InferiorCustomSafeArea)
            
        ]
        NSLayoutConstraint.activate(vibrationBackgroundViewConstraints)
        
        //LabelVibracao
        let labelVibracaoConstraints:[NSLayoutConstraint] = [
            labelVibracao.topAnchor.constraint(equalTo: vibrationBackgroundView.topAnchor),
            labelVibracao.bottomAnchor.constraint(equalTo: vibrationBackgroundView.bottomAnchor),
            labelVibracao.leadingAnchor.constraint(equalTo: vibrationBackgroundView.leadingAnchor, constant: 18)
        ]
        NSLayoutConstraint.activate(labelVibracaoConstraints)
        
        //Switch Vibracao
        let switchVibracaoConstraints:[NSLayoutConstraint] = [
            switchVibracao.centerYAnchor.constraint(equalTo: vibrationBackgroundView.centerYAnchor),
            switchVibracao.leadingAnchor.constraint(equalTo: labelVibracao.trailingAnchor),
            switchVibracao.trailingAnchor.constraint(equalTo: vibrationBackgroundView.trailingAnchor, constant: -24)
        ]
        NSLayoutConstraint.activate(switchVibracaoConstraints)
        
        //Botao de duvidas
        let butaoQuestionConstraints:[NSLayoutConstraint] = [
            butaoQuestion.widthAnchor.constraint(equalToConstant: InferiorCustomSafeArea),
            butaoQuestion.heightAnchor.constraint(equalToConstant: InferiorCustomSafeArea),
            butaoQuestion.trailingAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.trailingAnchor,constant: -35),
            butaoQuestion.bottomAnchor.constraint(equalTo: previewView.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(butaoQuestionConstraints)
        
    }
    
    //MARK: -Interface

    func updateLabelEstado(state: TextoLabelEstados) {
        switch state{
        case .ligado:
            labelEstado.text = "A luz está ligada"
        case .desligado:
            labelEstado.text = "A luz está desligada"
        case .procurando:
            labelEstado.text =  "À procura da luz"
            
        }
        UIAccessibility.post(notification: .announcement, argument: labelEstado.text)
    }
    
    @objc func callForOnBoarding(){
        let vc = ViewControllerOnBoarding(isOnboarding: true)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func updateisVibrateActive() {
        isVibrateActive.toggle()
        defaults.setValue(isVibrateActive, forKey: "isVibrateActive")
    }
    
    func getVibrationState() {
        if defaults.bool(forKey: "isVibrateActive") == false {
            isVibrateActive = false
        } else {
            isVibrateActive = true
            switchVibracao.setOn(true, animated: false)
        }
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
    //MARK: -Voice Over
    
    func setupVoiceOver(){
        
        butaoQuestion.isAccessibilityElement = true
        butaoQuestion.accessibilityLabel = "Ajuda"
        
        labelVibracao.isAccessibilityElement = false
        
        switchVibracao.isAccessibilityElement = true
        switchVibracao.accessibilityLabel = labelVibracao.text
        
//        let groupedElement = UIAccessibilityElement(accessibilityContainer: self)
//        groupedElement.accessibilityLabel = "\(labelVibracao.text)"
//        groupedElement.accessibilityFrameInContainerSpace = labelVibracao.frame.union(switchVibracao.frame)
                
        
//        let myAction = UIAccessibilityCustomAction(
//            name: "Custom Action",
//            target: self,
//            selector: #selector(updateisVibrateActive)
//        )
//
//        vibrationBackgroundView.accessibilityCustomActions = [myAction]
//
//        self.accessibilityElements = [labelEstado, groupedElement, butaoQuestion]
    

    }
    

    
    //MARK: -Haptic Feedback
    func vibrate(type: UINotificationFeedbackGenerator.FeedbackType) {
        if isVibrateActive {
            DispatchQueue.main.async {
                let notificationGenerator = UINotificationFeedbackGenerator()
                notificationGenerator.prepare()
                notificationGenerator.notificationOccurred(type)
            }
        }
    }
}
