//
//  ChatViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire
import PromiseKit
import SnapKit

class RightMessageCell: UITableViewCell {
  private let bubbleView = UIView()
  private let textlabel = UILabel()
  private let timeLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(bubbleView)
    bubbleView.backgroundColor = .orange2
    bubbleView.layer.cornerRadius = 20
    bubbleView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.trailing.equalToSuperview().inset(24)
      make.leading.greaterThanOrEqualToSuperview()
    }
    
    let leftTailView = UIImageView()
    leftTailView.image = UIImage(named: "left-tail")?.withRenderingMode(.alwaysTemplate)
    leftTailView.tintColor = .orange2
    leftTailView.contentMode = .scaleAspectFit
    leftTailView.transform = CGAffineTransform(scaleX: -1, y: 1)
    contentView.insertSubview(leftTailView, belowSubview: bubbleView)
    leftTailView.snp.makeConstraints { make in
      make.size.equalTo(17)
      make.trailing.equalTo(bubbleView.snp.trailing).offset(5)
      make.bottom.equalTo(bubbleView.snp.bottom)
    }
    
    bubbleView.addSubview(textlabel)
    textlabel.font = .bpalB?.withSize(15)
    textlabel.textColor = .dark1
    textlabel.numberOfLines = 0
    textlabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(7)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    
    contentView.addSubview(timeLabel)
    timeLabel.font = .bpalB?.withSize(11)
    timeLabel.textColor = .systemGray
    timeLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(30)
      make.top.equalTo(bubbleView.snp.bottom).offset(8)
      make.bottom.equalToSuperview().inset(28)
    }
    contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
  }
  
  func configure(message: Message) {
    self.textlabel.text = message.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm • d MMMM yyyy"
    if let date = message.date {
      self.timeLabel.text = formatter.string(from: date)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class LeftMessageCell: UITableViewCell {
  private let bubbleView = UIView()
  private let textlabel = UILabel()
  private let timeLabel = UILabel()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .clear
    contentView.backgroundColor = .clear
    selectionStyle = .none
    
    contentView.addSubview(bubbleView)
    bubbleView.backgroundColor = .dark2
    bubbleView.layer.cornerRadius = 20
    bubbleView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.leading.equalToSuperview().inset(24)
      make.trailing.lessThanOrEqualToSuperview()
    }
    
    let leftTailView = UIImageView()
    leftTailView.image = UIImage(named: "left-tail")
    leftTailView.contentMode = .scaleAspectFit
    contentView.insertSubview(leftTailView, belowSubview: bubbleView)
    leftTailView.snp.makeConstraints { make in
      make.size.equalTo(17)
      make.leading.equalTo(bubbleView.snp.leading).offset(-5)
      make.bottom.equalTo(bubbleView.snp.bottom)
    }
    
    bubbleView.addSubview(textlabel)
    textlabel.font = .bpalB?.withSize(15)
    textlabel.textColor = .white
    textlabel.numberOfLines = 0
    textlabel.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(7)
      make.leading.trailing.equalToSuperview().inset(12)
    }
    
    contentView.addSubview(timeLabel)
    timeLabel.font = .bpalB?.withSize(11)
    timeLabel.textColor = .systemGray
    timeLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(30)
      make.top.equalTo(bubbleView.snp.bottom).offset(8)
      make.bottom.equalToSuperview().inset(28)
    }
    contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
  }
  
  func configure(message: Message) {
    self.textlabel.text = message.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm • d MMMM yyyy"
    if let date = message.date {
      self.timeLabel.text = formatter.string(from: date)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class ChatViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  let chatInfo: ChatInfo
  
  let messageTextField = UITextField()
  let sendButton = UIButton()
  
  private var messages: [Message] = []
  
  private let tableView = UITableView()
  
  private var isLoading = false
  private var hasMoreData = true
  
  let stackView = UIStackView()
  
  private var stackHeightConstaint: Constraint?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let imageView = UIImageView()
    imageView.kf.setImage(with: URL(string: chatInfo.chat?.avatar ?? ""))
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 41
    imageView.clipsToBounds = true
    view.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.size.equalTo(82)
      make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16)
    }
    
    let nameLabel = UILabel()
    nameLabel.text = chatInfo.chat?.title
    nameLabel.font = .bpalB?.withSize(36)
    nameLabel.textColor = .white
    nameLabel.numberOfLines = 0
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(25)
      make.top.equalTo(imageView)
      make.trailing.equalToSuperview().inset(16)
    }
    
  
    
    view.addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.alignment = .leading
    stackView.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(24)
      make.leading.trailing.equalTo(nameLabel)
      stackHeightConstaint = make.height.equalTo(0).constraint
    }
    
    messageTextField.backgroundColor = .dark2
    messageTextField.layer.cornerRadius = 19
    messageTextField.textColor = .white
    messageTextField.font = .bpalB
    view.addSubview(messageTextField)
    messageTextField.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.height.equalTo(38)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.trailing.equalToSuperview().inset(73)
    }
    
    view.addSubview(sendButton)
    sendButton.layer.cornerRadius = 19
    sendButton.backgroundColor = .dark2
    sendButton.setImage(UIImage(named: "letter"), for: .normal)
    sendButton.snp.makeConstraints { make in
      make.size.equalTo(38)
      make.centerY.equalTo(messageTextField)
      make.trailing.equalToSuperview().inset(16)
    }
    sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    
    
    view.addSubview(tableView)
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    tableView.dataSource = self
    tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    tableView.contentInset.bottom = 16
    tableView.contentInset.top = 16
    tableView.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(messageTextField.snp.top).offset(-8)
    }
    
    tableView.register(LeftMessageCell.self, forCellReuseIdentifier: "LeftMessageCell")
    tableView.register(RightMessageCell.self, forCellReuseIdentifier: "RightMessageCell")
    
    load()
    // Do any additional setup after loading the view.
  }
  
  func load() {
    guard !isLoading, hasMoreData else { return }
    guard let chatID = chatInfo.chat?.id else { return }
    showProgress()
    isLoading = true
    
    firstly {
      network.request(type: Profile.self, url: "/v1/profile", method: .get, params: nil, encoding: URLEncoding.default)
    }.then { profile -> Promise<[Message]?> in
      UserDefaults.standard.set(profile?.userId, forKey: "userID")
      return self.network.request(type: [Message].self, url: "/v1/chat/\(chatID)/message", method: .get, params: [
        "limit": 20,
        "offset": self.messages.count
      ], encoding: URLEncoding.default)
    }.ensure {
      self.isLoading = false
      self.hideProgress()
    }.done { messages in
      self.hasMoreData = (messages?.count ?? 0) >= 20
      self.messages.append(contentsOf: messages ?? [])
      self.tableView.reloadData()
      self.setupTags()
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  @objc func sendMessage() {
    guard let message = messageTextField.text, !message.isEmpty, let chatID = chatInfo.chat?.id else { return }
    showProgress()
    
    AF.upload(multipartFormData: { formData in
      formData.append(message.data(using: .utf8) ?? Data(), withName: "messageText")
    }, to: network.baseURL + "/v1/chat/\(chatID)/message", headers: [
      "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "access") ?? "")"
    ], interceptor: network).responseData { response in
      self.hideProgress()
      switch response.result {
      case .success:
        print("success")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'[zzz]"
        self.messages.insert(Message(id: nil, text: message, user: User(name: nil, userId: UserDefaults.standard.string(forKey: "userID"), aboutMyself: nil, avatar: nil), createdAt: formatter.string(from: Date())), at: 0)
        self.messageTextField.text = ""
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
      case .failure(let error):
        print(error)
        self.showAlert(text: error.localizedDescription)
      }
    }
  }
  
  init(chatInfo: ChatInfo) {
    self.chatInfo = chatInfo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
  func setupTags() {
    var hStack = UIStackView()
    hStack.spacing = 8
    
    var width: CGFloat = 0
    
    let anotherUserID = messages.first { $0.user?.userId != (UserDefaults.standard.string(forKey: "userID") ?? "") }?.user?.userId
    
    let topics = getProfiles().first { $0.userId == anotherUserID }?.topics ?? []
    
    if topics.count > 0 {
      stackHeightConstaint?.deactivate()
    } else {
      stackHeightConstaint?.activate()
    }
    
    topics.forEach { topic in
      let tagView = TagView(title: topic.title)
      tagView.layoutIfNeeded()
      if width + tagView.frame.width + 8 <= UIScreen.main.bounds.width - 140 {
        hStack.addArrangedSubview(tagView)
        width += tagView.frame.width + 8
      } else {
        stackView.addArrangedSubview(hStack)
        hStack = UIStackView()
        hStack.spacing = 8
        hStack.addArrangedSubview(tagView)
        width = tagView.frame.width + 8
      }
    }
    
    stackView.addArrangedSubview(hStack)
  }
  
}



extension ChatViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = messages[indexPath.row]
    
    if indexPath.row == messages.count - 1 {
      load()
    }
    
    if message.user?.userId == UserDefaults.standard.string(forKey: "userID"), message.user?.userId != nil {
      let cell = tableView.dequeueReusableCell(withIdentifier: "RightMessageCell", for: indexPath)
      (cell as? RightMessageCell)?.configure(message: message)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMessageCell", for: indexPath)
      (cell as? LeftMessageCell)?.configure(message: message)
      return cell
    }
  }
}
