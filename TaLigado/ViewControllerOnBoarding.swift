//
//  ViewContollerOnBoarding.swift
//  TaLigado
//
//  Created by Vitor Cheung on 24/09/21.
//
import UIKit
class ViewControllerOnBoarding: UIViewController {

//MARK: -View
  lazy var view0: UIView = {
    let view = UIView()
    //view.backgroundColor = .systemTeal
    let label = UILabel()
    label.text = "No primeiro uso, terá uma notificação solicitando permissão de uso da sua câmera.\nCom a câmera autorizada, aponte seu celular para os possíveis focos de luz."
    label.textAlignment = .center
    label.numberOfLines = 5
    label.font = UIFont .boldSystemFont(ofSize: 17.0)
    view.addSubview(label)
//    let imageName = "doubt1"
//    let image = UIImage(named: imageName)
//    let imageView = UIImageView(image: image!)
//    view.addSubview(imageView)
//    imageView.contentMode = .scaleAspectFit
//    imageView.translatesAutoresizingMaskIntoConstraints = false
////    imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width/5).isActive = true
//    imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45).isActive = true
//    imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height * 12).isActive = true
//    imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
//    imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.8).isActive = true
      setupConstrainstsLabel(label: label, view: view)
    return view
  }()
    
  lazy var view1: UIView = {
    let view = UIView()
    //view.backgroundColor = .systemPink
    let label = UILabel()
    label.text = "Após detectar a luz, eu irei dizer se tá ligado ou não."
    label.textAlignment = .center
    label.numberOfLines = 4
    label.font = UIFont .boldSystemFont(ofSize: 17.0)
    view.addSubview(label)
    setupConstrainstsLabel(label: label, view: view)
//    let imageName = "doubt2"
//    let image = UIImage(named: imageName)
//    let imageView1 = UIImageView(image: image!)
//    view.addSubview(imageView1)
//    imageView1.contentMode = .scaleAspectFit
//    imageView1.translatesAutoresizingMaskIntoConstraints = false
//    imageView1.widthAnchor.constraint(equalToConstant: 250).isActive = true
//    imageView1.heightAnchor.constraint(equalToConstant: 200).isActive = true
//    imageView1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    imageView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 95).isActive = true
    return view
  }()
    
  lazy var view2: UIView = {
    let view = UIView()
    //view.backgroundColor = .systemYellow
    let label = UILabel()
    label.text = "Caso queira desativar a vibração ou tem alguma dúvida, só ir para ao canto superior direito do app.\nA câmera somente mostra a visão trasseira do celular."
    label.textAlignment = .center
    label.numberOfLines = 4
    label.font = UIFont .boldSystemFont(ofSize: 17.0)
    view.addSubview(label)
    setupConstrainstsLabel(label: label, view: view)
//    let imageName = "doubt3.1"
//    let image = UIImage(named: imageName)
//    let imageView2 = UIImageView(image: image!)
//    view.addSubview(imageView2)
//    imageView2.contentMode = .scaleAspectFit
//    imageView2.translatesAutoresizingMaskIntoConstraints = false
//    imageView2.widthAnchor.constraint(equalToConstant: 250).isActive = true
//    imageView2.heightAnchor.constraint(equalToConstant: 200).isActive = true
//    imageView2.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//    imageView2.topAnchor.constraint(equalTo: view.topAnchor, constant: 95).isActive = true
    return view
  }()
    
    
  lazy var arrayViews = [view0, view1, view2]

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
    
    //MARK: -ação de mudar de pagina na pageControl
  @objc
  func pageControlTapHandler(sender: UIPageControl) {
    
        var frame: CGRect = scrollView.frame
      frame.origin.x = frame.size.width * CGFloat(sender.currentPage )
        scrollView.scrollRectToVisible(frame, animated: true)
    
  }
    
    @objc
    func addPageContol(){
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x+view.frame.width, y: 0), animated: false)
//        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
//        pageControl.currentPage = Int(pageIndex)
    }
    
    @objc
    func subPageContol(){
    scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x-view.frame.width, y: 0), animated: false)
        let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    //MARK: -butão
    lazy var butaoNext: UIButton = {
        let button = UIButton(type: .system)
            button.setTitle("Proximo", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(UIColor(named: "corLaranja"), for: .normal)
            button.addTarget(self, action: #selector(addPageContol), for: .touchUpInside)
                
        return button
        
    }()
    
    lazy var butaoPrevious: UIButton = {
        let button = UIButton(type: .system)
            button.setTitle("voltar", for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            button.setTitleColor(UIColor(named: "corLaranja"), for: .normal)
            button.addTarget(self, action: #selector(subPageContol), for: .touchUpInside)
        return button
    }()

    //MARK: -viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    view.backgroundColor = UIColor(named: "corAzul")
    view.addSubview(scrollView)
    view.addSubview(pageControl)
    view.addSubview(butaoPrevious)
    view.addSubview(butaoNext)
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
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
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
            butaoNext.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            butaoNext.rightAnchor.constraint(equalTo: view.rightAnchor, constant:-30)
        ]
        NSLayoutConstraint.activate(butaoNextConstraints)
        
        butaoPrevious.translatesAutoresizingMaskIntoConstraints=false
        let butaoPreviousConstraints:[NSLayoutConstraint] = [
            butaoPrevious.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            butaoPrevious.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 30)
        ]
        NSLayoutConstraint.activate(butaoPreviousConstraints)
    }
    
    func setupConstrainstsLabel(label:UILabel, view: UIView){
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints:[NSLayoutConstraint] = [
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        
    }
    
}

//MARK: -Delegate
extension ViewControllerOnBoarding: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
    pageControl.currentPage = Int(pageIndex)
  }
}




