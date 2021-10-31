//
//  ChatViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class ChatViewController: BaseViewController {
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  let chatInfo: ChatInfo
  
  let messageTextField = UITextField()
  let sendButton = UIButton()
  
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
    view.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.leading.equalTo(imageView.snp.trailing).offset(25)
      make.top.equalTo(imageView)
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
    // Do any additional setup after loading the view.
  }
  
  @objc func sendMessage() {
    guard let message = messageTextField.text, !message.isEmpty, let chatID = chatInfo.chat?.id else { return }
    showProgress()
    network.request(type: Empty.self, url: "/v1/chat/\(chatID)/message", method: .post, params: [
      "messageText": message
    ], encoding: JSONEncoding.default).ensure {
      self.hideProgress()
    }.done { _ in
      
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
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
  
}
