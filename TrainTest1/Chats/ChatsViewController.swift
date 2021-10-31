//
//  ChatsViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class ChatsViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: false)
    getMessahes()
  }
  
  var chats: [ChatInfo] = []
  
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    let lastLbl = UILabel()
    view.addSubview(lastLbl)
    lastLbl.text = "Last"
    lastLbl.textColor = .white
    lastLbl.font = .bpalB?.withSize(36)
    lastLbl.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(8)
      make.leading.equalToSuperview().inset(21)
    }
    
    let lastScrollView = UIScrollView()
    lastScrollView.showsHorizontalScrollIndicator = false
    lastScrollView.contentInset.left = 20
    lastScrollView.contentInset.right = 20
    view.addSubview(lastScrollView)
    lastScrollView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(lastLbl.snp.bottom).offset(16)
      make.height.equalTo(115)
    }
    
    let lastStackView = UIStackView()
    lastStackView.spacing = 16
    lastScrollView.addSubview(lastStackView)
    lastStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.height.equalToSuperview()
    }
    
    getProfiles().forEach { profile in
      let cell = LastCellView(profile: profile)
      lastStackView.addArrangedSubview(cell)
    }
    
    
    let messLabl = UILabel()
    view.addSubview(messLabl)
    messLabl.text = "Messages"
    messLabl.textColor = .white
    messLabl.font = .bpalB?.withSize(36)
    messLabl.snp.makeConstraints { make in
      make.top.equalTo(lastScrollView.snp.bottom).offset(16)
      make.leading.equalToSuperview().inset(21)
    }
    
    
    let tabbar = TabbarView()
    view.addSubview(tabbar)
    tabbar.select(item: .chat)
    tabbar.snp.makeConstraints { make in
      make.height.equalTo(71)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    tabbar.onTap = { item in
      self.showTab(item: item)
    }
    
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.estimatedRowHeight = 96
    tableView.rowHeight = UITableView.automaticDimension
    tableView.contentInset.bottom = 120
    tableView.snp.makeConstraints { make in
      make.top.equalTo(messLabl.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
    
    tableView.delegate = self
    tableView.dataSource = self
    
    // Do any additional setup after loading the view.
  }
  
  
  func getMessahes() {
    showProgress()
    network.request(type: [ChatInfo].self, url: "/v1/chat", method: .get, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { chats in
      self.chats = chats ?? []
      self.tableView.reloadData()
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
}

extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return chats.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
    (cell as? ChatCell)?.configure(chat: chats[indexPath.row])
    return cell
  }
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
}

struct ChatInfo: Codable {
  let chat: Chat?
  let lastMessage: Message?
}

class ChatCell: UITableViewCell {
  let avImageView = UIImageView()
  let nameLabel = UILabel()
  let msgLabel = UILabel()
  let dividerView = UIView()
  
  let containerView = UIView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    
    contentView.addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.height.greaterThanOrEqualTo(96)
      make.edges.equalToSuperview()
    }
    
    
    containerView.addSubview(avImageView)
    avImageView.contentMode = .scaleAspectFill
    avImageView.layer.cornerRadius = 32
    avImageView.clipsToBounds = true
    avImageView.snp.makeConstraints { make in
      make.size.equalTo(64)
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    let stackView = UIStackView()
    stackView.spacing = 4
    stackView.axis =  .vertical
    containerView.addSubview(stackView)
    stackView.snp.makeConstraints { make in
      make.leading.equalTo(avImageView.snp.trailing).offset(16)
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
      make.top.bottom.lessThanOrEqualToSuperview().inset(16)
    }
    
   
    nameLabel.textColor = .white
    nameLabel.numberOfLines = 0
    nameLabel.font = .bpalB?.withSize(16)
    stackView.addArrangedSubview(nameLabel)
    
    msgLabel.textColor = .white
    msgLabel.numberOfLines = 0
    msgLabel.font = .bpalB?.withSize(16)
    stackView.addArrangedSubview(msgLabel)
    
   
    dividerView.backgroundColor = .orange1
    containerView.addSubview(dividerView)
    dividerView.snp.makeConstraints { make in
      make.leading.equalTo(avImageView.snp.trailing).offset(16)
      make.trailing.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }
  
  func configure(chat: ChatInfo) {
    avImageView.kf.setImage(with: URL(string: chat.chat?.avatar ?? ""))
    msgLabel.text = chat.lastMessage?.text
    nameLabel.text = chat.chat?.title
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class LastCellView: UIView {
  init(profile: Profile) {
    super.init(frame: .zero)
    
    let imageView = UIImageView()
    imageView.kf.setImage(with: URL(string: profile.avatar ?? ""))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 41
    imageView.clipsToBounds = true
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(82)
      make.leading.trailing.top.equalToSuperview()
    }
    
    let titleLabl = UILabel()
    titleLabl.textColor = .white
    titleLabl.font = .bpalB?.withSize(14)
    titleLabl.textAlignment = .center
    titleLabl.text = profile.name
    addSubview(titleLabl)
    titleLabl.snp.makeConstraints { make in
      make.top.equalTo(imageView.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(25)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
