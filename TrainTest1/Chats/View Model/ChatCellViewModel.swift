//
//  ChatCellViewModel.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation

struct ChatCellViewModel {
  var avatarURL: URL? {
    URL(string: chatInfo.chat?.avatar ?? "")
  }
  
  var text: String? {
    chatInfo.lastMessage?.text
  }
  
  var name: String? {
    chatInfo.chat?.title
  }
  
  let chatInfo: ChatInfo
  
  init(chatInfo: ChatInfo) {
    self.chatInfo = chatInfo
  }
}
