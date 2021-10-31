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
    
    
    signUpButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
    signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    
  }
  
  @objc func signUp() {
    navigationController?.pushViewController(SignUpViewController(), animated: true)
  }
  
  @objc func signIn() {
    navigationController?.pushViewController(SignInViewController(), animated: true)
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
