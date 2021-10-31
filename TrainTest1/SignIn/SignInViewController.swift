//
//  SignInViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class SignInViewController: BaseViewController {
  let emailTF = TextField()
  let passTF = TextField()

    override func viewDidLoad() {
        super.viewDidLoad()
      
      let tilteLbl = UILabel()
      tilteLbl.text = "Sign In"
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
      
      
      let signUpBTN = CommonButton()
      signUpBTN.setTitle("Sign In", for: .normal)
      view.addSubview(signUpBTN)
      signUpBTN.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview().inset(16)
        make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
      }
      
      passTF.isSecureTextEntry = true
      
      signUpBTN.addTarget(self, action: #selector(signUp), for: .touchUpInside)
      

        // Do any additional setup after loading the view.
    }
  
  @objc func signUp() {
    let email = emailTF.text
    let pass = passTF.text
    
    guard [email, pass].allSatisfy({ $0?.isEmpty == false }) else {
      showAlert(text: "Fill in all fields")
      return
    }
    
    guard email?.contains("@") == true, email?.contains(".") == true else {
      showAlert(text: "Incorrect email")
      return
    }
    
    
    showProgress()
    network.request(type: AuthResponse.self, url: "/v1/auth/login", method: .post, params: [
      "email": email ?? "",
      "password": pass ?? ""
    ], encoding: JSONEncoding.default).ensure {
      self.hideProgress()
    }.done { response in
      UserDefaults.standard.set(response?.accessToken, forKey: "access")
      UserDefaults.standard.set(response?.refreshToken, forKey: "refresh")
      self.navigationController?.setViewControllers([MainViewController()], animated: true)
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

extension SignInViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}
