//
//  Profile.swift
//  TrainTest1
//
//  Created by National Team on 02.11.2021.
//

import Foundation

struct Profile: Codable {
  let name: String?
  let userId: String?
  let aboutMyself: String?
  let avatar: String?
  let topics: [Topic]
}
