//
//  UserCardViewModel.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation

class UserCardViewModel {
  var onSelect: ((Profile) -> Void)?
  var onLike: ((Profile) -> Void)?
  var onDislike: ((Profile) -> Void)?
  
  var name: String? {
    return profile.name
  }
  
  var avatarURL: URL? {
    URL(string: profile.avatar ?? "")
  }
  
  var topicsCountText: String {
    let data = UserDefaults.standard.data(forKey: "topics") ?? Data()
    let topics = (try? JSONDecoder().decode([Topic].self, from: data)) ?? []
    
    let count = topics.filter { topic in profile.topics.contains { $0.id == topic.id } }.count
    return "\(count) Matches"
  }
  
  let profile: Profile
  
  init(profile: Profile) {
    self.profile = profile
  }
  
  func didTapView() {
    onSelect?(profile)
  }
  
  func didLike() {
    onLike?(profile)
  }
  
  func didDislike() {
    onDislike?(profile)
  }
}
