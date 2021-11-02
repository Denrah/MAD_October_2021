//
//  MainViewModel.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation
import Alamofire

class MainViewModel {
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  var onDidMarkedUser: (() -> Void)?
  var onDidSelectUser: ((Profile) -> Void)?
  
  private(set) var cardViewModels: [UserCardViewModel] = []
  
  private let network = Network()
  
  func loadData() {
    self.onDidStartRequest?()
    network.request(type: [Profile].self, url: "/v1/user/feed", method: .get, params: [:], encoding: URLEncoding.default).ensure {
      self.onDidFinishRequest?()
    }.done { profiles in
      
      self.cardViewModels = (profiles ?? []).map { profile in
        let viewModel = UserCardViewModel(profile: profile)
        viewModel.onLike = { [weak self] profile in
          self?.likeUser(profile: profile)
        }
        viewModel.onDislike = { [weak self] profile in
          self?.dislikeUser(profile: profile)
        }
        viewModel.onSelect = { [weak self] profile in
          self?.onDidSelectUser?(profile)
        }
        return viewModel
      }
      self.onDidLoadData?()
    }.catch { error in
      self.onDidReceiveError?(error)
    }
  }
  
  func didMarkUser() {
    self.cardViewModels.remove(at: 0)
    onDidMarkedUser?()
  }
  
  func didLikeUser() {
    guard let profile = cardViewModels.first?.profile else { return }
    likeUser(profile: profile)
  }
  
  func didDislikeUser() {
    guard let profile = cardViewModels.first?.profile else { return }
    dislikeUser(profile: profile)
  }
  
  private func likeUser(profile: Profile) {
    onDidStartRequest?()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/like", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.onDidFinishRequest?()
    }.done { _ in
      self.saveProfile(profile)
      self.cardViewModels.remove(at: 0)
      self.onDidMarkedUser?()
    }.catch { error in
      self.onDidReceiveError?(error)
    }
  }
  
  private func dislikeUser(profile: Profile) {
    onDidStartRequest?()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/dislike", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.onDidFinishRequest?()
    }.done { _ in
      self.cardViewModels.remove(at: 0)
      self.onDidMarkedUser?()
    }.catch { error in
      self.onDidReceiveError?(error)
    }
  }
  
  private func saveProfile(_ profile: Profile) {
    let data = UserDefaults.standard.data(forKey: "profiles") ?? Data()
    var profiles = (try? JSONDecoder().decode([Profile].self, from: data)) ?? []
    
    profiles.append(profile)
    if let newData = try? JSONEncoder().encode(profiles) {
      UserDefaults.standard.set(newData, forKey: "profiles")
    }
  }
}
