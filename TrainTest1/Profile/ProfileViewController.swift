//
//  ProfileViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire

class TagView: UIView {
  let titleLabel = UILabel()
  
  init(title: String?) {
    super.init(frame: .zero)
    
    backgroundColor = .orange2
    snp.makeConstraints { make in
      make.height.equalTo(24)
    }
    layer.cornerRadius = 12
    
    addSubview(titleLabel)
    titleLabel.font = .bpalB?.withSize(14)
    titleLabel.textColor = .dark1
    titleLabel.text = title
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(8)
    }
    
    
   
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

class ProfileViewController: BaseViewController {
  
  var onLikeUser: (() -> Void)?
  
  let profile: Profile
  
  let layer0 = CAGradientLayer()
  let bgView = UIView()
  
  let stackView = UIStackView()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    layer0.frame = bgView.frame
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   
    bgView.layer.cornerRadius = 39
    bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    
    
    layer0.colors = [
      UIColor(red: 0.376, green: 0.153, blue: 0.286, alpha: 1).cgColor,
      UIColor(red: 0.243, green: 0.11, blue: 0.2, alpha: 1).cgColor
    ]
    layer0.startPoint = CGPoint(x: 0.75, y: 0.25)
    layer0.endPoint = CGPoint(x: 0.25, y: 0.75)
    
    bgView.layer.addSublayer(layer0)
    bgView.clipsToBounds = true
    
    view.addSubview(bgView)
    bgView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(344)
    }
    
    let imgView = UIImageView()
    imgView.kf.setImage(with: URL(string: profile.avatar ?? ""))
    imgView.contentMode = .scaleAspectFill
    imgView.layer.cornerRadius = 84
    imgView.clipsToBounds = true
    view.addSubview(imgView)
    imgView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide).inset(11)
      make.centerX.equalToSuperview()
      make.size.equalTo(168)
    }
    
    let nameLbl = UILabel()
    nameLbl.text = profile.name
    view.addSubview(nameLbl)
    nameLbl.textColor = .white
    nameLbl.font = .bpalB?.withSize(36)
    nameLbl.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(imgView.snp.bottom).offset(10)
    }
    
    view.addSubview(stackView)
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.alignment = .center
    stackView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.equalTo(nameLbl.snp.bottom).offset(40)
    }
    
    setupTags()
    
    let aboutLbl = UILabel()
    aboutLbl.text = profile.aboutMyself
    aboutLbl.textColor = .white
    aboutLbl.numberOfLines = 0
    aboutLbl.textAlignment = .center
    aboutLbl.font = .bpalB?.withSize(14)
    view.addSubview(aboutLbl)
    aboutLbl.snp.makeConstraints { make in
      make.top.equalTo(stackView.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(32)
    }
    
    let likeBtn = UIButton()
    likeBtn.setImage(UIImage(named: "like"), for: .normal)
    view.addSubview(likeBtn)
    likeBtn.snp.makeConstraints { make in
      make.size.equalTo(70)
      make.trailing.equalToSuperview().inset(32)
      make.bottom.equalToSuperview().inset(88)
    }
    
    let dislikeBtn = UIButton()
    dislikeBtn.setImage(UIImage(named: "dislike"), for: .normal)
    view.addSubview(dislikeBtn)
    dislikeBtn.snp.makeConstraints { make in
      make.size.equalTo(70)
      make.leading.equalToSuperview().inset(32)
      make.bottom.equalToSuperview().inset(88)
    }
    
    
    likeBtn.addTarget(self, action: #selector(likeUser), for: .touchUpInside)
    dislikeBtn.addTarget(self, action: #selector(dislikeUser), for: .touchUpInside)
    
    // Do any additional setup after loading the view.
  }
  
  @objc func likeUser() {
    
    
    print("Like \(profile.name ?? "")")
    
    showProgress()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/like", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { _ in
      self.saveProfile(self.profile)
      self.onLikeUser?()
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  @objc func dislikeUser() {
   
    print("Dislike \(profile.name ?? "")")
    
    showProgress()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/like", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { _ in
      self.onLikeUser?()
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  init(profile: Profile) {
    self.profile = profile
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupTags() {
    var hStack = UIStackView()
    hStack.spacing = 8
    
    var width: CGFloat = 0
    
    profile.topics.forEach { topic in
      let tagView = TagView(title: topic.title)
      tagView.layoutIfNeeded()
      if width + tagView.frame.width + 8 <= UIScreen.main.bounds.width - 32 {
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
