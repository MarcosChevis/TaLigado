//
//  ViewContollerOnBoarding.swift
//  TaLigado
//
//  Created by Vitor Cheung on 24/09/21.
//
import UIKit
class ViewControllerOnBoarding: UIViewController {
    
    
    var isOnboarding: Bool
    
    //MARK: -View
    lazy var view0:ViewOnboarding =  {
        let view = ViewOnboarding()
        view.setup(titulo: "Tá ligado?",
                   text: "Olá! Sou o Clark, e irei te ajudar a saber se a luz está ligada!\nTá ligado?",
                   imageName: "on1")
        return view
    }()
    
    
    lazy var view1:ViewOnboarding =  {
        let view = ViewOnboarding()
        view.setup(titulo: "Permissão da câmera",
                   text: "No primeiro uso, terá uma notificação solicitando permissão de uso da sua câmera, pois sem isso o aplicativo não funciona.",
                   imageName: "on2")
        return view
    }()
    
    lazy var view2:ViewOnboarding =  {
        let view = ViewOnboarding()
        view.setup(titulo: "Uso da câmera",
                   text: "Com a câmera autorizada, aponte seu celular para os possíveis focos de luz.\nAqui no app sempre usaremos a câmera traseira, ok?",
                   imageName: "on3")
        return view
    }()
    
    lazy var view3:ViewOnboarding =  {
        let view = ViewOnboarding()
        view.setup(titulo: "Resposta",
                   text: "Após detectar a luz,  irei dizer se tá ligado ou não e também emitir uma vibração.",
                   imageName: "on4")
        return view
    }()
    
    lazy var view4:ViewOnboarding =  {
        let view = ViewOnboarding()
        view.setup(titulo: "Desativar",
                   text: "Na parte inferior da tela tem dois botões, um para desativar o modo de vibração e outro de ajuda, caso tenha alguma dúvida.",
                   imageName: "on5")
        return view
    }()
    
    lazy var arrayViews = [view0, view1, view2, view3,view4]
    
    //MARK: -scrollView
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(arrayViews.count), height: view.frame.height)
        
        for i in 0..<arrayViews.count {
            scrollView.addSubview(arrayViews[i])
            arrayViews[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
        }
        scrollView.delegate = self
        
        return scrollView
    }()
    
    //MARK: -pageControl
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = arrayViews.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor(named: "corLaranja")
        pageControl.isEnabled = false
        pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)
        return pageControl
    }()
    
    //MARK: -butão
    lazy var butaoNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Próximo", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(named: "corLaranja"), for: .normal)
        button.addTarget(self, action: #selector(addPageContol), for: .touchUpInside)
        
        return button
        
    }()
    
    lazy var butaoPrevious: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Voltar", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(UIColor(named: "corLaranja"), for: .normal)
        button.addTarget(self, action: #selector(subPageContol), for: .touchUpInside)
        return button
    }()
    
    lazy var butaoFechar: UIButton = {
        let buttonTemp = UIButton()
        buttonTemp.backgroundColor = UIColor(named: "corAzul")
        
        //primeiro seta uma configuração
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold, scale: .large)
        
        //adicionado qual a imagem - SF Symbol - com a figuração criada acima
        let largeBoldDoc = UIImage(systemName: "xmark.circle.fill", withConfiguration: largeConfig)
        
        //no final que voce está colocando realmente a imagem
        buttonTemp.setImage(largeBoldDoc, for: .normal)
        
        //Cor dos botão
        buttonTemp.tintColor = UIColor(named: "corGelinho")
        
        buttonTemp.layer.cornerRadius = 31
        
        if isOnboarding {
            buttonTemp.addTarget(self, action: #selector(actionNavigateViewController), for: .touchUpInside)
        } else {
            buttonTemp.addTarget(self, action: #selector(actionDismiss), for: .touchUpInside)
        }
        
        
        return buttonTemp
    }()
    
    //MARK: -Inits
    init(isOnboarding: Bool) {
        self.isOnboarding = isOnboarding
        super.init(nibName: nil, bundle: nil)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(named: "corAzul")
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        view.addSubview(butaoPrevious)
        view.addSubview(butaoNext)
        view.addSubview(butaoFechar)
        setupConstraints()
    }
    
    //MARK: -Constraints
    func setupConstraints(){
        
        //pagecontrol
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        let pageControlConstraints:[NSLayoutConstraint] = [
            pageControl.heightAnchor.constraint(equalToConstant: 50),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 30),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -30),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
        ]
        NSLayoutConstraint.activate(pageControlConstraints)
        
        //scrollview
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let scrollViewConstraints:[NSLayoutConstraint] = [
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height/6),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height/3)
        ]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        //botoes
        butaoNext.translatesAutoresizingMaskIntoConstraints=false
        let butaoNextConstraints:[NSLayoutConstraint] = [
            butaoNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            butaoNext.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-30)
        ]
        NSLayoutConstraint.activate(butaoNextConstraints)
        
        butaoPrevious.translatesAutoresizingMaskIntoConstraints=false
        let butaoPreviousConstraints:[NSLayoutConstraint] = [
            butaoPrevious.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            butaoPrevious.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30)
        ]
        NSLayoutConstraint.activate(butaoPreviousConstraints)
        
        butaoFechar.translatesAutoresizingMaskIntoConstraints = false
        let  buttonFecharConstraints:[NSLayoutConstraint] = [
            butaoFechar.widthAnchor.constraint(equalToConstant: 60),
            butaoFechar.heightAnchor.constraint(equalToConstant: 60),
            butaoFechar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            butaoFechar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant:25)
        ]
        NSLayoutConstraint.activate( buttonFecharConstraints)
    }

    
    //MARK: -ação de mudar de pagina na pageControl
    @objc
    func pageControlTapHandler(sender: UIPageControl) {
        
        var frame: CGRect = scrollView.frame
        frame.origin.x = frame.size.width * CGFloat(sender.currentPage )
        scrollView.scrollRectToVisible(frame, animated: true)
        
    }
    
    @objc
    func addPageContol(){
        if (scrollView.contentOffset.x+view.frame.width < view.frame.width*CGFloat(arrayViews.count)) {
            
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x+view.frame.width, y: 0), animated: false)
            
            if (scrollView.contentOffset.x+view.frame.width == view.frame.width*CGFloat(arrayViews.count)) {
                butaoNext.setTitle("Terminar", for: .normal)
            }
        } else {
            //dismiss
            dismiss(animated: true, completion: nil)
            navigationController?.pushViewController(VisionObjectRecognitionViewController(), animated: true)
            
        }
        
    }
    
    @objc
    func subPageContol(){
        butaoNext.setTitle("Próximo", for: .normal)
        if (scrollView.contentOffset.x-view.frame.width>=0){
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x-view.frame.width, y: 0), animated: false)
        }
        
        
    }
    
    @objc
    func actionDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func actionNavigateViewController() {
        navigationController?.pushViewController(VisionObjectRecognitionViewController(), animated: true)
    }
    
    
}

//MARK: -Delegate
extension ViewControllerOnBoarding: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}




