//
//  SignInViewModel.swift
//  TrainTest1
//

import Foundation
import Alamofire

class SignInViewModel {
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  var onDidReceiveValidationError: ((String) -> Void)?
  var onDidSignIn: (() -> Void)?
  
  private let network = Network()
  
  func signIn(email: String?, pass: String?) {
    guard [email, pass].allSatisfy({ $0?.isEmpty == false }) else {
      onDidReceiveValidationError?("Fill in all fields")
      return
    }
    
    guard email?.contains("@") == true, email?.contains(".") == true else {
      onDidReceiveValidationError?("Incorrect email")
      return
    }
    
    
    onDidStartRequest?()
    network.request(type: AuthResponse.self, url: "/v1/auth/login", method: .post, params: [
      "email": email ?? "",
      "password": pass ?? ""
    ], encoding: JSONEncoding.default).ensure {
      self.onDidFinishRequest?()
    }.done { response in
      UserDefaults.standard.set(response?.accessToken, forKey: "access")
      UserDefaults.standard.set(response?.refreshToken, forKey: "refresh")
      self.onDidSignIn?()
    }.catch { error in
      self.onDidReceiveError?(error)
    }
  }
}
