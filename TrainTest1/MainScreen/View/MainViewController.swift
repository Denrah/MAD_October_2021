//
//  MainViewController.swift
//  TrainTest1
//
//  Created by National Team on 31.10.2021.
//

import UIKit
import Kingfisher

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
  
  private let cardContainerView = UIView()
  
  private let viewModel: MainViewModel
  
  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    
    bindToViewModel()
    viewModel.loadData()
    // Do any additional setup after loading the view.
  }
  
  func makeCards() {
    cardContainerView.subviews.forEach { $0.removeFromSuperview() }
    viewModel.cardViewModels.reversed().forEach { cardViewModel in
      let card = UserCardView(viewModel: cardViewModel)
      cardContainerView.addSubview(card)
      card.snp.makeConstraints { make in
        make.edges.equalToSuperview()
      }
    }
  }
  
  @objc func likeUser() {
    viewModel.didLikeUser()
  }
  
  @objc func dislikeUser() {
    viewModel.didDislikeUser()
  }
  
  private func bindToViewModel() {
    viewModel.onDidStartRequest = { [weak self] in
      self?.showProgress()
    }
    viewModel.onDidFinishRequest = { [weak self] in
      self?.hideProgress()
    }
    viewModel.onDidLoadData = { [weak self] in
      self?.makeCards()
    }
    viewModel.onDidReceiveError = { [weak self] error in
      self?.showAlert(text: error.localizedDescription)
    }
    viewModel.onDidMarkedUser = { [weak self] in
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
        self?.cardContainerView.subviews.last?.alpha = 0
      } completion: { _ in
        self?.cardContainerView.subviews.last?.removeFromSuperview()
      }
    }
    viewModel.onDidSelectUser = { [weak self] profile in
      let vc = ProfileViewController(profile: profile)
      vc.onLikeUser = { [weak self] in
        self?.viewModel.didMarkUser()
      }
      self?.navigationController?.pushViewController(vc, animated: true)
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
