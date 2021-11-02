//
//  ChatsViewModel.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation
import Alamofire

class ChatsViewModel {
  var onDidStartRequest: (() -> Void)?
  var onDidFinishRequest: (() -> Void)?
  var onDidLoadData: (() -> Void)?
  var onDidReceiveError: ((Error) -> Void)?
  
  var chatsCount: Int {
    chatCellViewModels.count
  }
  
  let lastCellViewModels: [LastCellViewModel]
  
  private var chatCellViewModels: [ChatCellViewModel] = []
  
  private let network = Network()
  
  init() {
    if let data = UserDefaults.standard.data(forKey: "profiles"),
          let profiles = try? JSONDecoder().decode([Profile].self, from: data) {
      lastCellViewModels = profiles.map { LastCellViewModel(profile: $0) }
    } else {
      lastCellViewModels = []
    }
  }
  
  func loadData() {
    onDidStartRequest?()
    network.request(type: [ChatInfo].self, url: "/v1/chat", method: .get, params: [:], encoding: URLEncoding.default).ensure {
      self.onDidFinishRequest?()
    }.done { chats in
      self.chatCellViewModels = (chats ?? []).map { ChatCellViewModel(chatInfo: $0) }
      self.onDidLoadData?()
    }.catch { error in
      self.onDidReceiveError?(error)
    }
  }
  
  func cellViewModel(for index: Int) -> ChatCellViewModel {
    return chatCellViewModels[index]
  }
  
  func chatInfo(for index: Int) -> ChatInfo {
    return chatCellViewModels[index].chatInfo
  }
}
