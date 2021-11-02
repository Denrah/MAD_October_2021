//
//  ChatInfo.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation

struct ChatInfo: Codable {
  let chat: Chat?
  let lastMessage: Message?
}

struct Chat: Codable {
  let id: String?
  let title: String?
  let avatar: String?
}

struct User: Codable {
  let name: String?
  let userId: String?
  let aboutMyself: String?
  let avatar: String?
}

struct Message: Codable {
  let id: String?
  let text: String?
  let user: User?
  let createdAt: String?
  
  var date: Date? {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'[zzz]"
    if let createdAt = createdAt {
      return formatter.date(from: createdAt)
    } else {
      return nil
    }
  }
}
