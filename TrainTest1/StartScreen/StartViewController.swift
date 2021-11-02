//
//  StartViewController.swift
//  TrainTest1
//

import UIKit

class CommonButton: UIButton {
  override var intrinsicContentSize: CGSize {
    return CGSize(width: super.intrinsicContentSize.width, height: 56)
  }
  
  init() {
    super.init(frame: .zero)
    
    backgroundColor = .orange2
    layer.cornerRadius = 16
    setTitleColor(.dark1, for: .normal)
    layer.shadowColor = UIColor.orange2.cgColor
    layer.shadowOffset = .zero
    layer.shadowRadius = 10
    layer.shadowOpacity = 1
    
    titleLabel?.font = .bpalB
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class StartViewController: BaseViewController {
  var cContainerView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    
    let logoImageView = UIImageView()
    logoImageView.image = UIImage(named: "spl-text")
    logoImageView.contentMode = .scaleAspectFit
    view.addSubview(logoImageView)
    logoImageView.snp.makeConstraints { make in
      make.width.equalTo(268)
      make.height.equalTo(122)
      make.centerY.equalToSuperview().offset(-72)
      make.centerX.equalToSuperview()
    }
    
    let signInButton = UIButton()
    view.addSubview(signInButton)
    signInButton.setTitle("Sign In", for: .normal)
    signInButton.tintColor = .orange2
    signInButton.setTitleColor(.orange2, for: .normal)
    signInButton.titleLabel?.font = .bpalB
    signInButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
      make.centerX.equalToSuperview()
      make.height.equalTo(28)
    }
    
    let underline = UIView()
    underline.backgroundColor = .orange2
    view.addSubview(underline)
    underline.snp.makeConstraints { make in
      make.leading.equalTo(signInButton)
      make.trailing.equalTo(signInButton)
      make.height.equalTo(1)
      make.top.equalTo(signInButton.snp.bottom).offset(-8)
    }
    
    let accLabel = UILabel()
    accLabel.text = "Already have an account?"
    accLabel.textColor = .orange1
    accLabel.font = .bpalB
    view.addSubview(accLabel)
    accLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(signInButton.snp.top).offset(-8)
    }
    
    let signUpButton = CommonButton()
    signUpButton.setTitle("Sign Up", for: .normal)
    view.addSubview(signUpButton)
    signUpButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalTo(accLabel.snp.top).offset(-24)
    }
    
    view.addSubview(cContainerView)
    cContainerView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(signUpButton.snp.top)
    }
    
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    
    setupImages()
  }
  
  @objc func signUp() {
    navigationController?.pushViewController(SignUpViewController(), animated: true)
  }
  
  @objc func signIn() {
    navigationController?.pushViewController(SignInViewController(viewModel: SignInViewModel()), animated: true)
  }
  
  var timer: Timer?
  
  func setupImages() {
    timer?.invalidate()
    view.layoutIfNeeded()
    cContainerView.subviews.forEach { $0.removeFromSuperview() }
    for index in 1...6 {
      let imageView = CCImageView(direction: CDirection.allCases.randomElement() ?? .leftTop)
      imageView.image = UIImage(named: "c\(index)")
      
      let imX = CGFloat.random(in: 0...(UIScreen.main.bounds.width - 100))
      let imY = CGFloat.random(in: 0...(cContainerView.frame.height - 100))
      
      imageView.frame = CGRect(x: imX, y: imY, width: 100, height: 100)
      
      cContainerView.addSubview(imageView)
    }
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: { _ in
      self.updateImages()
    })
  }
  
  func updateImages() {
    cContainerView.subviews.compactMap { $0 as? CCImageView }.forEach { imageView in
      imageView.frame = CGRect(x: imageView.frame.origin.x + imageView.direction.dx,
                               y: imageView.frame.origin.y + imageView.direction.dy,
                               width: 100, height: 100)
      
      if imageView.frame.origin.x < 0 || imageView.frame.origin.x + 100 > cContainerView.frame.width {
        switch imageView.direction {
        case .leftBottom:
          imageView.direction = .rightBottom
        case .leftTop:
          imageView.direction = .rightTop
        case .rightBottom:
          imageView.direction = .leftBottom
        case .rightTop:
          imageView.direction = .leftTop
        }
      }
      
      if imageView.frame.origin.y < 0 || imageView.frame.origin.y + 100 > cContainerView.frame.height {
        switch imageView.direction {
        case .leftBottom:
          imageView.direction = .leftTop
        case .leftTop:
          imageView.direction = .leftBottom
        case .rightBottom:
          imageView.direction = .rightTop
        case .rightTop:
          imageView.direction = .rightBottom
        }
      }
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}

class CCImageView: UIImageView {
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 100, height: 100)
  }
  
  var direction: CDirection
  
  init(direction: CDirection) {
    self.direction = direction
    super.init(frame: .zero)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


enum CDirection: CaseIterable {
  case leftTop, leftBottom, rightTop, rightBottom
  
  var dx: CGFloat {
    switch self {
    case .leftTop:
      return -2
    case .leftBottom:
      return -2
    case .rightTop:
      return 2
    case .rightBottom:
      return 2
    }
  }
  
  var dy: CGFloat {
    switch self {
    case .leftTop:
      return -2
    case .leftBottom:
      return 2
    case .rightTop:
      return -2
    case .rightBottom:
      return 2
    }
  }
}
