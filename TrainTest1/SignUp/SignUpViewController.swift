//
//  SignUpViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire
import MBProgressHUD

struct AuthResponse: Codable {
  let accessToken: String
  let refreshToken: String
}

class TextField: UITextField {
  override var intrinsicContentSize: CGSize {
    return CGSize(width: super.intrinsicContentSize.width, height: 64)
  }
  
  override var placeholder: String? {
    set {
      attributedPlaceholder = NSAttributedString(string: newValue ?? "", attributes: [.font: UIFont.bpalB, .foregroundColor: UIColor.white])
    }
    get {
      attributedPlaceholder?.string
    }
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
  }
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24))
  }
  
  init() {
    super.init(frame: .zero)
    backgroundColor = .dark2
    layer.cornerRadius = 16
    textColor = .white
    font = .bpalB
    autocorrectionType = .no
    autocapitalizationType = .none
  }
  
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SignUpViewController: BaseViewController {
  let emailTF = TextField()
  let passTF = TextField()
  let passRTF = TextField()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      let tilteLbl = UILabel()
      tilteLbl.text = "Sign Up"
      tilteLbl.font = .bpalB?.withSize(36)
      view.addSubview(tilteLbl)
      tilteLbl.textColor = .white
      tilteLbl.snp.makeConstraints { make in
        make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        make.leading.trailing.equalToSuperview().inset(16)
      }
      
      
      emailTF.placeholder = "E-mail"
      emailTF.returnKeyType = .done
      emailTF.delegate = self
      view.addSubview(emailTF)
      emailTF.snp.makeConstraints { make in
        make.top.equalTo(tilteLbl.snp.bottom).offset(5)
        make.leading.trailing.equalToSuperview().inset(16)
      }
      
      
      passTF.placeholder = "Password"
      view.addSubview(passTF)
      passTF.returnKeyType = .done
      passTF.delegate = self
      passTF.snp.makeConstraints { make in
        make.top.equalTo(emailTF.snp.bottom).offset(8)
        make.leading.trailing.equalToSuperview().inset(16)
      }
      
      
      passRTF.placeholder = "Repeat Password"
      view.addSubview(passRTF)
      passRTF.returnKeyType = .done
      passRTF.delegate = self
      passRTF.snp.makeConstraints { make in
        make.top.equalTo(passTF.snp.bottom).offset(8)
        make.leading.trailing.equalToSuperview().inset(16)
      }
      
      let signUpBTN = CommonButton()
      signUpBTN.setTitle("Sign Up", for: .normal)
      view.addSubview(signUpBTN)
      signUpBTN.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview().inset(16)
        make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
      }
      
      passTF.isSecureTextEntry = true
      passRTF.isSecureTextEntry = true
      
      signUpBTN.addTarget(self, action: #selector(signUp), for: .touchUpInside)
      

        // Do any additional setup after loading the view.
    }
  
  @objc func signUp() {
    let email = emailTF.text
    let pass = passTF.text
    let passR = passRTF.text
    
    guard [email, pass, passR].allSatisfy({ $0?.isEmpty == false }) else {
      showAlert(text: "Fill in all fields")
      return
    }
    
    guard pass == passR else {
      showAlert(text: "Passwords must match")
      return
    }
    
    guard email?.contains("@") == true, email?.contains(".") == true else {
      showAlert(text: "Incorrect email")
      return
    }
    
    
    showProgress()
    network.request(type: AuthResponse.self, url: "/v1/auth/register", method: .post, params: [
      "email": email ?? "",
      "password": pass ?? ""
    ], encoding: JSONEncoding.default).ensure {
      self.hideProgress()
    }.done { response in
      UserDefaults.standard.set(response?.accessToken, forKey: "access")
      UserDefaults.standard.set(response?.refreshToken, forKey: "refresh")
      self.navigationController?.setViewControllers([AboutMeViewController()], animated: true)
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
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

extension SignUpViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}
