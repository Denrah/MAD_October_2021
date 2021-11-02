//
//  LastCellViewModel.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation

struct LastCellViewModel {
  var avatarURL: URL? {
    URL(string: profile.avatar ?? "")
  }
  
  var name: String? {
    profile.name
  }
  
  private let profile: Profile
  
  init(profile: Profile) {
    self.profile = profile
  }
}
