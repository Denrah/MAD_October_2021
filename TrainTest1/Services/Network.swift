//
//  Network.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import Foundation
import Alamofire
import PromiseKit

class Network: RequestInterceptor {
  let baseURL = "http://45.144.179.101/scare-me/api/mobile"
  
  var onRefreshFailed: (() -> Void)?
  
  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    
    guard request.retryCount < 2 else {
      completion(.doNotRetry)
      return
    }
    
    if request.response?.statusCode == 401 {
      refresh().done { reposnse in
        UserDefaults.standard.set(reposnse?.accessToken ?? "", forKey: "access")
        UserDefaults.standard.set(reposnse?.refreshToken ?? "", forKey: "refresh")
        completion(.retry)
      }.catch { error in
        self.onRefreshFailed?()
        completion(.doNotRetry)
      }
    } else {
      completion(.doNotRetry)
    }
  }
  
  func request<T: Codable>(type: T.Type, url: String, method: HTTPMethod, params: Parameters?, encoding: ParameterEncoding) -> Promise<T?> {
    
    var headers: HTTPHeaders = .init()
    
    if let token = UserDefaults.standard.string(forKey: "access") {
      headers.add(HTTPHeader(name: "Authorization", value: "Bearer \(token)"))
      print(token)
    }
    
   
    
    print(baseURL + url)
    return Promise { seal in
      AF.request(baseURL + url, method: method, parameters: params, encoding: encoding, headers: headers, interceptor: self).validate().responseData { response in
        switch response.result {
        case .success(let data):
          let object = try? JSONDecoder().decode(T.self, from: data)
          seal.fulfill(object)
        case .failure(let error):
          seal.reject(error)
        }
      }
    }
  }
  
  func refresh() -> Promise<AuthResponse?> {
    return request(type: AuthResponse.self, url: "/v1/auth/refresh", method: .post, params: [
      "refreshToken": UserDefaults.standard.string(forKey: "refresh") ?? ""
    ], encoding: JSONEncoding.default)
  }
}
