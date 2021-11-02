//
//  SignInViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class SignInViewController: BaseViewController {
  private let emailTF = TextField()
  private let passTF = TextField()
  
  private let viewModel: SignInViewModel
  
  init(viewModel: SignInViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    
    signUpBTN.addTarget(self, action: #selector(signIn), for: .touchUpInside)
    
    bindToViewModel()
  }
  
  private func bindToViewModel() {
    viewModel.onDidStartRequest = { [weak self] in
      self?.showProgress()
    }
    viewModel.onDidFinishRequest = { [weak self] in
      self?.hideProgress()
    }
    viewModel.onDidReceiveError = { [weak self] error in
      self?.showAlert(text: error.localizedDescription)
    }
    viewModel.onDidReceiveValidationError = { [weak self] text in
      self?.showAlert(text: text)
    }
    viewModel.onDidSignIn = { [weak self] in
      self?.navigationController?.setViewControllers([MainViewController(viewModel: MainViewModel())], animated: true)
    }
  }
  
  @objc private func signIn() {
    viewModel.signIn(email: emailTF.text, pass: passTF.text)
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
