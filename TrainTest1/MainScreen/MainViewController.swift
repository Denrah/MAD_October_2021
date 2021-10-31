//
//  MainViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Alamofire
import Kingfisher

class UserCardView: UIView {
  let profile: Profile
  
  var onLike: (() -> Void)?
  var onDislike: (() -> Void)?
  var onTap: ((Profile) -> Void)?
  
  init(profile: Profile) {
    self.profile = profile
    
    super.init(frame: .zero)
    
    layer.cornerRadius = 13
    clipsToBounds = true
    
    let imageView = UIImageView()
    imageView.backgroundColor = .gray
    imageView.contentMode = .scaleAspectFill
    imageView.kf.setImage(with: URL(string: profile.avatar ?? ""))
    addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    let bottomView = UIView()
    bottomView.backgroundColor = .dark2
    bottomView.layer.cornerRadius = 13
    addSubview(bottomView)
    bottomView.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(66)
    }
    
    let nameLabel = UILabel()
    nameLabel.textColor = .white
    nameLabel.font = .bpalB?.withSize(21)
    nameLabel.text = profile.name
    bottomView.addSubview(nameLabel)
    nameLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    let matchLabel = UILabel()
    matchLabel.textColor = .orange1
    matchLabel.font = .bpalB?.withSize(21)
    matchLabel.text = "0 Matches"
    bottomView.addSubview(matchLabel)
    matchLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(16)
      make.centerY.equalToSuperview()
    }
    
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan(gesure:))))
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hanleTap)))
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func hanleTap() {
    onTap?(profile)
  }
  
  @objc func didPan(gesure: UIPanGestureRecognizer) {
    
    
    switch gesure.state {
    case .began, .changed:
      let translation = gesure.translation(in: superview)
      let delta = translation.x / UIScreen.main.bounds.width
      transform = CGAffineTransform(translationX: translation.x, y: translation.y).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
    case .ended, .cancelled:
      let translation = gesure.translation(in: superview)
      let delta = translation.x / UIScreen.main.bounds.width
      
      if translation.x > UIScreen.main.bounds.width / 3 {
        onLike?()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: UIScreen.main.bounds.width * 2, y: 0).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
        }) { _ in
         
        }
      } else if translation.x < -UIScreen.main.bounds.width / 3 {
        onDislike?()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width * 2, y: 0).concatenating(CGAffineTransform(rotationAngle: (CGFloat.pi / 8) * delta))
        }) { _ in
         
        }
      } else {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
          self.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(CGAffineTransform(rotationAngle: .zero))
        }, completion: nil)
      }
    default:
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
        self.transform = CGAffineTransform(translationX: 0, y: 0).concatenating(CGAffineTransform(rotationAngle: .zero))
      }, completion: nil)
    }
  }
  
}

enum TabItem: Int, CaseIterable {
  case feed, chat, profile
  
  var icon: UIImage? {
    switch self {
    case .feed:
      return UIImage(named: "feed")
    case .chat:
      return UIImage(named: "chat")
    case .profile:
      return UIImage(named: "profile")
    }
  }
}

class TabButton: UIButton {
  override var intrinsicContentSize: CGSize {
    return CGSize(width: 40, height: 40)
  }
  
  var isActiveTab = false {
    didSet {
      if isActiveTab {
        tintColor = .orange2
        layer.shadowColor = UIColor.orange2.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.71
        layer.shadowRadius = 20
        layer.borderWidth = 2
        layer.borderColor = UIColor.orange2.cgColor
      } else {
        tintColor = .orange1
        layer.borderColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.clear.cgColor
      }
    }
  }
  
  var onTap: ((TabItem) -> Void)?
  
  let item: TabItem
  
  init(item: TabItem) {
    self.item = item
    super.init(frame: .zero)
    layer.cornerRadius = 10
    setImage(item.icon?.withRenderingMode(.alwaysTemplate), for: .normal)
    addTarget(self, action: #selector(handleTap), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @objc func handleTap() {
    onTap?(item)
  }
}

class TabbarView: UIView {
  let stackView = UIStackView()
  
  var onTap: ((TabItem) -> Void)?
  
  init() {
    super.init(frame: .zero)
    
    addSubview(stackView)
    stackView.axis = .horizontal
    stackView.alignment = .top
    stackView.distribution = .equalSpacing
    stackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(4)
      make.leading.trailing.equalToSuperview().inset(30)
      make.bottom.equalToSuperview()
    }
    
    let divider = UIView()
    divider.backgroundColor = .dark2
    addSubview(divider)
    divider.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview()
      make.height.equalTo(0.2)
    }
    
    TabItem.allCases.forEach { item in
      let item = TabButton(item: item)
      item.onTap = { item in
        self.onTap?(item)
      }
      stackView.addArrangedSubview(item)
    }
  }
  
  func select(item: TabItem) {
    stackView.arrangedSubviews.compactMap { $0 as? TabButton }.forEach { $0.isActiveTab = false }
    stackView.arrangedSubviews.compactMap { $0 as? TabButton }.first { $0.item == item }?.isActiveTab = true
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class MainViewController: BaseViewController {
  
  let cardContainerView = UIView()
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   
    
    let bgView = UIView()
    bgView.backgroundColor = .dark3
    bgView.layer.cornerRadius = 39
    bgView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    view.addSubview(bgView)
    bgView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(344)
    }
    
    let titleLabel = UILabel()
    titleLabel.textColor = .white
    titleLabel.text = "Trick or Treat?"
    titleLabel.font = .bpalB?.withSize(36)
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(21)
      make.top.equalTo(view.safeAreaLayoutGuide).inset(3)
      make.height.equalTo(63)
    }
    
    let bg1 = UIView()
    let bg2 = UIView()
    let bg3 = UIView()
    [bg1, bg2, bg3].forEach { bg in
      bg.backgroundColor = .dark2
      bg.layer.cornerRadius = 13
      bg.layer.shadowColor = UIColor.black.cgColor
      bg.layer.shadowOpacity = 0.12
      bg.layer.shadowRadius = 8
      bg.layer.shadowOffset = CGSize(width: 0, height: 3)
      view.addSubview(bg)
    }
    
    bg1.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(177)
      make.leading.trailing.equalToSuperview().inset(40)
      make.top.equalTo(titleLabel.snp.bottom)
    }
    
    bg2.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(189)
      make.leading.trailing.equalToSuperview().inset(30)
      make.top.equalTo(titleLabel.snp.bottom)
    }
    
    bg3.snp.makeConstraints { make in
      make.bottom.equalToSuperview().inset(202)
      make.leading.trailing.equalToSuperview().inset(20)
      make.top.equalTo(titleLabel.snp.bottom)
    }
    
    view.addSubview(cardContainerView)
    cardContainerView.snp.makeConstraints { make in
      make.edges.equalTo(bg3)
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
    
    let tabbar = TabbarView()
    view.addSubview(tabbar)
    tabbar.select(item: .feed)
    tabbar.snp.makeConstraints { make in
      make.height.equalTo(71)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    tabbar.onTap = { item in
      self.showTab(item: item)
    }
    
    likeBtn.addTarget(self, action: #selector(likeUser), for: .touchUpInside)
    dislikeBtn.addTarget(self, action: #selector(dislikeUser), for: .touchUpInside)
    
    getFeed()
    // Do any additional setup after loading the view.
  }
  
  func getFeed() {
    showProgress()
    network.request(type: [Profile].self, url: "/v1/user/feed", method: .get, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { profiles in
      self.makeCards(profiles: profiles ?? [])
    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  func makeCards(profiles: [Profile]) {
    cardContainerView.subviews.forEach { $0.removeFromSuperview() }
    profiles.reversed().forEach { profile in
      let card = UserCardView(profile: profile)
      card.onLike = { [weak self] in
        self?.likeUser()
      }
      card.onDislike = { [weak self] in
        self?.dislikeUser()
      }
      card.onTap = { [weak self] profile in
        let vc = ProfileViewController(profile: profile)
        vc.onLikeUser = { [weak self] in
          self?.cardContainerView.subviews.last?.removeFromSuperview()
        }
        self?.navigationController?.pushViewController(vc, animated: true)
      }
      cardContainerView.addSubview(card)
      card.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
  
  @objc func likeUser() {
    
    guard let profile = (cardContainerView.subviews.last as? UserCardView)?.profile else { return }
    
    print("Like \(profile.name ?? "")")
    
    showProgress()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/like", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { _ in
      self.saveProfile(profile)
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.cardContainerView.subviews.last?.alpha = 0
      } completion: { _ in
        self.cardContainerView.subviews.last?.removeFromSuperview()
      }

    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
  }
  
  @objc func dislikeUser() {
    guard let profile = (cardContainerView.subviews.last as? UserCardView)?.profile else { return }
    
    print("Dislike \(profile.name ?? "")")
    
    showProgress()
    network.request(type: Empty.self, url: "/v1/user/\(profile.userId ?? "")/like", method: .post, params: [:], encoding: URLEncoding.default).ensure {
      self.hideProgress()
    }.done { _ in
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self.cardContainerView.subviews.last?.alpha = 0
      } completion: { _ in
        self.cardContainerView.subviews.last?.removeFromSuperview()
      }

    }.catch { error in
      self.showAlert(text: error.localizedDescription)
    }
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


struct Empty: Codable {
  
}
